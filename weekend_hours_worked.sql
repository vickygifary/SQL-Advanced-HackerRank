WITH WeekendLogs AS (
    SELECT 
        emp_id,
        timestamp,
        DATE(timestamp) AS date,
        DAYOFWEEK(timestamp) AS day_of_week
    FROM 
        attendance
    WHERE 
        DAYOFWEEK(timestamp) IN (1, 7) -- 1 for Sunday, 7 for Saturday
),
PairedLogs AS (
    SELECT 
        a.emp_id,
        a.timestamp AS login_time,
        MIN(b.timestamp) AS logout_time
    FROM 
        WeekendLogs a
    JOIN 
        WeekendLogs b
    ON 
        a.emp_id = b.emp_id AND 
        a.timestamp < b.timestamp AND
        DATE(a.timestamp) = DATE(b.timestamp)
    GROUP BY 
        a.emp_id, a.timestamp
),
HoursWorked AS (
    SELECT 
        emp_id,
        FLOOR(TIMESTAMPDIFF(HOUR, login_time, logout_time)) AS hours_worked
    FROM 
        PairedLogs
)
SELECT 
    emp_id,
    SUM(hours_worked) AS total_weekend_hours
FROM 
    HoursWorked
GROUP BY 
    emp_id
ORDER BY 
    total_weekend_hours DESC;
