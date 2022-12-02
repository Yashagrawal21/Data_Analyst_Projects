/*

Diondra Stubbs

COVID-19 Data Exploration Project

QUERIES USED FOR TABLEAU DASHBOARD

*/

-- 1. GLOBAL CASES, DEATHS & DEATH PERCENTAGE
SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(CAST(new_deaths AS INT)) AS total_deaths, 
	SUM(CAST(new_deaths AS INT))/SUM(new_Cases)*100 AS global_death_pecentage
From 
	covid_deaths
WHERE continent is not null 
ORDER BY total_cases, total_deaths
 

-- 2. DEATHS PER CONTINENT
SELECT 
	continent, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	covid_deaths
WHERE 
	continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC


-- 3. PERCENT POPULATION INFECTED
SELECT
	location, 
	population, 
	MAX(total_cases) AS highest_infection_count,  
	Max((total_cases/population))*100 AS percent_population_infected
FROM 
	covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC

-- 4. PERCENT POPULATION INFECTED OVERTIME
SELECT
	location, 
	population, 
	date,
	MAX(total_cases) AS highest_infection_count,  
	Max((total_cases/population))*100 AS percent_population_infected
FROM 
	covid_deaths
GROUP BY location, population, date
ORDER BY percent_population_infected DESC

-- 5. GLOBAL VACCINATION NUMBERS
SELECT
	SUM(New_vaccinations) AS total_vaccinations,
	(SUM(CAST(New_vaccinations AS BIGINT))/SUM(Population))*100 AS global_vacc_percentage
FROM
	percent_population_vaccinated
WHERE continent IS NOT NULL


-- 6. VACCINATIONS PER CONTINENT
SELECT
	Continent,
	MAX(New_vaccinations) as highest_vaccination_count
FROM
	percent_population_vaccinated
WHERE Continent IS NOT NULL 
GROUP BY Continent
ORDER BY highest_vaccination_count DESC 


--7. GLOBAL DEATH % PER DAY
SELECT 
	date, 
	SUM(new_cases) AS total_cases, 
	SUM(CAST(new_deaths AS INT)) AS total_deaths, 
	SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS global_death_pecentage
FROM 
	covid_deaths
WHERE continent IS NOT NULL
GROUP BY date 
ORDER BY date, total_cases