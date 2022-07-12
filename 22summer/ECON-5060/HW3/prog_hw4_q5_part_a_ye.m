function my_quant_price_sugar(kilos,prices)

discount=0.2;
cost_bef_dist=kilos*prices;

if kilos>5 & cost_bef_dist>1000
    final_price=(1-discount-0.05)*cost_bef_dist
elseif kilos>5
        final_price=(1-discount)*cost_bef_dist
else
        final_price=cost_bef_dist
end

end