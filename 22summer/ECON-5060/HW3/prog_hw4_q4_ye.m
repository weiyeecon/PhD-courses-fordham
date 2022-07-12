function [sum_rows,sum_cols,matrix_mult_ele,matrix_power,matrix_inv]=[hw4(A,power)

if nargin==0
    A=[2 3 17;4 5 6;7 8 9];
end
[m,n]=size(A);
if m~=n
    error("It's not a square matrix");
end
if det(A)==0
    error("It's a singular matrix!");
end

sum_rows=[];
sum_cols=[];
%compute row sum;
for i in 1:m
    sum_rows(i)=[sum_rows;sum(A(i,:))];
    
end

%compute column sum
for j in 1:n
    sum_cols(j)=[sum_cols;sum(A(:,j))];
end

B=[2 3 4;5 6 7; 7 8 13];
[c,d]=size(B);
 
if c==m & d==n
    matrix_mult_ele=A.*B;
end

matrix_power=A.^(power);
matrix_inv=hw_1_2_3(A);

sum_rows=sum_rows';


end
