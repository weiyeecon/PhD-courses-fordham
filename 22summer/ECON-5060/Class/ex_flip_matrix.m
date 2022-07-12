function ex_flip_matrix 
A=[[1:2:10]',[2:2:10]'];% This is the data to test the program
A_UD=A(size(A,1):-1:1,:);

A_LR=A(:,size(A,2):-1:1);
end