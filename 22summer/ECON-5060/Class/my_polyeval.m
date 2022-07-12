function my_polyeval(P,V)

%P is polynomial in matlab form
%V contains three elements: from, to, $obs;

x=linspace(V(1),V(2),V(2));
v=polyval(P,x)
subplot(1,2,1);
plot(x,v);
xlabel('x');
ylabel('v');
title('your evaluated polynomial');

d=polyder(P);
v1=polyval(d,x);
subplot(1,2,2);
plot(x,d);
title('derivative graph');
xlabel('x');
ylabel('d');


end