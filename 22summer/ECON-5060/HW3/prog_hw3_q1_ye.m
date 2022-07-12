function census_data_analysis_hw(x)
% Select data given its main attributes:
% 1. age
% 2. gender=0 if male or 1 if female
% 3. years of education
x=[[1:10];[18 17 22 23 17 25 16 17 22 26];[1 0 0 1 0 1 0 1 1 1];[9 13 10 12 12 17 10 12 8 18]]';

%gender selection
males=gender_selector(x,0);
females=gender_selector(x,1);

%Drink ok selector
ok_drink=age_selector(x,0);
no_ok_drink=age_selector(x,0);

%select all males ok_drink
males_ok_drink=age_selector(males,1);
%select all females no_ok_drink
females_no_ok_drink=gender_selector(no_ok_drink,1);



% High school
% high school (<12) is 0, 1 is college or grad school
high_school_ed=edu_selector(x,0);

%college grad
grad_ed=edu_selector(x,1);

%male with grad edu
male_grad=gender_selector(grad_ed,0);

%All HS ok to drink
hs_ok_drink=age_selector(high_school_ed,1);

end