select *
from portfolio.`covid-vaccinations`
order by 3,4;

select *
from portfolio.`covid-vaccinations`
order by 4 desc;

# Select Data that we are going to use

SELECT location, date,total_cases, new_cases, total_deaths, population
From portfolio.`covid-deaths`
Order By 1;

# Looking at Total cases vs Total deaths

SELECT location, date,total_cases, new_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From portfolio.`covid-deaths`
Order By 1;


# Looking at Total Cases vs Populations

SELECT location, date, population, total_cases, (total_cases/population) * 100 as PopulationInfected
From portfolio.`covid-deaths`
WHERE location LIKE '%state%'
Order By 1;

# Looking at Countries With Highest Infection Rate Compared to Populations

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
From portfolio.`covid-deaths`
# WHERE location LIKE '%state%'
GROUP BY location, population
Order By PercentPopulationInfected desc;


# Showing Countries With Highest Death Count Per Population

SELECT location, MAX(total_deaths) as TotalDeath
From portfolio.`covid-deaths`
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeath desc;


# Let's Break Things Down By Continent

# Showing Continent With the Highest Death Count

SELECT continent, MAX(total_deaths) as TotalDeath
From portfolio.`covid-deaths`
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeath desc;


# Global Numbers

SELECT SUM(new_cases) as total_case, SUM(new_deaths) as total_death, (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
From portfolio.`covid-deaths`
WHERE continent IS NOT NULL;
# GROUP BY date


# Looking  at Total Population vs vaccination

WITH popvsvac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as (
Select dea.continent,
           dea.location,
           dea.date,
           dea.population,
           vac.new_vaccinations,
           SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location) as RollingPeopleVaccinated
    FROM portfolio.`covid-deaths` dea
             JOIN portfolio.`covid-vaccinations` vac
                  ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated/population) * 100
FROM popvsvac;


# Creating View

CREATE VIEW portfolio.PercentPopulationVaccinated as
    Select dea.continent,
           dea.location,
           dea.date,
           dea.population,
           vac.new_vaccinations,
           SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location) as RollingPeopleVaccinated
    FROM portfolio.`covid-deaths` dea
             JOIN portfolio.`covid-vaccinations` vac
                  ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL;

SELECT *
FROM portfolio.percentpopulationvaccinated



