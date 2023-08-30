----* DATA EXPLORATION *----

---* CovidDeaths DATASET *---


use portfolio ;
---Data Exploration 
select * from portfolio.dbo.CovidDeaths order by location
  
select continent , location , total_cases ,total_deaths ,  population   from portfolio.dbo.CovidDeaths order by location


--- TOTAL cases in  EACH CONTINENT
-- SHOW WHAT PERCENTAGE OF  POPULATION GOT COVID

select continent, max(total_cases ) as total_cases
from CovidDeaths
where continent is not null 
group by continent
order by total_Cases


--TOTAL DEATHS IN EACH CONTINENT


select continent, max(convert(int,total_deaths) ) as total_deaths
from CovidDeaths
where continent is not null 
group by continent
order by total_deaths




-- TOTAL CASES VS POPULATION

select continent, max(total_cases ) as total_cases ,max(population) as population,(max(total_cases ) / max(population))*100   totalcase_vs_population
from CovidDeaths
where continent is not null 
group by continent
order by totalcase_vs_population




-- TOTAL DEATHS VS POPULATOIN

select continent, max(cast(total_deaths as int)) as total_cases ,max(population) as population,(max(cast(total_deaths as int)) / max(population))*100   totaldeaths_vs_population
from CovidDeaths
where continent is not null 
group by continent
order by totaldeaths_vs_population





--- TOTAL CASES VS TOTAL DEATHS IN EACH CONTINENT


select continent, max(total_cases ) as total_cases,max(cast(total_deaths as int)) as total_deaths,(max(cast(total_deaths as int)))/(max(total_cases )) *100   'deaths vs cases for continent from  CovidDeaths'
from CovidDeaths
where continent is not null 
group by continent
order by 'deaths vs cases for continent from  CovidDeaths'



--------------------------------------------------------------------------------------------------------------------------

---* CovidVaccinations DATASET *---

select * from CovidVaccinations



-- TOTALTESTS VS POPULATION IN EACH CONTINENT


use portfolio
select continent,max(cast(total_tests as int)) as total_test ,max(population) as population ,max(cast(total_tests as int))/max(population) total_tests_population
from CovidVaccinations
where continent is not null 
group by continent 
order by total_tests_population 






-- TOTAL_VACCINATIONS VS POPULATION IN EACH CONTINENT



select continent,max(cast(total_vaccinations as bigint)),max(population) ,max(cast(total_vaccinations as bigint))/max(population) total_vaccinations_population
from CovidVaccinations
where continent is not null 
group by continent 
order by total_vaccinations_population 




--------------------------------------------------------------------------------------------------------------------------




--- USE CovidVaccinations DATASET WITH  CovidDeaths  ---

select *
from CovidDeaths dea
join CovidVaccinations vac on   dea.iso_code=vac.iso_code and dea.date=vac.date











