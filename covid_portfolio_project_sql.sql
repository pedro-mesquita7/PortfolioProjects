-- Select Data that I am going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..covid_deaths
ORDER BY 1, 2

-- Looking at Total Cases Vs. Total Deaths
-- Shows likelihood of dying if you contract covid in my country (Portugal)
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..covid_deaths
WHERE location like '%portugal%'
AND continent IS NOT NULL
ORDER BY 1, 2

-- Looking at Total Cases Vs. Population
-- Shows what percentage of population got Covid
SELECT location, date, population, total_cases, (total_cases/population)*100 AS population_infected_percentage
FROM PortfolioProject..covid_deaths
WHERE location like '%portugal%'
AND continent IS NOT NULL
ORDER BY 1, 2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population, max(total_cases) AS infection_count, MAX((total_cases/population))*100 AS population_infected_percentage
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY population_infected_percentage DESC


-- Looking at Countries with Highest Death Count
SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Looking at Continents with Highest Death Count
SELECT continent, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- Global Numbers
-- Total cases, Total deaths, Death Percentage By Day
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- stats across the world
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- JOINING DEATHS AND VACCINATIONS TABLES
-- Looking at Total Population Vs. Vaccinations [USING CTE]
WITH pop_vs_vac (Continent, Location, Date, Population, new_vaccinations, rolling_people_vaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location , dea.date) AS rolling_people_vaccinated
FROM PortfolioProject..covid_deaths AS dea
JOIN PortfolioProject..covid_vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (rolling_people_vaccinated/Population)*100 AS rolling_percentage_people_vaccinated
FROM pop_vs_vac

-- JOINING DEATHS AND VACCINATIONS TABLES
-- Looking at Total Population Vs. Vaccinations [USING TEMP TABLE]
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location , dea.date) AS rolling_people_vaccinated
FROM PortfolioProject..covid_deaths AS dea
JOIN PortfolioProject..covid_vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (rolling_people_vaccinated/Population)*100 AS rolling_percentage_people_vaccinated
FROM #PercentPopulationVaccinated

-- Creating view to store data for data visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location , dea.date) AS rolling_people_vaccinated
FROM PortfolioProject..covid_deaths AS dea
JOIN PortfolioProject..covid_vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL