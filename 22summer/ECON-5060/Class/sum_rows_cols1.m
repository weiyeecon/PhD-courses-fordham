function [sum_rows,sum_rows_matlab,sum_cols,sum_matlab]=sum_rows_cols1(A)

if nargin==0
    A=[1 2 3;4 5 6;7 8 9];
end
[n,m]=size(A);

%initializing an empty matrix that will contain the results
sum_row=[];
sum_cols=[];


%sum rows
for i=1:n
    sum_row(i)=[sum_row;sum(A(i,:))];
    sum_row_matlab=sum(A,2);
    
end

%sum columns
for j=1:m
    sum_cols(j)=[sum_cols;sum(A(:,j))];
    sum_cols_matlab=sum(A);
end

sum_rows=sum_rows';
    


end