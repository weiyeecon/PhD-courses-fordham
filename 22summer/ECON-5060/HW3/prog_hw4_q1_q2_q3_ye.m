function [A_inv,A_inv_decom,A_half]=hw_1_2_3(A)

adjoint_A=det(A)*inv(A);
A_inv=adjoint_A/det(A);
%since AP=PD; thus A=PDP^{-1}, A is original matrix, 
[m,n]=eig(A);
A_inv_decom=m*n*inv(m);
A_half=m*n^(0.5)*inv(m);
end
