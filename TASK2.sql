SELECT 
	EMPLID,
    EMP_RCD,
    EFFDT,
    COMPANY,
	Birthdate,
	Current_Age_In_Years,
	Gender,
	Preferred_Phone
FROM (
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY j.EMPLID ORDER BY EFFDT DESC, j.EFF_SEQ DESC) AS row_no,
		j.EMPLID,
		j.EMP_RCD,
		STR_TO_DATE(j.EFFDT, '%m/%d/%Y') AS EFFDT,
		j.eff_seq,
		Column1 AS COMPANY,
		STR_TO_DATE(pd.Birthdate, '%m/%d/%Y') AS Birthdate,
		DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(),
								STR_TO_DATE(pd.Birthdate, '%m/%d/%Y'))),
				'%Y') + 0 AS Current_Age_In_Years,
		CASE
			WHEN pd.Gender = 'M' THEN 'Male'
			WHEN pd.Gender = 'F' THEN 'Female'
		END Gender,
        
		CASE
			WHEN pp.Preferred='Y' THEN pp.Phone
			ELSE 'n/a'
		END Preferred_Phone
	
    FROM
		PERSONAL_DATA pd
			LEFT JOIN
		PERSONAL_PHONE pp ON pd.EMPLID = pp.EMPLID AND pp.Preferred='Y'
			INNER JOIN
		JOB j ON pd.EMPLID = j.EMPLID AND j.HR_STATUS = 'Active'
        ) AS t1
        
WHERE row_no=1