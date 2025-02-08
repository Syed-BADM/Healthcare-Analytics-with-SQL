CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    reason TEXT,
    status TEXT
);

create table paitent (
	paitent_id INT PRIMARY KEY,
	name text,
	age INT,
	gender text,
	address text,
	contact_number bigint);

create table doctor (
	doctor_id INT PRIMARY KEY,
	name TEXT,
	specialization TEXT,
	experience_years INT,
	contact_number BIGINT NOT NULL);

create table diagnoses (
	diagnosis_id INT PRIMARY KEY,
	patient_id INT NOT NULL,
	doctor_id INT NOT NULL,
	diagnosis_date DATE NOT NULL,
	diagnosis TEXT,
	treatment TEXT
)

create table medication (
	medication_id INT PRIMARY KEY,
	diagnosis_id INT NOT NULL,
	medication_name TEXT,
	dosage TEXT,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
)


---Inner and Equi Joins

SELECT 
    appointments.appointment_id,
	paitent.name,
	doctor.name,
	appointments.status from appointments
	inner join paitent on appointments.patient_id = paitent.paitent_id
	inner join doctor on appointments.doctor_id = doctor.doctor_id
	where appointments.status ='Completed';

---Left Join with Null Handling

Select 
	paitent.name,
	paitent.contact_number,
	paitent.address
	from paitent
	left join appointments on paitent.paitent_id = appointments.appointment_id
	where appointments.appointment_id is NULL;


---Right Join and Aggregate Functions

Select 
	doctor.doctor_id,
	doctor.name,
	doctor.specialization,
	Count(diagnoses.diagnosis) as Total_diagnoses
	from doctor right join diagnoses on doctor.doctor_id = diagnoses.doctor_id
	Group by doctor.doctor_id,doctor.name,doctor.specialization
	order by Total_diagnoses desc;

---Full Join for Overlapping Data

SELECT 
    COALESCE(appointments.appointment_id, diagnoses.diagnosis_id) AS record_id,
    paitent.name,
  	doctor.name,
    doctor.specialization,
    diagnoses.diagnosis_date,
    diagnoses.diagnosis AS diagnosis_details
FROM appointments 
FULL JOIN diagnoses ON appointments.patient_id = diagnoses.patient_id
LEFT JOIN paitent  ON COALESCE(appointments.patient_id, diagnoses.patient_id) = paitent.paitent_id
LEFT JOIN doctor ON COALESCE(appointments.doctor_id, diagnoses.doctor_id) = doctor.doctor_id
WHERE appointments.patient_id IS NULL OR diagnoses.patient_id IS NULL;

---Window Functions (Ranking and Aggregation)

SELECT 
    doctor.name,
    doctor.specialization,
    paitent.name,
    COUNT(appointments.appointment_id) AS total_appointments,
    RANK() OVER (PARTITION BY doctor.doctor_id ORDER BY COUNT(appointments.appointment_id) DESC) AS rank
FROM appointments 
JOIN paitent ON appointments.patient_id = paitent.paitent_id
JOIN doctor ON appointments.doctor_id = doctor.doctor_id
GROUP BY doctor.doctor_id, doctor.name, doctor.specialization, paitent.paitent_id, paitent.name
ORDER BY doctor.doctor_id desc;


---conditional Expressions

SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        WHEN age >= 51 THEN '51+'
        ELSE 'Unknown' -- Handle NULL or unexpected values
    END AS age_group,
    COUNT(*) AS total_patients
FROM paitent
GROUP BY age_group
ORDER BY age_group;

---Numeric and String Functions

SELECT 
    UPPER(name) as name_uppercase,
	contact_number from paitent
	where contact_number::Text like '%1234';

	
---Subqueries for Filtering

SELECT paitent_id,name
FROM paitent
WHERE paitent_id IN (
    SELECT patient_id 
    FROM diagnoses
    WHERE diagnosis = 'Insulin'
    GROUP BY patient_id
    HAVING COUNT(DISTINCT diagnosis) = '1'
);

---Date and Time Functions

SELECT 
    diagnosis_id,
    AVG(medication.end_date - medication.start_date) AS avg_duration_days
FROM medication
GROUP BY diagnosis_id;

--- Complex Joins and Aggregation

SELECT 
    doctor.name,
    doctor.specialization,
    COUNT(DISTINCT paitent.paitent_id) AS unique_patient_count
FROM 
    doctor
JOIN 
    appointments ON doctor.doctor_id = appointments.doctor_id
JOIN 
   paitent ON appointments.patient_id = paitent.paitent_id
GROUP BY 
    doctor.doctor_id, doctor.name, doctor.specialization
ORDER BY 
    unique_patient_count DESC
LIMIT 1;

________________________________________________________________________________________________________________________________________________________________________________








	