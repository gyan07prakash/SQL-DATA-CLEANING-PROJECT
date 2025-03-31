 -- DATA CLEANING
 
 -- 1) Remove Duplicates
 -- 2) Standardize the data
 -- 3) Null values or Blank Values 
 
 -- to avoid changing raw data, Create a staging table
CREATE  TABLE layoffs_staging
LIKE layoffs;
 
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1)removing Duplicates

-- identifyingduplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions)
AS row_num
FROM layoffs_staging
)
SELECT* 
FROM duplicate_cte 
WHERE  row_num>1;

-- createing another table to delete since you cannot update a cte
CREATE TABLE `layoffs_staging_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging_2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, total_laid_off, 'date', stage, country, funds_raised_millions)
AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging_2
WHERE row_num >1;

SELECT *
FROM layoffs_staging_2
WHERE row_num >1;

-- 2) Standardizing data

-- Trimming extra spaces in company names
SELECT company, TRIM(company)
FROM layoffs_staging_2;

-- Updating similar or same name error to proper name in industry
SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- removing null values








 

