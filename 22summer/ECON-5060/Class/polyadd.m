function p=polyadd(a,b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% polyadd: Polynomial addition
% polyadd(a,b) adds the polynomilas a and b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2
   error('not enough input arguments');
end

a=a(:).';	%make sure inputs are row vectors
b=b(:).';
na=length(a);	%find lenghts of a and b
nb=length(b);
p=[zeros(1,nb-na) a]+[zeros(1,na-nb) b];	%zero pad
                                            %note that zeros(.) with empty
%d                                            %of negative arguments simply
                                            %ignores the command