function age_data=age_selector(dat,ind)


if ind==0 %no_ok_drink
    age_data=dat(find(dat(:,2)<21),:);
else
    age_data=dat(find(dat(:,2)>=21),:);
end