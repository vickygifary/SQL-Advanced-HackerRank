SELECT 
    DATE_FORMAT(record_date, '%c') AS month,  -- '%c' removes leading zeros
    MAX(CASE WHEN data_type = 'max' THEN data_value END) AS max,
    MIN(CASE WHEN data_type = 'min' THEN data_value END) AS min,
    ROUND(AVG(CASE WHEN data_type = 'avg' THEN data_value END)) AS avg
FROM temperature_records
GROUP BY month
ORDER BY month;
