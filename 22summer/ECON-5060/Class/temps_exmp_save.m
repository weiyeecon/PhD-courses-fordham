function temps_exmp_save

%this program shows how to append columns to existing datasets.
%pwd to find current directory
directory='/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/';   %directory where the data and programs are located

project_name='temps_save';

%read the data
u=['[temps,labs]=xlsread(''' directory project_name '.xls''' ',''' 'Sheet1'   ''');'];
eval(u);

sav=1; %save results

nobs=size(temps);
d=1:nobs(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find sum and average per columns 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sum_col=sum(temps,2);
avg_col=mean(temps,2);

if sav==1
    maxobs=size(temps,1);
    col_name={'Sum','Average'};
    u=['xlswrite(''' directory project_name '.xls''' ',col_name,''' 'Sheet1''' '' ',''' 'd1' ''');'];
    eval(u);
    u=['xlswrite(''' directory project_name '.xls''' ',sum_col,''' 'Sheet1''' '' ',''' 'd2:d' num2str(maxobs+1) ''');'];
    eval(u);
    u=['xlswrite(''' directory project_name '.xls''' ',avg_col,''' 'Sheet1''' '' ',''' 'e2:e' num2str(maxobs+1) ''');'];
    eval(u);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some descriptive statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temps_orig=temps(:,1:3);        %to use the original dataset
avg_temp=mean(temps_orig);			%";" to NOT show results
avg_avg=mean(avg_temp);			%mean of means

max_temp=max(temps_orig);
[max_temp, i]=max(temps_orig);

min_temp=min(temps_orig);
[min_temp, i]=min(temps_orig);

s_dev=std(temps_orig);

daily_change=diff(temps_orig);

corr_all=corrcoef(temps_orig)

temps_part=temps(find(temps_orig(:,1)>10),:);

corr_part=corrcoef(temps_part);

if sav==1
    u=['xlswrite(''' directory project_name '.xls''' ',daily_change,''' 'daily change''' '' ',''' 'a1' ''');'];
    eval(u);
    u=['xlswrite(''' directory project_name '.xls''' ',corr_all,''' '3''' '' ',''' 'a1' ''');'];
    eval(u);
    u=['xlswrite(''' directory project_name '.xls''' ',avg_temp,''' 'avg_temp''' '' ',''' 'a1' ''');'];
    eval(u);
end

%create a table:
temps_orig=temps(:,1:3);
means=mean(temps_orig)
stdevs=std(temps_orig)
medians=median(temps_orig)
correl_mat=corrcoef(temps_orig)

mat_exp=[means',stdevs',medians',[correl_mat(1,2);correl_mat(1,3);correl_mat(2,3)]]

if sav==1
    maxobs=size(mat_exp,1);
    col_name={'mean','stdev','median','corr'};
    %col_name={'city/stat','Sum','Average'};
    row_name={'c1';'c2';'c3'};
    u=['xlswrite(''' directory project_name '.xls''' ',col_name,''' 'table''' '' ',''' 'b1:e1' ''');'];
    eval(u);
    u=['xlswrite(''' directory project_name '.xls''' ',row_name,''' 'table''' '' ',''' 'a2' ''');'];
    eval(u);
    u=['xlswrite(''' directory project_name '.xls''' ',mat_exp,''' 'table''' '' ',''' 'b2:e' num2str(maxobs+1) ''');'];
    eval(u);
end
d

% xlswrite('C:\Users\Erick\Documents\Courses\summer 2017\prog\matlab files\temps_exp.xls',daily_change);
% xlswrite('C:\Users\Erick\Documents\Courses\summer 2017\prog\matlab files\temps_exp.xls',corr_all,2);
% xlswrite('C:\Users\Erick\Documents\Courses\summer 2017\prog\matlab files\temps_exp.xls',avg_temp,'mean');

