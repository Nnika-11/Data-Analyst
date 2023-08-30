--select Data to use

select top 5000 * from covidDeaths where continent <> '' order by total_deaths_per_million desc;
select top 5000 * from covidDeaths ;

-- Total cases vs Total Deaths 

-- likeligood of death rate
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS deathpercentage 
from covidDeaths 
where location like '%states' order by 2;

--Total cases vs Population
-- Persentage of infected people
Select location, date, population, total_cases,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS infected_percentage 
from covidDeaths
where location = 'Canada' order by 2 ;

--countries with highest infection rate compared to Population
Select location, population, MAX(total_cases) as highest_infection_num,
MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS infected_percentage
from covidDeaths
where continent <> ''
group by location,population
order by infected_percentage desc;



--countries with highest death count 


select location, MAX(total_deaths) as highest_death_num ,population from covidDeaths
where continent <> '' --exclude non continent values (aggregated) 
group by location, population 
order by highest_death_num desc

-------------------------------------------------------------------------------------
--continent with highest death count

select location, MAX(total_deaths) as highest_death_num  from covidDeaths
where iso_code in ('OWID_EUR', 'OWID_ASI', 'OWID_NAM', 'OWID_SAM', 'OWID_AFR', 'OWID_OCE') --only continents
group by location
order by highest_death_num desc

--continents of the highest death count per population
select location, population, MAX(cast(total_deaths as float)/population)*100 as highest_death_persentage  from covidDeaths
where iso_code in ('OWID_EUR', 'OWID_ASI', 'OWID_NAM', 'OWID_SAM', 'OWID_AFR', 'OWID_OCE')
group by location, population
order by highest_death_persentage desc


---ALTER TABLE covidDeaths
--ALTER COLUMN new_cases float;


--global numbers
Select date, SUM(new_cases) as total_cases,
SUM(new_deaths) as total_deaths,
SUM(new_deaths)/ NULLIF(SUM(new_cases),0)* 100 as death_rate 
from covidDeaths
where continent <> ''
group by date
order by death_rate desc


select * from covidVaccinations vac
join covidDeaths dea
on dea.location = vac.location
and dea.date = vac.date

--make a CTE
with PopvsVac (continent, location, date, population, new_vaccinations, rolling_ppl_vaccinated)
as 
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) over (Partition by dea.location order by dea.location,dea.date) as rolling_ppl_vaccinated
from covidVaccinations vac
join covidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ''
)
select *, (rolling_ppl_vaccinated/population)*100 from PopvsVac
--looking at total vaccination vs population


--temp Table
Drop table if exists #percentPopulationVaccinated
Create Table #percentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_ppl_vaccinated numeric
)

insert into #percentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) over (Partition by dea.location order by dea.location,dea.date) as rolling_ppl_vaccinated
from covidVaccinations vac
join covidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ''


select *, (rolling_ppl_vaccinated/population)*100 from #percentPopulationVaccinated

--create view to store data for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rolling_ppl_vaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
