tic
close all
clearvars -except Year sec
set(0,'DefaultFigureVisible','off');
set(0,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');



%% DATA
load(sprintf('Start_%d.mat',Year+10)); %equilibrium invoicing
load(sprintf('IO_matrix_%d.mat',Year)); %IO table, countries, sectors
load(sprintf('ER_cov_%d.mat',Year)); %ER covariance matrix and pegs
load 'Invoicing.mat'; %empirical invoicing

N = size(Country,1); %number of countries (including RoW)
S = size(Sector,1); %number of sectors
K = size(Currency,1); %number of currencies (including US and DEU, excluding other pegs)
n = N*S; %number of markets

sec = (1:18)'; %sectors included in reported trade invoicing
ncom = (3:S)'; %non-commodity sectors
man = (3:18)'; %manufacturing sectors
ser = (19:S)'; %service sectors


%% INPUTS
id_USA = find(ismember(Country.Code,'USA')==1); %US number
id_DEU = find(ismember(Country.Code,'DEU')==1); %Germany number
id_CHN = find(ismember(Country.Code,'CHN')==1); %China number
id_c = kron((1:N)',ones(S,1)); %id of country (i) in a list of markets
id_s = repmat((1:S)',N,1); %id of sector (s) in a list of markets
R_pcp = zeros(N,K);
R_pcp(sub2ind([N K 3],(1:N)',Cur)) = 1; 
R_lcp = zeros(N,K,N);
for i = 1:N
    R_lcp(:,Cur(i),i) = 1;
end



%% TRADE SHARES (based on IO table not adjusted for commodities)
G_im = zeros(n,N);
Vol_im = zeros(S,N);
Vol_ag = zeros(S,N);
Vol_home = zeros(S,N);
for i = 1:S
    Vol_ag(i,:) = sum(IM(i:S:n,:),1); %total sales in market (ir) 
    Vol_home(i,:) = diag(IM(i:S:n,:)); %local sales in market (ir) 
    Vol_im(i,:) = sum(IM(i:S:n,:),1)-diag(IM(i:S:n,:))'; %total imports in market (ir) 
    G_im(i:S:S*N,:) = (IM(i:S:n,:)-diag(diag(IM(i:S:n,:))))./repmat(Vol_im(i,:),N,1); %country (j) shares in market (ir)
end
Vol_ex = zeros(S,N);
IT = IM; %international trade flows
for i = 1:N
    Vol_ex(:,i) = sum(IM(S*(i-1)+(1:S),:),2)-IM(S*(i-1)+(1:S),i); %total exports of (ik)
    IT(S*(i-1)+(1:S),i) = 0;
end

Vol_im_adj = zeros(S,N);
Vol_ex_adj = zeros(S,N);
Vol_im_adj(sec,:) = Vol_im(sec,:); %sectors used to compute trade invoicing
Vol_ex_adj(sec,:) = Vol_ex(sec,:); %sectors used to compute trade invoicing
Vol_im_share = Vol_im_adj./repmat(sum(Vol_im_adj,1),S,1); %sector shares in imports by country
Vol_ex_share = Vol_ex_adj./repmat(sum(Vol_ex_adj,1),S,1); %sector shares in exports by country
Vol_home_adj = zeros(S,N);
Vol_home_adj(man,:) = Vol_home(man,:); %sectors used to compute trade invoicing
Vol_home_share = Vol_home_adj./repmat(sum(Vol_home_adj,1),S,1); %sector shares in home by country

G_ex = IM; %export of (rj) across destinations (i)
G_ex(sub2ind([n N],(1:n)',id_c)) = 0; %exclude domestic trade
G_ex = G_ex./repmat(sum(G_ex,2),1,N); %convert into export shares
G_ex(isnan(G_ex)) = 0; %correct sectors with zero exports



%% TABLE A5
Pi_im = zeros(S,N,K); %currency shares for imports in market (ir)
Pi_home = zeros(S,N,K); %currency shares for home in market (ir)
for i = 1:S
    Pi_im(i,:,:) = sum(repmat(G_im(i:S:n,:),1,1,K).*PP(i:S:n,:,:),1);   
    for j = 1:K
        Pi_home(i,:,j) = diag(PP(i:S:n,:,j));
    end
end

Pi_im_c = sum(repmat(Vol_im_share,1,1,K).*Pi_im,1); %currencies in imports at country level
Pi_im_c = reshape(Pi_im_c,N,K); 
Model_im = [Pi_im_c(sub2ind([N K],(1:N)',Cur)) Pi_im_c(:,Cur(id_USA)) Pi_im_c(:,Cur(id_DEU))]; %LCP, DCP, ECP in imports by country
Pi_world = reshape(sum(sum(repmat(Vol_im_adj,1,1,K).*Pi_im,1),2),[],1)/sum(sum(Vol_im_adj)); %currencies' shares in world trade

Pi_ex = reshape(sum(repmat(G_ex,1,1,K).*PP,2),S,N,K); %export invoicing by country-sector (ik) and currency (n)
Pi_ex_c = sum(repmat(Vol_ex_share,1,1,K).*Pi_ex,1); %currencies in exports at country level
Pi_ex_c = reshape(Pi_ex_c,N,K); 
Model_ex = [Pi_ex_c(sub2ind([N K],(1:N)',Cur)) Pi_ex_c(:,Cur(id_USA)) Pi_ex_c(:,Cur(id_DEU))]; %LCP, DCP, ECP in exports by country

Pi_table = table(100*Model_im(:,1),100*Model_im(:,2),100*Model_im(:,3),100*Model_ex(:,1),100*Model_ex(:,2),100*Model_ex(:,3),'RowNames',Country.Name,'VariableNames',{'IM_LCP','IM_DCP','IM_ECP','EX_PCP','EX_DCP','EX_ECP'}); 

Pi_home_c = sum(repmat(Vol_home_share,1,1,K).*Pi_home,1); %currencies in domestic trade at country level (manufacturing)
Pi_home_c = reshape(Pi_home_c,N,K); 
Pi_home_table = table(100*Pi_home_c(sub2ind([N K],(1:N)',Cur)),100*Pi_home_c(:,Cur(id_USA)),100*Pi_home_c(:,Cur(id_DEU)),'RowNames',Country.Name,'VariableNames',{'LCP','DCP','ECP'}); 
Vol_home_adj_c = Vol_home_adj; 
Vol_home_adj_c(:,Country.Developed==1) = 0; %exclude developed countries
Vol_home_adj_c(:,end) = 0; %exclude RoW
Vol_home_adj_c = sum(Vol_home_adj_c,1)/sum(sum(Vol_home_adj_c)); %country shares in home sales (only emerging economies!)
Pi_home_EM = Vol_home_adj_c*Pi_home_c(sub2ind([N K],(1:N)',Cur)); %share of world domestic flows in local currency (only emerging economies!)



%% TABLE A6
G_ = repmat(IM,1,1,K).*PP; 
Pi_sec = reshape(sum(repmat(Vol_ex,1,1,K).*Pi_ex,2),S,K)./repmat(sum(Vol_ex,2),1,K); %trade invoicing for (all) sectors
Pi_sec_v = zeros(n,N); 
Pi_sec_p = zeros(n,N); 
Pi_sec_l = zeros(n,N); 
IM_com = zeros(n,N); 
IM1 = IM; 
G1 = G_; 
for i = 1:N
    IM1(S*(i-1)+(1:S),i) = 0; %delete internal trade flows
    G1(S*(i-1)+(1:S),i,:) = 0; %delete internal trade flows
end
for i = 1:N
    for j = 1:N
        v_ind = [Cur(j) Cur(i)]'; %PCP and LCP
        veh = setdiff((1:K)',v_ind); %vehicle currencies between j and i
        Pi_sec_v(S*(j-1)+(1:S),i) = sum(G1(S*(j-1)+(1:S),i,veh),3); %total trade in (jis) in vehicle currencies
        Pi_sec_p(S*(j-1)+(1:S),i) = G1(S*(j-1)+(1:S),i,Cur(j)); %total trade in (jis) in PCP
        Pi_sec_l(S*(j-1)+(1:S),i) = G1(S*(j-1)+(1:S),i,Cur(i)); %total trade in (jis) in LCP
        if Cur(j) == Cur(i)
            IM_com(S*(j-1)+(1:S),i) = IM1(S*(j-1)+(1:S),i); %trade between countries with the same currency
        end
    end
end

Pi_sec_vcp = zeros(S,1); 
Pi_sec_pcp = zeros(S,1); 
Pi_sec_lcp = zeros(S,1); 
TR_com = zeros(S,1); 
TR_sec = zeros(S,1);
for i = 1:S
    Pi_sec_vcp(i) = sum(sum(Pi_sec_v(i:S:n,:)))/sum(sum(IM1(i:S:n,:))); %share of trade in vcp by sector
    Pi_sec_pcp(i) = sum(sum(Pi_sec_p(i:S:n,:)))/sum(sum(IM1(i:S:n,:))); %share of trade in vcp by sector
    Pi_sec_lcp(i) = sum(sum(Pi_sec_l(i:S:n,:)))/sum(sum(IM1(i:S:n,:))); %share of trade in vcp by sector
    TR_com(i) = sum(sum(IM_com(i:S:n,:)))/sum(sum(IM1(i:S:n,:))); %share of trade between countries with same currencies by sector
    TR_sec(i) = sum(sum(IM1(i:S:n,:))); %volume of international trade in sector i
end
TR_share = TR_sec(sec)/sum(TR_sec(sec)); %sectoral shares in international merchandise trade
TR_share = [TR_share; zeros(length(ser),1)];

Pi_sec_table = table(100*TR_share,100*Pi_sec_pcp,100*Pi_sec_lcp,100*Pi_sec_vcp,100*Pi_sec(:,Cur(id_USA)),100*Pi_sec(:,Cur(id_DEU)),'RowNames',Sector.Name,'VariableNames',{'TR','PCP','LCP','VCP','DCP','ECP'});

Pi_3sec_vcp(1,1) = sum(Pi_sec_vcp(com).*sum(Vol_im(com,:),2))/sum(sum(Vol_im(com,:))); %share of vcp in commodities
Pi_3sec_vcp(2,1) = sum(Pi_sec_vcp(man).*sum(Vol_im(man,:),2))/sum(sum(Vol_im(man,:))); %share of vcp in manufacturing
Pi_3sec_vcp(3,1) = sum(Pi_sec_vcp(ser).*sum(Vol_im(ser,:),2))/sum(sum(Vol_im(ser,:))); %share of vcp in services
Pi_sec_ = [Pi_sec_pcp Pi_sec_lcp Pi_sec(:,Cur(id_USA)) Pi_sec(:,Cur(id_DEU)) TR_com];
Pi_3sec(1,:) = sum(Pi_sec_(com,:).*repmat(sum(Vol_ex(com,:),2),1,5),1)/sum(sum(Vol_ex(com,:))); %PCP,LCP,DCP,ECP in commodity sector
Pi_3sec(2,:) = sum(Pi_sec_(man,:).*repmat(sum(Vol_ex(man,:),2),1,5),1)/sum(sum(Vol_ex(man,:))); %PCP,LCP,DCP,ECP in manufacturing sector
Pi_3sec(3,:) = sum(Pi_sec_(ser,:).*repmat(sum(Vol_ex(ser,:),2),1,5),1)/sum(sum(Vol_ex(ser,:))); %PCP,LCP,DCP,ECP in services sector
Pi_3sec_table = table(Pi_3sec(:,1),Pi_3sec(:,2),Pi_3sec(:,3),Pi_3sec(:,4),Pi_3sec_vcp,Pi_3sec(:,5),'RowNames',{'Commodities','Manufacturing','Services'},'VariableNames',{'PCP','LCP','DCP','ECP','VCP','TR'});



%% TABLE 1
WT_im = sum(Vol_im_adj,1)'/sum(sum(Vol_im_adj)); %share of country's imports in global trade
WT_ex = sum(Vol_ex_adj,1)'/sum(sum(Vol_ex_adj)); %share of country's exports in global trade
WT_total = reshape(sum(IM,2),S,N); %total sales of (rj) 
WT_total = WT_total./repmat(sum(WT_total,2),1,N); %share of country (j) in global production of sector (s)
WT_cur = zeros(K,1);
for i = 1:K
    x = find(Cur==i); %pegs to currency (n)
    WT_cur(i) = sum(WT_im(x)+WT_ex(x))/2; %share of countries with currency (n) in world trade 
end
WT_cur(Cur(id_USA)) = WT_cur(Cur(id_USA))+RoW_USD*WT_cur(end); %split RoW share between USD and EUR
WT_cur(Cur(id_DEU)) = WT_cur(Cur(id_DEU))+(1-RoW_USD)*WT_cur(end); %split RoW share between USD and EUR
WT_cur(end) = 0; 

PP_naive = zeros(n,N,K); %naive invoicing = if half of each bilateral trade flow is in PCP and half in LCP + commodities in DCP
for i = 1:S
    if ismember(i,com)==1
        PP_naive(i:S:n,:,Cur(id_USA)) = 1; %DCP in commodity sectors  
    else
        for j = 1:N
            PP_naive(i:S:n,j,:) = 0.5*R_pcp+0.5*R_lcp(:,:,j); %PCP+LCP in manufacturing and services
        end
    end
end
PP_naive(:,:,Cur(id_USA)) = PP_naive(:,:,Cur(id_USA))+RoW_USD*PP_naive(:,:,end); %adjust for RoW currency
PP_naive(:,:,Cur(id_DEU)) = PP_naive(:,:,Cur(id_DEU))+(1-RoW_USD)*PP_naive(:,:,end); %adjust for RoW currency
PP_naive(:,:,end) = 0; %adjust for RoW currency
Pi_im_naive = zeros(S,N,K); %naive invoicing of imports by sector-country
for i = 1:S
    Pi_im_naive(i,:,:) = sum(repmat(G_im(i:S:n,:),1,1,K).*PP_naive(i:S:n,:,:),1);   
end
Pi_im_naive_c = reshape(sum(repmat(Vol_im_share,1,1,K).*Pi_im_naive,1),N,K); %naive invoicing of imports by country 
Pi_ex_naive = reshape(sum(repmat(G_ex,1,1,K).*PP_naive,2),S,N,K); %naive export invoicing by country-sector (ik) and currency (n)
Pi_ex_naive_c = reshape(sum(repmat(Vol_ex_share,1,1,K).*Pi_ex_naive,1),N,K); %naive export invoicing at country level
Pi_naive_world = reshape(sum(sum(repmat(Vol_im_adj,1,1,K).*Pi_im_naive,1),2),[],1)/sum(sum(Vol_im_adj)); %naive invoicing in world trade

Pi_im_naive_table = table(Pi_im_naive_c(sub2ind([N K],(1:N)',Cur)),Pi_im_naive_c(:,Cur(id_USA)),Pi_im_naive_c(:,Cur(id_DEU)),'RowNames',Country.Name,'VariableNames',{'LCP','DCP','ECP'}); 
Pi_ex_naive_table = table(Pi_ex_naive_c(sub2ind([N K],(1:N)',Cur)),Pi_ex_naive_c(:,Cur(id_USA)),Pi_ex_naive_c(:,Cur(id_DEU)),'RowNames',Country.Name,'VariableNames',{'PCP','DCP','ECP'}); 
Model_im_naive = table2array(Pi_im_naive_table);
Model_ex_naive = table2array(Pi_ex_naive_table);
Cur_table_full = table(100*WT_cur,100*Pi_naive_world,100*Pi_world,'RowNames',Currency.Name,'VariableNames',{'Trade','Naive','Currency'});

id_JPN = find(ismember(Country.Code,'JPN')==1); %id of Japan
id_GBR = find(ismember(Country.Code,'GBR')==1); %id of UK
id_ADV_cur = Cur(find(Country.Developed==1)); %other advanced economies
id_ADV_cur = setdiff(id_ADV_cur,Cur([id_USA id_DEU id_GBR id_JPN]));
id_EM_cur = Cur(find(Country.Developed==0)); %other developing
id_EM_cur = setdiff(id_EM_cur,Cur([id_USA id_DEU id_GBR id_JPN id_CHN]));
Cur_matrix = 100*[WT_cur Pi_naive_world Pi_world];
Cur_matrix = [Cur_matrix(Cur(id_USA),:); Cur_matrix(Cur(id_DEU),:); Cur_matrix(Cur(id_CHN),:); Cur_matrix(Cur([id_GBR;id_JPN]),:); sum(Cur_matrix(id_ADV_cur,:),1); sum(Cur_matrix(id_EM_cur,:),1)];
Cur_table = table(Cur_matrix(:,1),Cur_matrix(:,3),'RowNames',{'USA','DEU','CHN','GBR','JPN','ADV','EM'},'VariableNames',{'Trade','Invoicing'});



%% INVOICING DECOMPOSITION 
c = Cur(id_USA); %choose currency
s = (3:18)'; %choose sectors
Y = reshape(PP(:,:,c),[],1); %simualted invoicing by (jir)
x = find(ismember(repmat(id_s,N,1),s)==1); %included observations
d_j = repmat(id_c,N,1); %country of origin
d_i = kron((1:N)',ones(n,1)); %country of destination
d_r = repmat(id_s,N,1); %sector 
XX = [d_i d_j d_r]; %regressors
R2 = zeros(3,1);
for i = 1:3
    X = dummyvar(XX(:,i)); %create dummies
    X = X(x,:);
    X_id = find(sum(X,1)>0); %exclude columns with only zeros
    X = X(:,X_id);
    [~,~,~,~,stat] = regress(Y(x),X); 
    R2(i) = stat(1); %R^2 of regression (includes domestic invoicing!!!)
end

Wght = IT; %weights (exclude domestic flows)
Wght(ismember(id_s,s)==0,:) = 0; %exclude some sectors
Wght = Wght/sum(sum(Wght)); 
PP_mean = repmat(sum(sum(Wght.*PP(:,:,c))),n,N); %weighted mean invoicing 
PP_mean_i = repmat(sum(Wght.*PP(:,:,c),1)./sum(Wght,1),n,1); %weighted mean invoicing for each i
PP_mean_ji = zeros(n,N);
for j = 1:N
    for i = 1:N
        PP_mean_ji(S*(j-1)+(1:S),i) = repmat(sum(Wght(S*(j-1)+(1:S),i).*PP(S*(j-1)+(1:S),i,c))/sum(Wght(S*(j-1)+(1:S),i)),S,1); %weighted mean invoicing for each ji
    end
end
PP_mean_ji(isnan(PP_mean_ji)) = 0;
PP_vec = [reshape(PP(:,:,c),[],1) reshape(PP_mean_ji,[],1) reshape(PP_mean_i,[],1) reshape(PP_mean,[],1) reshape(Wght,[],1)]; %reshaped
PP_var = sum(PP_vec(:,5).*(PP_vec(:,1)-PP_vec(:,4)).^2); %total variance
PP_var(2,1) = sum(PP_vec(:,5).*(PP_vec(:,3)-PP_vec(:,4)).^2); %between-i variance
PP_var(3,1) = sum(PP_vec(:,5).*(PP_vec(:,2)-PP_vec(:,3)).^2); %between-ij variance
PP_var(4,1) = sum(PP_vec(:,5).*(PP_vec(:,1)-PP_vec(:,2)).^2); %between-r variance
PP_var(:,2) = 100*PP_var/sum(PP_var(2:4)); %convert into percent



%% FIGURES 8 & A8
decades = [1995;2005;2015;2025];
year = num2str(Year); 
id_y = find(decades==str2num(year(1:4)));
id_y = min(id_y,3); 

Data_im = IM_3Y(:,:,id_y)/100; %data on import invoicing
Data_ex = EX_3Y(:,:,id_y)/100; %data on export invoicing
IM_c_cov = reshape(nansum(IM_3Y,2),[],3); %data coverage per country-year
EX_c_cov = reshape(nansum(EX_3Y,2),[],3); %data coverage per country-year
Cov_im = sum(WT_im.*IM_c_cov(:,id_y)); %data coverage for global imports
Cov_ex = sum(WT_ex.*EX_c_cov(:,id_y)); %data coverage for global exports
Cov_trade = (Cov_im+Cov_ex)/2; %data coverage for global imports+exports

peg_USD1 = peg_USD(~isnan(Data_im(peg_USD,2))); %pegs to dollar with non-missing DCP in imports
peg_USD2 = intersect(peg_USD,find(~isnan(Data_ex(:,2)))); %pegs to dollar with non-missing DCP in exports
peg_EUR1 = intersect(peg_EUR,find(~isnan(Data_im(:,3)))); %pegs to euro with non-missing ECP in imports
peg_EUR2 = intersect(peg_EUR,find(~isnan(Data_ex(:,3)))); %pegs to euro with non-missing ECP in exports

Data_im(peg_USD1,1:2) = repmat(nansum(Data_im(peg_USD1,1:2),2),1,2); %LCP=DCP for dollar pegs
Data_im(peg_EUR1,[1 3]) = repmat(nansum(Data_im(peg_EUR1,[1 3]),2),1,2); %LCP=ECP for euro pegs
Data_ex(peg_USD2,1:2) = repmat(nansum(Data_ex(peg_USD2,1:2),2),1,2); %PCP=DCP for dollar pegs
Data_ex(peg_EUR2,[1 3]) = repmat(nansum(Data_ex(peg_EUR2,[1 3]),2),1,2); %PCP=ECP for euro pegs

Data_im(peg_USD(isnan(Data_im(peg_USD,2))),1) = NaN; %if DCP is missing for dollar peg, than LCP/PCP = NaN as well
Data_ex(peg_USD(isnan(Data_ex(peg_USD,2))),1) = NaN; %if DCP is missing for dollar peg, than LCP/PCP = NaN as well
Data_im(peg_EUR(isnan(Data_im(peg_EUR,3))),1) = NaN; %if ECP is missing for euro peg, than LCP/PCP = NaN as well
Data_ex(peg_EUR(isnan(Data_ex(peg_EUR,3))),1) = NaN; %if ECP is missing for euro peg, than LCP/PCP = NaN as well

if Year>2015
    M = load('Invoicing_2015.mat'); %compare counterfactual to model invoicing in 2015
    Data_im = M.Model_im;
    Data_ex = M.Model_ex;
end

Data_im_table = table(Country.Name,Data_im); %LCP, DCP, ECP
Data_ex_table = table(Country.Name,Data_ex); %PCP, DCP, ECP

Fit_im = zeros(3,6);
Fit_ex = zeros(3,6);
for i = 1:3
    id_im = find(~isnan(Data_im(:,i))); %countries with not missing data
    Fit_im(i,1) = corr(Data_im(id_im,i),Model_im(id_im,i)); %correlation of actual and predicted import invoicing across countries
    x = weightedcorrs([Data_im(id_im,i) Model_im(id_im,i)],WT_im(id_im));
    Fit_im(i,2) = x(1,2); %weighted corr of actual and predicted import invoicing across countries
    Fit_im(i,3) = 1-sum((Data_im(id_im,i)-Model_im(id_im,i)).^2)/sum((Data_im(id_im,i)-mean(Data_im(id_im,i))).^2); %1-errors^2/var(y)
    Fit_im(i,4) = 1-sum(WT_im(id_im).*(Data_im(id_im,i)-Model_im(id_im,i)).^2)/sum(WT_im(id_im).*(Data_im(id_im,i)-mean(Data_im(id_im,i))).^2); %1-errors^2/var(y) weighted
    Fit_im(i,5) = 1-sum(WT_im(id_im).*(Data_im(id_im,i)-Model_im_naive(id_im,i)).^2)/sum(WT_im(id_im).*(Data_im(id_im,i)-mean(Data_im(id_im,i))).^2); %1-errors^2/var(y) weighted for naive model
    x = weightedcorrs([Data_im(id_im,i) Model_im_naive(id_im,i)],WT_im(id_im));
    Fit_im(i,6) = x(1,2); %weighted corr of actual and predicted import invoicing for naive model
    
    id_ex = find(~isnan(Data_ex(:,i)));
    Fit_ex(i,1) = corr(Data_ex(id_ex,i),Model_ex(id_ex,i)); %correlation of actual and predicted export invoicing across countries
    x = weightedcorrs([Data_ex(id_ex,i) Model_ex(id_ex,i)],WT_ex(id_ex));
    Fit_ex(i,2) = x(1,2); %weighted corr of actual and predicted export invoicing across countries
    Fit_ex(i,3) = 1-sum((Data_ex(id_ex,i)-Model_ex(id_ex,i)).^2)/sum((Data_ex(id_ex,i)-mean(Data_ex(id_ex,i))).^2); %1-errors^2/var(y)
    Fit_ex(i,4) = 1-sum(WT_ex(id_ex).*(Data_ex(id_ex,i)-Model_ex(id_ex,i)).^2)/sum(WT_ex(id_ex).*(Data_ex(id_ex,i)-mean(Data_ex(id_ex,i))).^2); %1-errors^2/var(y) weighted
    Fit_ex(i,5) = 1-sum(WT_ex(id_ex).*(Data_ex(id_ex,i)-Model_ex_naive(id_ex,i)).^2)/sum(WT_ex(id_ex).*(Data_ex(id_ex,i)-mean(Data_ex(id_ex,i))).^2); %1-errors^2/var(y) weighted for naive model
    x = weightedcorrs([Data_ex(id_ex,i) Model_ex_naive(id_ex,i)],WT_ex(id_ex));
    Fit_ex(i,6) = x(1,2); %weighted corr of actual and predicted export invoicing for naive model
end

Name_im = {sprintf('IM_LCP_%d.eps',Year);sprintf('IM_DCP_%d.eps',Year);sprintf('IM_ECP_%d.eps',Year)}; %variables/names of files
for i = 1:3
    figure
    scatter(Data_im(:,i),Model_im(:,i),10000*WT_im)
    hold on
    plot((0:0.01:1),(0:0.01:1),'k')
    for j = 1:N
        text(Data_im(j,i),Model_im(j,i),Country.Code(j),'FontSize',10+30*WT_im(j))
    end
    if Year<=2015
        text(0.1,0.9,['$R^2=$',num2str(Fit_im(i,4),'%0.2f')],'FontSize',18,'Interpreter','latex')
    end
    xlabel('Data','FontSize',18)
    ylabel('Model','FontSize',18)
    xticks((0:0.2:1))
    yticks((0:0.2:1))
    ax = gca;
    ax.XAxis.FontSize = 14;
    ax.YAxis.FontSize = 14;
    box on
    file = Name_im(i);
    f = fullfile('../Figures',file);
    exportgraphics(gcf,f{1},'ContentType','vector')
end

Name_ex = {sprintf('EX_PCP_%d.eps',Year);sprintf('EX_DCP_%d.eps',Year);sprintf('EX_ECP_%d.eps',Year)}; %variables/names of files
for i = 1:3
    figure
    scatter(Data_ex(:,i),Model_ex(:,i),10000*WT_ex)
    hold on
    plot((0:0.01:1),(0:0.01:1),'k')
    for j = 1:N
        text(Data_ex(j,i),Model_ex(j,i),Country.Code(j),'FontSize',10+30*WT_ex(j))
    end
    if Year<=2015
        text(0.1,0.9,['$R^2=$',num2str(Fit_ex(i,4),'%0.2f')],'FontSize',18,'Interpreter','latex')
    end
    xlabel('Data','FontSize',18)
    ylabel('Model','FontSize',18)
    xticks((0:0.2:1))
    yticks((0:0.2:1))
    ax = gca;
    ax.XAxis.FontSize = 14;
    ax.YAxis.FontSize = 14;
    box on
    file = Name_ex(i);
    f = fullfile('../Figures',file);
    exportgraphics(gcf,f{1},'ContentType','vector')
end

save(sprintf('/Invoicing_%d.mat',Year),'Data_im','Data_ex','Model_im','Model_ex','Country','WT_im','WT_ex','fc0'); %save invoicing for dynamic analysis

Name_im = {sprintf('IM_LCP_naive_%d.eps',Year);sprintf('IM_DCP_naive_%d.eps',Year);sprintf('IM_ECP_naive_%d.eps',Year)}; %variables/names of files
for i = 1:3
    figure
    scatter(Data_im(:,i),Model_im_naive(:,i),10000*WT_im)
    hold on
    plot((0:0.01:1),(0:0.01:1),'k')
    for j = 1:N
        text(Data_im(j,i),Model_im_naive(j,i),Country.Code(j),'FontSize',10+30*WT_im(j))
    end
    text(0.1,0.9,['$R^2=$',num2str(Fit_im(i,5),'%0.2f')],'FontSize',18,'Interpreter','latex')
    xlabel('Data','FontSize',18)
    ylabel('Model','FontSize',18)
    xticks((0:0.2:1))
    yticks((0:0.2:1))
    ax = gca;
    ax.XAxis.FontSize = 14;
    ax.YAxis.FontSize = 14;
    box on
    file = Name_im(i);
    f = fullfile('../Figures',file);
    exportgraphics(gcf,f{1},'ContentType','vector')
end

Name_ex = {sprintf('EX_PCP_naive_%d.eps',Year);sprintf('EX_DCP_naive_%d.eps',Year);sprintf('EX_ECP_naive_%d.eps',Year)}; %variables/names of files
for i = 1:3
    figure
    scatter(Data_ex(:,i),Model_ex_naive(:,i),10000*WT_ex)
    hold on
    plot((0:0.01:1),(0:0.01:1),'k')
    for j = 1:N
        text(Data_ex(j,i),Model_ex_naive(j,i),Country.Code(j),'FontSize',10+30*WT_ex(j))
    end
    text(0.1,0.9,['$R^2=$',num2str(Fit_ex(i,5),'%0.2f')],'FontSize',18,'Interpreter','latex')
    xlabel('Data','FontSize',18)
    ylabel('Model','FontSize',18)
    xticks((0:0.2:1))
    yticks((0:0.2:1))
    ax = gca;
    ax.XAxis.FontSize = 14;
    ax.YAxis.FontSize = 14;
    box on
    file = Name_ex(i);
    f = fullfile('../Figures',file);
    exportgraphics(gcf,f{1},'ContentType','vector')
end



%% FIGURE 7
id_d = find(isnan(Data_ex(:,2))==0); %countries with known empirical DCP share in exports
World(1,:) = [sum(sum(Vol_ex_adj(com,id_d)))/sum(sum(Vol_ex_adj(:,id_d))) 0 0]; %share of commodities in world exports (excluding 
World(2:3,1) = [sum(sum(Vol_ex_adj(ncom,intersect(peg_USD,id_d))))/sum(sum(Vol_ex_adj(:,id_d))); sum(sum(Vol_ex_adj(ncom,intersect(peg_EUR,id_d))))/sum(sum(Vol_ex_adj(:,id_d)))]; %share of U.S. and Eurozone in world exports
World(2:3,2) = [nansum(WT_ex.*Data_ex(:,2))/sum(WT_ex(id_d)); nansum(WT_ex.*Data_ex(:,3))/sum(WT_ex(id_d))]; %empirical shares of DCP and ECP in world exports
World(2:3,3) = [nansum(WT_ex(id_d).*Model_ex(id_d,2))/sum(WT_ex(id_d)); nansum(WT_ex(id_d).*Model_ex(id_d,3))/sum(WT_ex(id_d))]; %model shares of DCP and ECP in world exports
World(2,2:3) = World(2,2:3); %subtract commodities from DCP share
World(4,:) = 1-sum(World(1:3,:),1); %shares of other currencies 
World = World([2 1 3 4],:); %change the order of USD and commodities

bars = categorical({'Trade','Data','Model';}); %names of bars
bars = reordercats(bars,{'Trade','Data','Model'}); %preseve the order
figure 
b = bar(bars,World','stacked','FaceColor','flat');
legend([b(1) b(3) b(2) b(4)],'USD $\;\;$','EUR $\;\;$','Commodities $\;\;$','Other','Location','Southoutside','Orientation','horizontal','FontSize',18,'Interpreter','Latex')
legend('boxoff')
b(1).CData = [1 0 0];
b(2).CData = [1 0.5 0];
b(3).CData = [0 0 1];
b(4).CData = [0.5 0.5 0.5];
set(gca,'FontSize',17)
exportgraphics(gcf,sprintf('World_bar_ex_%d.eps',Year),'ContentType','vector')


%% FIGURE A7
id_d = find(isnan(Data_im(:,2))==0); %countries with known empirical DCP share in exports
World_(1,:) = [sum(sum(Vol_im_adj(com,id_d)))/sum(sum(Vol_im_adj(:,id_d))) 0 0]; %share of commodities in world exports (excluding 
World_(2:3,1) = [sum(sum(Vol_im_adj(ncom,intersect(peg_USD,id_d))))/sum(sum(Vol_im_adj(:,id_d))); sum(sum(Vol_im_adj(ncom,intersect(peg_EUR,id_d))))/sum(sum(Vol_im_adj(:,id_d)))]; %share of U.S. and Eurozone in world exports
World_(2:3,2) = [nansum(WT_im.*Data_im(:,2))/sum(WT_im(id_d)); nansum(WT_im.*Data_im(:,3))/sum(WT_im(id_d))]; %empirical shares of DCP and ECP in world exports
World_(2:3,3) = [nansum(WT_im(id_d).*Model_im(id_d,2))/sum(WT_im(id_d)); nansum(WT_im(id_d).*Model_im(id_d,3))/sum(WT_im(id_d))]; %model shares of DCP and ECP in world exports
World_(2,2:3) = World_(2,2:3); %subtract commodities from DCP share
World_(4,:) = 1-sum(World_(1:3,:),1); %shares of other currencies 
World_ = World_([2 1 3 4],:); %change the order of USD and commodities

bars = categorical({'Trade','Data','Model';}); %names of bars
bars = reordercats(bars,{'Trade','Data','Model'}); %preseve the order
figure 
b = bar(bars,World_','stacked','FaceColor','flat');
legend([b(1) b(3) b(2) b(4)],'USD $\;\;$','EUR $\;\;$','Commodities $\;\;$','Other','Location','Southoutside','Orientation','horizontal','FontSize',18,'Interpreter','Latex')
legend('boxoff')
b(1).CData = [1 0 0];
b(2).CData = [1 0.5 0];
b(3).CData = [0 0 1];
b(4).CData = [0.5 0.5 0.5];
set(gca,'FontSize',17)
exportgraphics(gcf,sprintf('World_bar_im_%d.eps',Year),'ContentType','vector')


toc