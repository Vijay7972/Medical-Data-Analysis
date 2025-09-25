use hospital;
select * from admissions;
select * from doctors;
select * from patient;
select * from province_names;

############  Medical Data History  ############

### Perform the Problem Queries:

# 1. Show how many patients have a birth_date with 2010 as the birth year.
SELECT count(*) AS Total_Patients
FROM patient
WHERE YEAR (birth_date) = '2010';


# 2. Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT *
FROM admission
WHERE admission_date = discharge_date;


# 3. Show unique first names from the patients table which only occurs once in the list.
SELECT first_name
FROM patient
GROUP BY first_name
HAVING count(first_name) = 1;


# 4. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
SELECT SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END)  AS Male_Count,
	   SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END)  AS Female_Count
FROM patient;


# 5. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT patient_id, diagnosis
FROM admission
GROUP BY patient_id, diagnosis
HAVING count(*) > 1;


# 6. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
SELECT city, COUNT(*) as total_patients
FROM patient
GROUP BY city
ORDER BY total_patients DESC, city  ASC;


# 7. Show all allergies ordered by popularity. Remove NULL values from query.
SELECT allergies, COUNT(patient_id) AS popularity
FROM patient
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY popularity DESC;


# 8. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
SELECT DAY(admission_date) , COUNT(*) AS Total_admissions
FROM admission
GROUP BY DAY(admission_date)
ORDER BY COUNT(patient_id) DESC;


# 9.Top Doctors by Patient Reach.
SELECT d.doctor_id, d.first_name, d.specialty, COUNT(DISTINCT a.patient_id) AS unique_patients
FROM doctor d
JOIN admission a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id, d.first_name, d.specialty
ORDER BY unique_patients DESC
LIMIT 5;


# 10. Average Length of Stay (LOS) per Diagnosis
SELECT diagnosis, 
       ROUND(AVG(DATEDIFF(discharge_date, admission_date)),2) AS avg_stay_days
FROM admission
WHERE discharge_date IS NOT NULL
GROUP BY diagnosis
ORDER BY avg_stay_days DESC;


# 11. Patient-to-Doctor Ratio by Province
SELECT pn.province_name, count(distinct p.patient_id) / count(distinct d.doctor_id) AS doctor_patient_ratio
FROM patient p
JOIN admission ad ON p.patient_id = ad.patient_id
JOIN doctor d ON ad.attending_doctor_id = d.doctor_id
JOIN province_names pn ON p.province_id = pn.province_id
GROUP BY pn.province_name;


# 12.Admissions by Season
WITH cte AS(
SELECT CASE 
             WHEN MONTH(admission_date) IN (12,1,2) THEN 'Winter'
             WHEN MONTH(admission_date) IN (3,4,5) THEN 'Spring'
             WHEN MONTH(admission_date) IN (6,7,8) THEN 'Summer'
             ELSE 'Fall'
             END AS season,
             COUNT(*) AS Admissions
FROM admission
GROUP BY admission_date)

SELECT season, COUNT(admissions) as Total_admissions
FROM cte
GROUP BY season
ORDER BY Total_admissions DESC;


# 13.Average Admissions per Doctor Specialty
SELECT d.specialty, ROUND(COUNT(a.patient_id)/COUNT(DISTINCT d.doctor_id),2) AS avg_admissions_per_doctor
FROM doctor d
JOIN admission a ON d.doctor_id = a.attending_doctor_id
JOIN patient p ON p.patient_id = a.patient_id
GROUP BY d.specialty
ORDER BY avg_admissions_per_doctor DESC;





