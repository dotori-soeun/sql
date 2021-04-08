<210322 데이터베이스 JOIN 실습 과제_hr계정>

JOIN8 erd다이어그램을 참고하여 countries, regions테이블을 이용하여 지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)

SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT r.region_id, region_name, country_name
FROM countries c, regions r
WHERE c.region_id = r.region_id
    AND region_name = 'Europe';
--ansi변환    
SELECT r.region_id, region_name, country_name
FROM countries c JOIN regions r ON (c.region_id = r.region_id AND region_name = 'Europe');    
    


JOIN9 erd다이어그램을 참고하여 countries, regions, locations 테이블을 이용하여 
지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)

SELECT *
FROM locations;

SELECT r.region_id, region_name, country_name, city
FROM countries c, regions r, locations l
WHERE c.region_id = r.region_id
    AND c.country_id = l.country_id
    AND region_name = 'Europe';
--ansi변환
SELECT r.region_id, region_name, country_name, city
FROM countries c JOIN regions r ON (c.region_id = r.region_id AND region_name = 'Europe')
        JOIN locations l ON (c.country_id = l.country_id);

    

JOIN10 erd다이어그램을 참고하여 countries, regions, locations, departments 테이블을 이용하여 
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)

SELECT *
FROM departments;

SELECT r.region_id, region_name, country_name, city, department_name
FROM countries c, regions r, locations l, departments d
WHERE c.region_id = r.region_id
    AND c.country_id = l.country_id
    AND d.location_id = l.location_id
    AND region_name = 'Europe';
--ansi변환
SELECT r.region_id, region_name, country_name, city, department_name
FROM countries c JOIN regions r ON ( c.region_id = r.region_id AND region_name = 'Europe' )
    JOIN locations l ON ( c.country_id = l.country_id )
    JOIN departments d ON ( d.location_id = l.location_id);



JOIN11 erd다이어그램을 참고하여 countries, regions, locations, departments, employees 테이블을 이용하여 
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에 소속된 직원정보를
다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)

SELECT *
FROM employees;

SELECT r.region_id, region_name, country_name, city, department_name, first_name||last_name name
FROM countries c, regions r, locations l, departments d, employees e
WHERE c.region_id = r.region_id
    AND c.country_id = l.country_id
    AND d.location_id = l.location_id
    AND d.department_id = e.department_id
    AND region_name = 'Europe';
-- 컬럼명에서 문자와 문자를 더하는 경우 || 수직바 2개!!!!    
-- AND d.manager_id = e.employee_id 이것도 있어!   

--ansi변환
SELECT r.region_id, region_name, country_name, city, department_name, first_name||last_name name
FROM countries c JOIN regions r ON (c.region_id = r.region_id AND region_name = 'Europe')
    JOIN locations l ON (c.country_id = l.country_id)
    JOIN departments d ON (d.location_id = l.location_id)
    JOIN employees e ON (d.department_id = e.department_id);



JOIN12 erd다이어그램을 참고하여 employees, jobs 테이블을 이용하여 
직원의 담당업무 명칭을 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요

SELECT *
FROM jobs;

SELECT employee_id, first_name||last_name name, e.job_id, job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;
--ansi변환
SELECT employee_id, first_name||last_name name, e.job_id, job_title
FROM employees e JOIN jobs j ON (e.job_id = j.job_id);
 


JOIN13 erd다이어그램을 참고하여 employees, jobs 테이블을 이용하여 
직원의 담당업무 명칭, 직원의 매니저 정보 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요

SELECT *
FROM employees;

SELECT m.employee_id mgr_id, m.first_name||m.last_name mgr_name,
    e.employee_id, e.first_name||e.last_name name,
    e.job_id, job_title
FROM employees e, employees m, jobs j
WHERE e.job_id = j.job_id 
    AND e.manager_id = m.employee_id;

--직원의 매니저 정보를 가져와야하는데 job_id를 e에서 가져와야 맞넹.. 매니저정보인데 왜 m에서 가져오는게 아니지???
--job_title도 아예 조건 WHERE e.job_id = j.job_id에서 e.job_id다. m이 아니고

--ansi변환
SELECT m.employee_id mgr_id, m.first_name||m.last_name mgr_name,
    e.employee_id, e.first_name||e.last_name name,
    e.job_id, job_title
FROM employees e JOIN employees m ON (e.manager_id = m.employee_id)
    JOIN jobs j ON (e.job_id = j.job_id);