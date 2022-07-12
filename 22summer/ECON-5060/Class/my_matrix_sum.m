%sum 2 matrix
function C= my_matrix_sum(A,B)
[m,n]=size(A);
[m1,n1]=size(B);
if m~=m1 | n~=n1
    error('Matrcies are not conformable')
end
C=A+B;
