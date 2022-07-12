function my_matrix_sum_call
a=[1 2;3 4];
b=[5 2;1 0];
c=[7 1;9 8];
ab=my_matrix_sum(a,b)
abc=my_matrix_sum(ab,c)
abminusc=my_matrix_sum(ab,-c)
end
