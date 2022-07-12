function my_fit(X,y,n,V,x_test)


%x=0:0.1:1;
%y=[-0.447 1.978 3.28 6.16 7.08 7.34 7.66 9.56 9.48 9.30 11.2];
%x_test=0.5
A=polyfit(X,y,n);
x1=linspace(V(1),V(2),V(3));
z=polyval(A,x1);
plot(X,y,'o',X,y,x1,z,'b');
z1=polyval(A,x_test)

end