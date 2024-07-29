-- Data Cleaning
SET SQL_SAFE_UPDATES = 0;

SELECT * FROM LAYOFFS ;

-- Remove Duplicates
-- Standardize the data 
-- Look For Null Value or Blank Value 
-- Remove any colum/rows 

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * from layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;


 
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() Over( PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, 'date') AS row_num
from layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1 ;

SELECT * from layoffs_staging;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() Over( PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, 'date') AS row_num
from layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1; 

DELETE 
FROM layoffs_staging2
WHERE row_num > 1; 


SELECT * 
FROM layoffs_staging2
WHERE row_num > 1; 

SELECT * 
FROM layoffs_staging2;

-- Standardizing data 

SELECT company,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT industry,TRIM(industry)
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1 ;

UPDATE layoffs_staging2
SET industry = TRIM(industry);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%' ;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging
Order By 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

SELECT `date`,
STR_TO_date(`date` , '%m/%d/%Y')
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE ;

-- Working with NULLs and BLANKS 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE company ="Airbnb"


SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company 
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL 

UPDATE layoff_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company 
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final Cleaned Data

SELECT *
FROM layoffs_staging2;

