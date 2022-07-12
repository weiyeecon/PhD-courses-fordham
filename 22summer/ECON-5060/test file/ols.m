function ols(x,y)
x=table2array(x);
y=table2array(y);
if nargin<2
    error("Don't have enough data to make regression")
end
[m,n]=size(x)
[m1,n1]=size(y)
if m<2
    error('Either transpose x or too few data')
end
if n>m1
    error("It can't be regression, because num of indep variables larger than dep vars")
end

if det(x'*x)==0
    error("we can't estimate coefficient based on this data")
end

%Estimate coefficents.
if m==m1
    b=inv(x'*x)*x'*y;
end
%Actually fitlm() in matlab like lm() in R can get the coefficients and
%other stat variables easily. No one actually gets the regression results
%via their own ols code. 
alpha=b(1);
beta=b(2:length(b));
t_stat=beta/std(beta);

f_stat=t_stat^2;
%I use the trick F-stat=t^2(widely used) in econometrics especially when we
%test 2SLS. Lewbel test. For the mathematical proof why they are equal see
%this:https://stats.stackexchange.com/questions/55236/prove-f-test-is-equal-to-t-test-squared

mdl = fitlm(x,y);% matlab in-built code for ols, we use this for R-square.
r_square=mdl.Rsquared.Ordinary;

end

%%%
%reference: http://www.karenkopecky.net/Teaching/eco613614/Matlab%20Resources/OLS.pdf