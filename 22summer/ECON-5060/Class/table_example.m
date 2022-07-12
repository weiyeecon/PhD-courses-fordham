function table_example

%create a table
A = table([5;6;5],['M';'M';'M'],[45;41;40],[45;32;34],{'NY';'CA';'MA'},'VariableNames',{'Age' 'Gender' 'Height' 'Weight' 'Birthplace'},'RowNames',{'Thomas' 'Gordon' 'Percy'})

%save in excel
writetable(A, '/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/tables.xlsx','Sheet',1,'WriteVariableNames',true,'WriteRowNames', true);

%create a second table
B = table(['F';'M';'F'],[6;6;5],{'AZ';'NH';'CO'},[31;42;33],[39;43;40],'VariableNames',{'Gender' 'Age' 'Birthplace' 'Weight' 'Height'})
%save in excel
writetable(B, '/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/tables.xlsx','Sheet',2,'WriteVariableNames',true,'WriteRowNames', true);

%append both tables and save
C = vertcat(A,B)
writetable(C, '/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/tables.xlsx','Sheet',3,'WriteVariableNames',true,'WriteRowNames', true);

%read table
T=readtable('/Users/weiye/Dropbox/My Mac (Wei’s MacBook Air)/Downloads/PhD-Coursework/22summer/ECON 5060/Class/tables.xlsx','Sheet',1);

%see first 2 rows and all columns of T
T(1:2,:)

%find specific values:
T(3,1)

%using index as structures
name1=T.Row(3) %cell
%see difference with 
name2=T.Row{3} %char

summary(T)

%to replace values:
T1=T %just to keep original
T1.Age(1)=99
d
%extract whole columns or rows
Ag=T.Age %becomes a vector of doubles
size(Ag)

%retrieves subsets with logical conditions
T2=T(T.Age==5,:)

%remove columns or rows
T2(1,:)=[]

%organize/sort table according to some column
T3=sortrows(T,'Age')
T4=sortrows(T,'Age','descend')


end

