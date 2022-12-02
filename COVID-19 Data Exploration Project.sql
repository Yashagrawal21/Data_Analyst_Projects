/*
Diondra Stubbs

COVID-19 Data Exploration

Skills Used: JOINS, CTE, TEMP TABLES, WINDOWS FUNCTIONS, AGGREGATE FUNCTIONS, CONVERTING DATA TYPES

Data: The dataset is from https://ourworldindata.org/covid-deaths. It has data from January 2020 to November 2022. 
I manipulated the data in Excel to contain the columns I wanted to work with.

Task: The goal of this project is to explore 2020-2022 COVID-19 Data by asking and answering data exploration questions. 
I choose to look at insights for the United States since I am a US citizen. I also explored data globally and regionally.

*/

USE PortfolioProject;

/* VIEWING THE DATASETS */

-- Covid Deaths Data
SELECT 
	* 
FROM 
	covid_deaths
WHERE continent IS NOT NULL
ORDER BY date,population

-- Covid Vaccinations Data
SELECT 
	* 
FROM 
	covid_vaccinations
WHERE 
	continent IS NOT NULL
ORDER BY date,population


/* 
								DATA EXPLORATION - COVID DEATHS DATA
*/

/* How many COVID-19 cases in the US? How many deaths? What is the percentage death rate? */
-- This shows the likelihood of dying in the United States if you contract COVID-19 in November 2022.
SELECT 
	location, 
	date,
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 AS deaths_per_case
FROM 
	covid_deaths
WHERE 
	location LIKE '%states%'
ORDER BY date

-- As of November 23 2022, there are 98,503,462 total cases and the death percentage is about 1.095%. 
-- This means that 98,503,462 people have been infected by COVID-19 since Jan 2020 and that there is about a 1.1% chance of dying if you contract COVID-19 while living in the US.

-- How does this compare to a year ago, two years ago?
SELECT 
	location, 
	date,
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 AS deaths_per_case
FROM 
	covid_deaths
WHERE 
	location LIKE '%states%' AND date = '2021-11-23 00:00:00.000'
ORDER BY date

SELECT 
	location, 
	date,
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 AS deaths_per_case
FROM 
	covid_deaths
WHERE 
	location LIKE '%states%' AND date = '2020-11-23 00:00:00.000'
ORDER BY date

-- One year ago, 48,024,223 people were infected with COVID-19 and there was a ~1.6% chance of dying upon contraction.
-- Two years ago, 12,515,951 people were infected with COVID-19 and there was a ~2% chance of dying upon contraction.



/* What percentage of the US population contracted COVID-19? */
-- This shows what percentage of the US population was infected with COVID-19
SELECT 
	location, 
	date,
	total_cases, 
	total_deaths, 
	(total_deaths/population)*100 AS percent_population_infected
FROM 
	covid_deaths
WHERE 
	location LIKE '%states%'
ORDER BY date

-- 0.32% of the US population contracted COVID-19 as of Nov 23, 2022



/* Which countries have the highest infections rate? */
-- Showing countries with highest infection rate compared to their population
SELECT
	location,
	continent,
	population, 
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	covid_deaths
GROUP BY location, continent, population
ORDER BY percent_population_infected DESC

-- Where does the US fall?
SELECT 
	location,
	population, 
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	covid_deaths
WHERE 
	location = 'United States'
GROUP BY location, population

-- The highest infection rate is among European countries. The country with the highest infection rate is Cyprus.
-- The US has an infection rate of ~29%, we're 60th.

-- Has this changed over time?
SELECT 
	location,
	population, 
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	covid_deaths
WHERE 
	location = 'United States' AND date = '2020-11-23 00:00:00.000'
GROUP BY location, population

SELECT 
	location,
	population, 
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	covid_deaths
WHERE 
	location = 'United States' AND date = '2021-11-23 00:00:00.000'
GROUP BY location, population

SELECT 
	location,
	population, 
	MAX(total_cases) AS highest_infection_count, 
	MAX((total_cases/population))*100 AS percent_population_infected
FROM 
	covid_deaths
WHERE 
	location = 'United States' AND date = '2022-11-23 00:00:00.000'
GROUP BY location, population

-- Yes. In 2020, the US infection rate was ~3.7% and in 2021 it was ~14.2%. 
-- The infection rate now it almost 8 times as much as it was in 2020 and twice as much as it was in 2021.


/* Which country had the highest death count in 2022, 2021 and 2020? */
-- Showing the countries with the highest death count per population

-- 2022
SELECT
	location, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	covid_deaths
WHERE 
	continent IS NOT NULL -- was reading in continets as countries so had to include this
GROUP BY location
ORDER BY total_death_count DESC

-- 2021
SELECT
	location, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	covid_deaths
WHERE 
	continent IS NOT NULL AND (DATEPART(yy, date) = 2021)
GROUP BY location
ORDER BY total_death_count DESC

-- 2020
SELECT 
	location, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	covid_deaths
WHERE 
	continent IS NOT NULL AND (DATEPART(yy, date) = 2020)
GROUP BY location
ORDER BY total_death_count DESC

-- The United States, Brazil and India have the highest death counts each year. 
-- The death count in Mexico has improved since 2020, going from 4th place to 5th. Th UK went from 4th to 7th. Russia went from 9th to 4th.

/* How many people in the US were hospitalized due to COVID-19? How many in the ICU? */

SELECT
	location,
	date,
	total_cases,
	hosp_patients,
	(hosp_patients/total_cases)*100 AS hosp_per_case
FROM
	covid_deaths
WHERE 
	location LIKE '%states%'
ORDER BY date

