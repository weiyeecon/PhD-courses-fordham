function ex_fminbnd

fn='2*exp(-x)*sin(x)';      %function for min
fplot(fn,[2,5])
xmin=fminbnd(fn,2,5)           %search over range 2<x<5
ymin=find_ymin(xmin)

%to see a maximun in the function
figure;
fplot(fn,[0,3])

%fminbnd estimates minimuns. However, we can estimate the max of the
%negative of the function:
%function for the max. Note the minus sign
fn='-2*exp(-x)*sin(x)';      %function for min
figure;
fplot(fn,[0,3])
xmax=fminbnd(fn,0,3,optimset('Display','iter'))           %search over range 0<x<3
ymax=find_ymax(xmax)

function y=find_ymin(x)
y=2*exp(-x)*sin(x);

function y=find_ymax(x)
y=2*exp(-x)*sin(x);