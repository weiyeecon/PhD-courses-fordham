function final_price=my_quant_price_sugar_2prods(k)

kilos=k(1);
prices=k(2);
kilos1=k(3);
prices1=k(4);
discount=0.05;
cost_bef_dist=kilos*prices+kilos1*prices1;

if kilos+kilos1>10 & cost_bef_dist>200
    final_price=(1-discount-0.02)*cost_bef_dist
elseif kilos>10
        final_price=(1-discount)*cost_bef_dist
else
        final_price=cost_bef_dist
end

end