function triamicin_kids
%%%Created by Wei Ye
%%%Date: June 26, 2022

%%
%since i put xlsx file into the same directory of this m file, there is 
%no need to define directory anymore.
triamicinkids=readtable("data_statistical_analysis_triamicinkids.xlsx");
% the data is 104 by 6.
%% b.Rename the columns
%Starting in R2020a(I use R2021a), We can start use “renamevars”.
%Therefore, I use renamevars to rename columns directly.
triamicinkids=renamevars(triamicinkids,["brand","date",'brandNumber',
    "DOLLLARSALES","UNITSALES","AVGUNITPRICE"],["brand","date",'brandNumber',
    "dollarSales","unitSales","avgUnitPrice"]);

%%
%%%%c. Present the descriptive stat of the units per years. and export the 
%%%%results to Excel's sheet called 'desc_stats'.
mean_1year=mean(table2array(triamicinkids(1:52,5)));
median_1year=median(table2array(triamicinkids(1:52,5)));
std_1year=std(table2array(triamicinkids(1:52,5)));
mean_2year=mean(table2array(triamicinkids(53:104,5)));
median_2year=median(table2array(triamicinkids(53:104,5)));
std_2year=std(table2array(triamicinkids(53:104,5)));
desc_stat=[mean_1year,median_1year,std_1year,mean_2year,median_2year,std_2year];
writematrix(desc_stat,'data_statistical_analysis_triamicinkids.xlsx','Sheet','desc_stats');

%%
%%% question d:
year1_dollars=triamicinkids{1:52,4};
year1_unit=triamicinkids{1:52,5};
year2_dollars=triamicinkids{53:104,4};
year2_unit=triamicinkids{53:104,5};
corr_year1_sale_unit=corrcoef(year1_dollars,year1_unit);
corr_year2_sale_unit=corrcoef(year2_dollars,year2_unit);
corr_year1_2_sale=corrcoef(year1_dollars,year2_dollars);
question_d=[corr_year1_sale_unit;corr_year2_sale_unit;corr_year1_2_sale];
writematrix(question_d,'data_statistical_analysis_triamicinkids.xlsx','Sheet','year_corr');

%%
%%% Question e.
%%%%Because we can't use plot() to plot a table, matlab recommends
%%%%stackedplot, however, stackedplot doesn't allow to use hold on method.
%%%%We first transfer table data to 1-D array, then plot them.

plot(1:52,year1_dollars,'r');
hold on
plot(1:52,year2_dollars,'b');
saveas(gcf,'question_e','epsc');
hold off

%%
%%%Question f.
salesunit_1=triamicinkids{1:52,5};
salesunit_2=triamicinkids{53:104,5};
p1=polyfit(salesunit_1,year1_dollars,3);
p2=polyfit(salesunit_2,year2_dollars,3);
v1=polyval(p1,salesunit_1);
v2=polyval(p2,salesunit_2);
figure
plot(salesunit_1,v1);
figure
plot(salesunit_2,v2);

%For the plot of first year salesunit is a line.
%For the plot of second year, it's a not a straight, instead it's a line
%with kinks.


%%
%%%%Question g
unitsales=triamicinkids{:,5};
dollarsales=triamicinkids{:,4};
p3=polyfit(unitsales,dollarsales,3);
p6=polyfit(unitsales,dollarsales,6);
v3=ployval(p3,unitsales);
v6=ployval(p6,unitsales);
%%
%%%%Question h
plot(unitsales,dollarsales);
title('Units and dolalr sales relationship');
xlabel('units');
ylabel('dollar sales');

saveas(gcf,'question_h','epsc');

%There is no specific relation (like linear or nonlinear)because there are
%many kinds in the plot. However, there is upward linear trend from the
%figure. 

%%
%%%Question i
p_i_1=polyfit(unitsales,dollarsales,1);
p_i_2=polyfit(unitsales,dollarsales,2);
v_i_1=polyval(p_i_1,unitsales);
v_i_2=polyval(p_i_2,unitsales);
plot(unitsales,v_i_1);
hold on
plot(unitsales,v_i_2);
hold off

%From the table, the second order seems much better, b/c it makes the
%figure smoother. 


%%
%%% Question j

writematrix(v_i_1,'data_statistical_analysis_triamicinkids.xlsx','Sheet','poly1')
writematrix(v_i_2,'data_statistical_analysis_triamicinkids.xlsx','Sheet','poly2')


end
