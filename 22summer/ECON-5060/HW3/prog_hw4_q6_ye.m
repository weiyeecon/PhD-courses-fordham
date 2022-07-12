function [A_trans,A_tran_matlab]=ex_transpose(A)
[m,n]=size(A)
A_trans=[];
for i = 1:m
    for j = 1:n
        A_trans(j,i)=A(i,j);
    end
end

A_trans
A_tran_matlab=A';
isequal(A_trans,A_tran_matlab)
end

