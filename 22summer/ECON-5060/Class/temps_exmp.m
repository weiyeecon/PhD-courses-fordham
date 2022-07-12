function temps_exmp

%load('C:\Program Files\MATLAB704\work\programing\temps.txt');
%load('C:\Program Files\MATLAB704\work\temps.txt');
%load C:\temps.txt; %to upload a txt (tab delimited file)

%load('C:\Users\Erick\Documents\Courses\summer 2017\prog\matlab files\temps.txt');
erick=0;

if erick==0
    [temps,headertext]=xlsread('/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/temps.xls')
else
    [temps,headertext]=xlsread('/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/temps.xls')
end

nobs=size(temps);
d=1:31;

plot(d, temps);
xlabel('Day of Month'), ylabel('Celsius');
title('Daily High Temperatures in three cities');

figure;								%not to lose previous plot

hist(temps(:,1));					%histogram of tmeps first city
xlabel('class limits'), ylabel('frequency');
title('Histogram of daily temperatures, city 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some descriptive statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

avg_temp=mean(temps)				%no ";" to show results
avg_avg=mean(avg_temp)			%mean of means

max_temp=max(temps)
[max_temp, i]=max(temps)

min_temp=min(temps)
[min_temp, i]=min(temps)

s_dev=std(temps)

daily_change=diff(temps)

corr_all=corrcoef(temps)

temps_part=temps(find(temps(:,1)>10),:)

corr_part=corrcoef(temps_part)

xlswrite('/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/temps_exp1.xls',daily_change);
xlswrite('/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/temps_exp2.xls',corr_all,2);%2 for sheet
xlswrite('/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/temps_exp3.xls',avg_temp,'mean');
d %testing
