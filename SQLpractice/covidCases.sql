--select Data to use

Select top 100 location, date, total_cases, new_cases, total_deaths, population from covidDeaths order by 1,2;


-- Total cases vs Total Deaths 

-- likeligood of death rate
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage from covidDeaths  where location like '%states' order by 2;

--Total cases vs Population
-- Persentage of infected people
Select location, date, population, total_cases,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS InfectedPercentage from covidDeaths  where location like 'Canada' order by 2 ;

--countries with highest infection rate compared to Population

Select location, AVG(population), total_cases,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS InfectedPercentage from covidDeaths group by location order by 2 ;