-- we starts to see hospitalizations due to COVID-19 mid-July 2020 (July 15th, 2020)

SELECT
	location,
	date,
	total_cases,
	icu_patients,
	(icu_patients/total_cases)*100 AS icu_per_case
FROM
	covid_deaths
WHERE 
	location LIKE '%states%'
ORDER BY date

-- we starts to see ICU admissions around the same time (July 15th, 2020)



-------------------------------- LET'S BREAK THINGS DOWN BY CONTINENT ------------------------------------

/* Which continent has the highest death count? */
--  This shows contintents with the highest death count per population
SELECT 
	continent, 
	MAX(CAST(total_deaths AS INT)) as total_death_count
FROM 
	covid_deaths
WHERE 
	continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- As of right now, North America has the highest death count.

-------------------------------------- GLOBAL NUMBERS ------------------------------


/* What is the global death percentage per day? */
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

/* How many cases are there worldwide?
   How many deaths?
   What is the overall global death percentage?
*/
SELECT 
SUM(new_cases) AS total_cases, 
SUM(CAST(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS global_death_pecentage
FROM 
	covid_deaths

WHERE continent IS NOT NULL
ORDER BY 1,2
-- Presently, there are 637,876,021 cases and 6,588,157 deaths worldwide due to COVID-19. The global death percentage is 1.03282719260582%.




/* 
								       DATA EXPLORATION - COVID VACCINATIONS DATA
*/


/* Viewing vaccination data*/

SELECT 
	* 
FROM 
	covid_vaccinations
WHERE continent IS NOT NULL
ORDER BY date,population

/* What percentage of people are vaccinated? */
-- Shows percentage of population that has received at least one COVID-19 vaccine

SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
FROM 
	covid_deaths dea
		JOIN 
	covid_vaccinations vac ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
ORDER BY 2,3

---- Using Common Table Expression (CTE) to perform calculation on PARTITION BY in previous query

WITH population_vaccinated (continent, location, date, population, new_vaccinations, rolling_ppl_vaccinated)
AS
(
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
FROM 
	covid_deaths dea
		JOIN 
	covid_vaccinations vac ON dea.location = vac.location
		AND dea.date = vac.date
WHERE 
	dea.continent IS NOT NULL
)

SELECT 
	* , 
	(rolling_ppl_vaccinated/population)*100 AS percent_vaccinated
FROM 
	population_vaccinated;
	
-- From this we can see how many people are being vaccinated daily in each country. 
-- new_vaccinations tells us how many people have been vaccinated that day while rolling_ppl_vaccinated provided a rolling count. 
-- percent_vaccinated gives us the daily percentage of peoole vaccinated in each country respective to their population

/* To do futher exploration, lets create a temp table */

DROP TABLE IF EXISTS percent_population_vaccinated
CREATE TABLE percent_population_vaccinated
(
	Continent NVARCHAR(255),
	Location NVARCHAR(255),
	Date DATETIME,
	Population NUMERIC,
	New_vaccinations NUMERIC,
	Rolling_People_Vaccinated NUMERIC
)

INSERT INTO percent_population_vaccinated
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
FROM 
	covid_deaths dea
		JOIN 
	covid_vaccinations vac ON dea.location = vac.location
		AND dea.date = vac.date
WHERE 
	dea.continent IS NOT NULL

SELECT 
	*, 
	(Rolling_People_Vaccinated/Population)*100 AS Percent_Vaccinated
FROM 
	percent_population_vaccinated


/* What percentage of each country's population is vaccinated as of today (11/23/2022)? */
SELECT 
	Location,
	Date,
	Population,
	New_vaccinations,
	Rolling_People_Vaccinated,
	(Rolling_People_Vaccinated/Population)*100 AS Percent_vaccinated
FROM
	percent_population_vaccinated
WHERE 
	Date = '2022-11-23 00:00:00.000'
ORDER BY Date

/* What percentage of the US population is vaccinated as of today (11/23/2022)? */
SELECT 
	Location,
	Date,
	Population,
	New_vaccinations,
	Rolling_People_Vaccinated,
	(Rolling_People_Vaccinated/Population)*100 AS Percent_vaccinated
FROM
	percent_population_vaccinated
WHERE 
	Date = '2022-11-23 00:00:00.000' AND Location = 'United States'
ORDER BY Date

-- About 192%


/* What percentage of the world is vaccinated? */
SELECT
	SUM(New_vaccinations) AS total_vaccinations,
	(SUM(CAST(New_vaccinations AS BIGINT))/SUM(Population))*100 AS global_vacc_percentage
FROM
	percent_population_vaccinated
WHERE continent IS NOT NULL

-- 10703463448 people worldwide are vaccinated with at least one vaccine, that's 0.13% of the global population.


/* Which countries have the highest vaccination rate? */
SELECT 
	*, 
	(Rolling_People_Vaccinated/Population)*100 AS Percent_Vaccinated
FROM 
	percent_population_vaccinated

SELECT
	Location,
	Continent,
	Population,
	MAX(New_vaccinations) as highest_vaccination_count,
	MAX((New_vaccinations/Population))*100 AS percent_vacc
FROM
	percent_population_vaccinated
GROUP BY Location, Continent, Population
ORDER BY percent_vacc DESC 

-- Mongolia has the highest vaccination rate

/* Which continents have the highest vaccination count? */
SELECT
	Continent,
	MAX(New_vaccinations) as highest_vaccination_count
FROM
	percent_population_vaccinated
WHERE Continent IS NOT NULL 
GROUP BY Continent
ORDER BY highest_vaccination_count DESC 

-- Asia has the highest vaccination count
