

SELECT *
FROM PortfolioProject.dbo.death1
where continent is not null 
order by 3,4 

--looking at countries with the highest infection rate compared to population 

SELECT location , population ,MAX(total_cases) as Highestinfectioncount ,MAX((total_cases/population))*100 as percentpopulationinfected
FROM PortfolioProject.dbo.death1
group by location , population
order by percentpopulationinfected desc 

--showing countries with the highest death count per population
SELECT location , Max(cast( total_deaths as int )) as totaldeathcount
FROM PortfolioProject.dbo.death1
where continent is not null 
group by location 
order by totaldeathcount desc 

-- LETS BREAK THINGS DOWN BY CONTINENT 
SELECT continent , Max(cast( total_deaths as int )) as totaldeathcount
FROM PortfolioProject.dbo.death1
where continent is not null 
group by continent
order by totaldeathcount desc 


--Global Numbers
SELECT location ,date , total_cases ,total_deaths ,  (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
FROM PortfolioProject.dbo.death1
--where location = 'Nigeria '
where continent is not null
order by 1,2

--Next
SELECT  sum(new_cases) as total_cases , sum(cast (new_deaths as int )) as total_deaths , sum(cast (new_deaths as int ))/sum(new_cases)*100 as Deathpercentage
FROM PortfolioProject.dbo.death1
--where location = 'Nigeria '
where continent is not null
order by 1,2

-- looking at total population vs vaccination

select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert  ( bigint,vac.new_vaccinations )) over (partition by dea.location order by dea.location ,dea.date) as rollingpeoplevaccinations 
from PortfolioProject.dbo.death1 dea
join 
 PortfolioProject.dbo.vaccination vac
on dea.location = vac.location
and dea.date = vac.date 
--where dea.continent is not null 
order by 2,3

--Temp table
drop table if exists  #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent  nvarchar(255),
location nvarchar(255),
date datetime,
population numeric ,
new_vaccinations numeric ,
rollingpeoplevaccinated numeric 
)

insert into  #percentpopulationvaccinated

select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert  ( bigint,vac.new_vaccinations )) over (partition by dea.location order by dea.location ,dea.date) as rollingpeoplevaccinated 
from PortfolioProject.dbo.death1 dea
join 
 PortfolioProject.dbo.vaccination vac
on dea.location = vac.location
and dea.date = vac.date 
--where dea.continent is not null 
order by 2,3

select *,(rollingpeoplevaccinated/population)*100
from  #percentpopulationvaccinated


-- creating view to store data 
create view percentpopulationvaccinated as

select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert  ( bigint,vac.new_vaccinations )) over (partition by dea.location order by dea.location ,dea.date) as rollingpeoplevaccinated 
from PortfolioProject.dbo.death1 dea
join 
 PortfolioProject.dbo.vaccination vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null 
--order by 2,3

select *
from percentpopulationvaccinated
