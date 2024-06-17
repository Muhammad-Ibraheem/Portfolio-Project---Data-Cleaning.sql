-- Data Cleaning

select * from layoffs;

-- 1. Remove duplicaes
-- 2. standardize the data
-- 3. Null or blank values
-- 4. Remove columns which are not required for the analysis


-- Removing Duplicate rows 
create table layoffs_stagging
like layoffs;


select * from layoffs_stagging;

insert layoffs_stagging
select distinct * from layoffs;


select * from layoffs_stagging;



select *, 
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_stagging;

with duplicate_cte as (
select *, 
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_stagging
)
select * from duplicate_cte
where row_num > 1;

select * from layoffs_stagging
where company = 'Casper';


CREATE TABLE `layoffs_stagging2` (
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

select *
from layoffs_stagging2;


insert into layoffs_stagging2
select *, 
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_stagging;


DELETE FROM layoffs_stagging2
WHERE row_num > 1;


select *
from layoffs_stagging2
where row_num > 1;



-- Standardizing the data

select company, trim(company)
from layoffs_stagging2;

update layoffs_stagging2
set company = trim(company);

select distinct industry
from layoffs_stagging2;

update layoffs_stagging2
set industry = 'Crypto'
where industry like 'Crypto%';

select *
from layoffs_stagging2
where country like 'United States.%'
order by 1;

update layoffs_stagging2
set country = trim(trailing '.' from country)
where country like 'United States%';


select `date`
from layoffs_stagging2;

update layoffs_stagging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_stagging2
modify column `date` date;

select * from layoffs_stagging2;

-- Handling Null Values

select * 
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;


select *
from layoffs_stagging2
where industry is null
or industry = '';

select *
from layoffs_stagging2
where company = 'Airbnb';


update layoffs_stagging2
set industry = null
where industry = '';

select *
from layoffs_stagging2 t1
join layoffs_stagging2 t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_stagging2 t1
join layoffs_stagging2 t2
    on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;


select *
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

delete 
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

select * 
from layoffs_stagging2;

alter table layoffs_stagging2
drop column row_num;
