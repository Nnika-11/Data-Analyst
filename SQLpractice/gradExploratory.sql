select * from labor_market_college_grads; 

--what is the most uneremployment professions
select * from labor_market_college_grads order by Unemployment_Rate desc;

--what is the most uneremployment professions
select * from labor_market_college_grads order by Underemployment_Rate desc;

--what are the smallest wage of educated ppl at the start of the career
select Major, Share_with_Graduate_Degree, Median_Wage_Early_Career 
from labor_market_college_grads 
order by Share_with_Graduate_Degree desc, Median_Wage_Early_Career;

--biggest difference in early career wages compare to mid career
select Major, Median_Wage_Early_Career, Median_Wage_Mid_Career, 
	(Median_Wage_Mid_Career - Median_Wage_Early_Career) as wage_difference
from labor_market_college_grads 
order by wage_difference desc;

--what is the rate of graduates that are not working by profession (median)
--better chanses to get a job as a graduates 
select Major, Share_with_Graduate_Degree, Unemployment_Rate+Underemployment_Rate as not_in_profession_rate, 
	Share_with_Graduate_Degree*(Unemployment_Rate+Underemployment_Rate)/100 as not_in_profession_grads 
from labor_market_college_grads order by not_in_profession_grads
