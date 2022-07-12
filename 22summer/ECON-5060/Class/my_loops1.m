%function
%[only_males,plus_8,id_years_sal_gender]=my_loops1(id_years_sal_gender)
function my_loops1
id_years_sal_gender=[[1:6]',[9 6 2 12 8 7]',[100 70 25 125 102 85]',[2 1 2 1 1 2]'];

%using for loops to create a matrix of only males
only_males=[];
for i=1:size(id_years_sal_gender,1)
    if id_years_sal_gender(i,4)==1
        only_males=[only_males;id_years_sal_gender(i,:)];
    end
end


%using while loops to create a matrix with years of experience of more or
%equal than 8 years.
plus_8=[];
k=1;
while k<=size(id_years_sal_gender,1)
    if id_years_sal_gender(k,2)>=8
        plus_8=[plus_8;id_years_sal_gender(k,:)];
    end
    k=k+1;
end


% using original matrix  add a new column to contain "salary level". 1
% (high) >=100; 2 (medium) >=50 and <100; 3 (low) <50

for i=1:size(id_years_sal_gender,1)
   if id_years_sal_gender(i,3)>=100
       id_years_sal_gender(i,5)=1;
   elseif id_years_sal_gender(i,3)>=50 & id_years_sal_gender(i,3)<100
       id_years_sal_gender(i,5)=2;
   else
       id_years_sal_gender(i,5)=3;
   end
end

gender_dumm=zeros(size(id_years_sal_gender,1),1);

for i=1:size(id_years_sal_gender,1)
   if id_years_sal_gender(i,4)==1
       gender_dumm(i,1)=1;
   end
end
id_years_sal_gender(:,6)=gender_dumm;
d



end