

%%%% Note: actually this input-output function file has already been provided in the email from
%%%% you.

function input_output_open_economy(d)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Assume there are three industries and the input-coefficient 
%matrix is:
%A=[0.2 0.3 0.2; 0.4 0.1 0.2;0.1 0.3 0.2]
%note that each column of A sum less than 1, as it should be.
%then a0j the dollar amount of the primary input used in producing a
%dollar's worth of the j-th commodity (substracting the sum of each 
%column from 1):
%a01=0.3, a02=0.3, a03=0.4
%
%inputs:
%d=column vector (3x1) (final demands)
%d=[10 5 6]';
%outputs:
%x=column vector (3x1) (production output) 
%x=T^(-1)*d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%check if the d is a column vector, if not correct
if size(d,1)~=3
    d=d';
end

if prod(size(d))~=3
    error('matrix d should be a 3x1 vector!');
end

A=[0.2 0.3 0.2; 0.4 0.1 0.2;0.1 0.3 0.2]
prim_input=1-sum(A,1);%dollar amount of primary input used in producing a dollar's worth of jth
%commodity
T=(eye(3)-A)   %T=technology matrix
x=inv(T)*d %in billions of USD

prim_input*x %primary input requirement in billions of USD
