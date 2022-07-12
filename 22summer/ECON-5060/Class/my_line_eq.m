function my_line_eq(y_int,slope,x_var)
y=y_int+slope*x_var;
y_perp=y_int+(-1/slope)*x_var;
plot(x_var,y)
hold on
plot(x_var,y_perp)
grid;
title('my line');
xlabel('x');
ylabel('y');
end