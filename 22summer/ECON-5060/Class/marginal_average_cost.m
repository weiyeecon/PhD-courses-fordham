function marginal_average_cost

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the total cost function C(q), the average cost AC=C(q)/q, with q>0
%the rate of change of AC with respect to q is:
%d/dq(C(q)/q)=(1/q)(C'(q)-c(q)/q)=(1/q)(MC-AC)
%this means that the slope of the AC curve will be positive, zero or
%negative if and only if the MC curve lies above, intersects or lies below
%AC curve.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q=sym('q');
C=sym(q^3-12*q^2+60*q)        %you can also use C=sym(q^3-12*q^2+60*q) since q is already defined as sym
MC=diff(C)
AC=C/q
ezplot(MC,[0,10]);
hold on;
ezplot(AC,[0,10]);
ylabel('MC and AC');
axis([0,10,0,100]);
text(7,20,'AC');
text(8,60,'MC');
hold off;

% %we find the difference using symbols (just to use fplot)
d1=MC-AC;
figure;
ezplot(d1,[0,10]);
xlabel('q'); ylabel('MC-AC');

%now we try to find the point at which they intersect

MC_num=sym2poly(MC) %put the symbolic in term of [3 -24 60]. Remember MC=3*q^2-24*q+60
AC_num=sym2poly(AC)

%in the intersection both should be the same or MC-AC=0
%we have a polynomial difference and then we find the roots of this
%resulting polynomial

d=MC_num-AC_num

int=roots(d)    %it contains zero, that is the first point where they intersect.
int=int(find(int~=0))   %selects the value not zero

%must be the same value since we have an intersection

MC_final=polyval(MC_num,int)
AC_final=polyval(AC_num,int)