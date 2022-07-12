function [my_norm,norm_matlab]=my_frobenius(x)

%compute the Frobenius norm,sqrt(sum(diag(X'*X)))

x_aus=x'*x;
d_x_aux=diag(x_aux);
sum_d_x_aux=sum(d_x_aux);
sqrt_sum_d_x_aux=sqrt(sum_d_x_aux)

my_morm=sqrt_sum_d_x_aux;

norm_matlab=norm(x,'fro');
end