function [A_trans,A_trans1,A_trans_matlab]=ex_transpose_1(A)

if nargin==0
    A=[1 2 3;4 5 6;7 8 9];
end
for i=1:size(A,2)
    for j=1:size(A,1)
        A_trans(i,j)=A(j,i);
    end
end

%using some array techniques:
at=A(:,3:-1:1);
A_trans1=rot90(at);

%using matlab command;
A_trans_matlab=A';
        




end
