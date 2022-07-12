function quant_price_sugar2(kilos,price)

discoun1=0.2;
discount2=0.25
cost=kilos*price;
if kilos>5 &cost<=20
    final_cost=(1-discount1)*cost;
elseif kilo>5&cost>20
    final_cost=(1-discount2)*cost;
else
    final_cost=cost;
end
