function [x,fro_matlab,fro_own]=my_syst_eq2020(a,b)
[n,m]=size(a);
if n~=m
    error('Matrix is not square');
end
if det(a)==0
    error('Matrix is singular');
end

x=a^-1*b;

%frobenious norm
%matlab formula
fro_matlab=norm(a,'fro');

%own frobenious
fro_own=sqrt(sum(diag(a'*a)));

end

