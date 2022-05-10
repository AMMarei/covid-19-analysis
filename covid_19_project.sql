SELECT *
FROM raw_data

-- Basic data exploration to figure out how to only include countries and exclude any other classification.
SELECT *
FROM raw_data
WHERE continent = ''


-- Query to only include locations that represent countries.
SELECT *
FROM raw_data
WHERE continent != ''


-- Query to compare count of total COVID-19 cases across continents, till end of Feb-2022.
SELECT continent, SUM(new_cases) AS total_cases
FROM raw_data
WHERE continent != '' AND date < '2022-03-01'
GROUP BY 1
ORDER BY 2 DESC


-- Create a view for total cases per continent, till end of Feb-2022.
CREATE VIEW cases_by_continent
AS	(
	SELECT continent, SUM(new_cases) AS total_cases
	FROM raw_data
	WHERE continent != '' AND date < '2022-03-01'
	GROUP BY 1
	ORDER BY 2 DESC
	)


-- Query to retrieve total cases and total deaths per country, till end of Feb-2022.
SELECT location AS country, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths
FROM raw_data
WHERE continent != '' AND date < '2022-03-01'
GROUP BY 1


-- Query to retrieve hierarchy of deadliest countries, COALESCE used to replace NULLs with 0.
SELECT country, ROUND(COALESCE(total_deaths/total_cases, 0), 4) AS death_rate_from_infection
FROM(
	SELECT location AS country, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths
	FROM raw_data
	WHERE continent != '' AND date < '2022-03-01'
	GROUP BY 1
	) AS sub_1
ORDER BY 2 DESC


-- Create a view with the hierarchy of deadliest countries, COALESCE used to replace NULLs with 0.
CREATE VIEW deadliest_countries
AS	(
	SELECT country, ROUND(COALESCE(total_deaths/total_cases, 0), 4) AS death_rate_from_infection
	FROM(
		SELECT location AS country, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths
		FROM raw_data
		WHERE continent != '' AND date < '2022-03-01'
		GROUP BY 1
		) AS sub_1
	ORDER BY 2 DESC
	)


-- Query to compare count of total COVID-19 deaths across continents, till end of Feb-2022.
SELECT continent, SUM(new_deaths) AS total_deaths
FROM raw_data
WHERE continent != '' AND date < '2022-03-01'
GROUP BY 1
ORDER BY 2 DESC


-- Create a view for total deaths per continent, till end of Feb-2022.
CREATE VIEW deaths_by_continent
AS	(
	SELECT continent, SUM(new_deaths) AS total_deaths
	FROM raw_data
	WHERE continent != '' AND date < '2022-03-01'
	GROUP BY 1
	ORDER BY 2 DESC
	)


-- Query to retrieve daily sum of new cases and new deaths.
SELECT date, SUM(new_cases) AS daily_cases, SUM(new_deaths) AS daily_deaths
FROM raw_data
WHERE continent != '' AND date < '2022-03-01' AND new_cases IS NOT NULL
GROUP BY date


-- Query to calculate running totals of new cases and new deaths, till end of Feb-2022.
SELECT date, SUM(daily_cases) OVER (ORDER BY DATE ASC) AS running_total_new_cases, SUM(daily_deaths) OVER (ORDER BY DATE ASC) AS running_total_new_deaths
FROM(
	SELECT date, SUM(new_cases) AS daily_cases, SUM(new_deaths) AS daily_deaths
	FROM raw_data
	WHERE continent != '' AND date < '2022-03-01' AND new_cases IS NOT NULL
	GROUP BY date
	) AS sub_1


-- Create a view with running totals of new cases and new deaths, till end of Feb-2022.
CREATE VIEW running_totals
AS	(
	SELECT date, SUM(daily_cases) OVER (ORDER BY DATE ASC) AS running_total_new_cases, SUM(daily_deaths) OVER (ORDER BY DATE ASC) AS running_total_new_deaths
	FROM(
		SELECT date, SUM(new_cases) AS daily_cases, SUM(new_deaths) AS daily_deaths
		FROM raw_data
		WHERE continent != '' AND date < '2022-03-01' AND new_cases IS NOT NULL
		GROUP BY date
		) AS sub_1
	)