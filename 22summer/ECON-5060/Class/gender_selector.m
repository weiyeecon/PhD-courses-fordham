function gender_data=gender_selector(dat,gender)
gender_data= dat(find(dat(:,3)==gender),:);
end
