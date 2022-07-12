function x=my_syst_eq(a,b)

%test
n=size(a,1);
m=size(a,2);

if nargin~=2%nargin: the number of function input arguments
    error('you need to input a and b');
end
if n~=m
    error('matrix A is not square');
end

if size(b,2)~=1
    b=b';
end

%Singularity condition
d=det(a);
if d==0
    error('matrix a is singular');
end

x=inv(a)*b;
    
    
end
