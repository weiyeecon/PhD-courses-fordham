
%% Added by Wei Ye. I put all the data(csv file) into the same dictionary of m files, so i don't need to add
% address, just read directly. But if we run this file, it will shows many
% errors, because it requires many mat data loaded. It's huge work. Not
% done yet, just like What I said in the report, I need to fix the
% replication later during the summer. I found replicating paper is a long
% process.............25 m.files....sigh..
tic 
clear


%% PRELIMINARIES
Year = 1995; 
ICIO_rev3; %clean ICIO-rev3-1995 table 
Year = 2005; 
ICIO_rev4; %clean ICIO-rev4-2005 table
Year = 2015; 
ICIO_rev4; %clean ICIO-rev4-2015 table

Year = 2015; 
ICIO_GDP; %GDP shares



%% INPUTS
Year = 1995;
ER_cov; %ER and inflation in 1995
Year = 2005;
ER_cov; %ER and inflation in 2005
Year = 2015;
ER_cov; %ER and inflation in 2015

Year = 1995;
ICIO; %IO table in 1995
Year = 2005;
ICIO; %IO table in 2005
Year = 2015;
ICIO; %IO table in 2015

Invoicing; %empirical moments



%% SOLVING FOR EQUILIBRIUM
Start; %pre-1995 invoicing
Year = 1995; 
Model; %solve for equilibrium
Year = 2005; 
Model; %solve for equilibrium
Year = 2015; 
Model; %solve for equilibrium



%% MODEL FIT
Year = 1995; 
Fit; %tables and figures with currency choice
Year = 2005; 
Fit; %tables and figures with currency choice
Year = 2015; 
Fit; %tables and figures with currency choice

Fit_Swiss; %changes in invoicing in time

Fit_dyn; %changes in invoicing in time



%% COUNTERFACTUAL #1
T = 20; %horizon of forecast
Gravity; %new trade flows 
Year = 2015; 
ER_cov; %ER and inflation
save('ER_cov_2025.mat','Sigma','Inflation','Currency','Cur','peg_USD','peg_EUR','RoW_USD');
Year = 2025; 
Model; %solve for equilibrium
save(sprintf('Start_%d_1.mat',Year+10),'PP','IM'); 



%% COUNTERFACTUAL #2
T = 0; %horizon of forecast
Gravity; %new trade flows 
Year = 2015; 
ER_cov; %ER and inflation
Sigma(Cur(id_CHN),:) = 0; %zero correlation of China ER with other ERs
Sigma(:,Cur(id_CHN)) = 0; %zero correlation of China ER with other ERs
Sigma(Cur(id_CHN),Cur(id_CHN)) = Sigma(Cur(id_USA),Cur(id_USA)); %China ER volatility as for the dollar
save('ER_cov_2025.mat','Sigma','Inflation','Currency','Cur','peg_USD','peg_EUR','RoW_USD');
Year = 2025; 
Model; %solve for equilibrium
save(sprintf('Start_%d_2.mat',Year+10),'PP','IM'); 



%% COUNTERFACTUAL #3
Year = 2015; 
ER_cov; %ER and inflation
Sigma(Cur(id_CHN),:) = Sigma(Cur(id_USA),:); %China ER as today's US
Sigma(:,Cur(id_CHN)) = Sigma(:,Cur(id_USA)); %China ER as today's US
Sigma(Cur(id_USA),:) = 0; %zero correlation of US ER with other ERs
Sigma(:,Cur(id_USA)) = 0; %zero correlation of US ER with other ERs
Sigma(Cur(id_USA),Cur(id_USA)) = Sigma(Cur(id_CHN),Cur(id_CHN)); %US ER volatility as before
save('ER_cov_2025.mat','Sigma','Inflation','Currency','Cur','peg_USD','peg_EUR','RoW_USD');
Year = 2025; 
Model; %solve for equilibrium
save(sprintf('Start_%d_3.mat',Year+10),'PP','IM'); 



%% COUNTERFACTUAL #4
Year = 2015; 
ER_cov; %ER and inflation
Inflation(Cur(id_USA)) = 10; %high inflation in the U.S.
save('ER_cov_2025.mat','Sigma','Inflation','Currency','Cur','peg_USD','peg_EUR','RoW_USD');
Year = 2025; 
Model; %solve for equilibrium
save(sprintf('Start_%d_4.mat',Year+10),'PP','IM');


%% FIGURE 11
Fit_future; %counterfactuals


%% FIGURE 6 
Year = 2015;
ER_cov; %ER and inflation in 2015


%% TABLE 1: COLUMN 3
Year = 2015; 
Fit_service; 


%% TABLE 1: COLUMN 4
Year = 1995; 
Model_VCP; 
Year = 2005; 
Model_VCP; 
Year = 2015; 
Model_VCP; 
Fit_cur; 


%% TABLE 1: COLUMN 5
Year = 1995; 
Model_home; 
Fit_cur; 
Year = 2005; 
Model_home; 
Year = 2015; 
Model_home; 
Fit_cur; 


%% TABLE 1: COLUMN 6
Year = 1995; 
Model_inf; 
Year = 2005; 
Model_inf; 
Year = 2015; 
Model_inf; 
Fit_cur; 


%% TABLE 1: COLUMN 8
Year = 1995; 
Model_flex; 
Year = 2005; 
Model_flex; 
Year = 2015; 
Model_flex; 
Fit_cur; 


%% TABLE 1: COLUMN 7
Start_IRR; 
Year = 1995; 
Model; 
Year = 2005; 
Model; 
Year = 2015; 
Model; 
Year = 1995; 
Fit_cur; 
Year = 2015; 
Fit_cur; 


%% EURO INVOICING
Start_EUR; 
Year = 1995; 
Model; 
Year = 2005; 
Model; 
Year = 2015; 
Model; 
Fit_cur; 


toc