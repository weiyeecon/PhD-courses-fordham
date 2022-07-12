function quant_price_sugar(kilos,price)

discount=0.2;
cost=kilos*price;
if kilos>5
    final_cost=(1-discount)*cost;
else
    final_cost=cost;

end
