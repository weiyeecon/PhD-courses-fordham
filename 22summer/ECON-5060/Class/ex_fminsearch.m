function ex_fminsearch

%Now find a minimum for this function using x = -0.6, y = -1.2, and z = 0.135 as the starting values. 
v = [-0.6 -1.2 0.135];
a = fminsearch(@three_var,v)

min_function_value=eval_fun(a) %shows the valueof the function evaluate at the optimal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create a function three_var of three variables, x, y, and z.
%note that you can create a function in another function. 
%care: the main function goes first, in our case ex_fminsearch
%you need this function to be optimized

function b = three_var(v)
x = v(1);
y = v(2);
z = v(3);
b = x.^2 + 2.5*sin(y) - z^2*x^2*y^2;

function c=eval_fun(a)
x = a(1);
y = a(2);
z = a(3);
c = x.^2 + 2.5*sin(y) - z^2*x^2*y^2;