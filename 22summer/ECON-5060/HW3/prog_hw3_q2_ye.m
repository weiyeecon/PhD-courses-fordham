function y_pred=my_linear_eq(a,b,y_obs)
    minX=-3;
    maxX=8;
    x=linspace(minX,maxX,size(y_obs,2));
    y_pred=a+b*x;
end
