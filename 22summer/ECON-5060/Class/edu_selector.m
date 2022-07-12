function [edu_data]=edu_selector(dat,ind)

if ind==0% only high school
    edu_data=dat(find(dat(:,4)<=12),:);
else % college or grad
    edu_data=dat(find(dat(:,4)>12),:);
end
