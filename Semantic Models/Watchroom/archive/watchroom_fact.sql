-- origional version

WITH first_query AS (
SELECT 
    --'ePCR' AS report,
    'MEDICAL' AS report,
    Fact_Incident.CreatedOn AS created_on,
    Fact_Incident.Incident_Agency_Short_Name as agency,

    -- status
    Fact_Incident.Incident_Validity_Score AS score,
    CASE 
        -- Unless the status changes to 'Exported To State' it's not done correctly and will stay 'Crew Documentation Finished' - these ePCRs usually fail export
        WHEN Dim_Incident.Incident_Status = 'Exported To State' THEN 'Finished'
        WHEN Dim_Incident.Incident_Status = 'Crew Documentation Finished' THEN 'Failed'
        ELSE Dim_Incident.Incident_Status 
    END AS status,

    -- Unique Record
    COALESCE(CONVERT(VARCHAR(255), Fact_Incident.Patient_Age_In_Years), '__') + ' year old' AS unique_record_id,

    -- incident details
    Dim_Incident.Incident_Unit_Notified_By_Dispatch_Date_Time AS alarm_time,
    Dim_Incident_One_To_One.Response_Incident_Number as RP,
    Dim_Incident.Incident_Initial_CAD_Dispatch_Code as 'EMD - desc',
    Dim_Response.Response_EMS_Unit_Call_Sign as 'Responding Units',
    Dim_Response.Response_EMS_Shift as shift,
    --NULL as FMA, -- how will we do this, hermmm...?
    CASE
        WHEN Dim_Response.Response_EMS_Unit_Call_Sign = '' THEN '?'
        WHEN Dim_Response.Response_EMS_Unit_Call_Sign LIKE 'M%' THEN '?'
        WHEN Dim_Response.Response_EMS_Unit_Call_Sign LIKE 'B%' THEN '?'
        WHEN Dim_Response.Response_EMS_Unit_Call_Sign LIKE 'LZ%' THEN '?'
        WHEN Dim_Response.Response_EMS_Unit_Call_Sign = 'R99' THEN 'R99'
        ELSE 'Station ' + 
            SUBSTRING(
                Dim_Response.Response_EMS_Unit_Call_Sign, 
                PATINDEX('%[0-9]%', Dim_Response.Response_EMS_Unit_Call_Sign),
                LEN(Dim_Response.Response_EMS_Unit_Call_Sign)
            )
    END as FMA,
    Dim_Scene.Scene_Incident_Full_Address as address,

    -- crew member / author
    CASE
        WHEN Dim_Incident.Incident_Crew_Member_Name_Completing_This_Report IS NULL 
         OR Dim_Incident.Incident_Crew_Member_Name_Completing_This_Report = ''
        THEN Dim_Incident.Incident_Record_Created_By
        ELSE Dim_Incident.Incident_Crew_Member_Name_Completing_This_Report
    END as author,

    -- disposition
    Dim_Disposition.Disposition_Transport_Disposition as 'disposition',

    -- URL
    Fact_Incident.Incident_Form_Number AS form_number,
    Fact_Incident.Incident_Transaction_GUID_Internal AS url_incident,
    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/EmsRunForm#/Incident' 
    + CONVERT(VARCHAR(255), Fact_Incident.Incident_Transaction_GUID_Internal) 
    + '/Form' 
    + CONVERT(VARCHAR(255), Fact_Incident.Incident_Form_Number) AS link

FROM [Elite_DWPortland].[DwEms].[Fact_Incident] 
INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] 
    ON Fact_Incident.Dim_Incident_FK = Dim_Incident.Dim_Incident_PK
INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One]
    ON Fact_Incident.Dim_Incident_One_To_One_PK = Dim_Incident_One_To_One.Dim_Incident_One_To_One_PK
INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Scene]
    ON Fact_Incident.Dim_Scene_FK = Dim_Scene.Dim_Scene_PK
INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Response]
    ON Fact_Incident.Dim_Response_FK = Dim_Response.Dim_Response_PK
INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Disposition]
    ON Fact_Incident.Dim_Disposition_FK = Dim_Disposition.Dim_Disposition_PK
WHERE Fact_Incident.CreatedOn >= '2024-08-19'
AND Fact_Incident.Incident_Agency_Short_Name = 'portlandfi'
AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHAT%'
AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'PSR%'
AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHS%'
AND Fact_Incident.Incident_Form_Number = 118

UNION ALL

SELECT 
    --'NFIRS' AS report,
    'FIRE' AS report,
    Fact_Fire.CreatedOn AS created_on,
    Fact_Fire.Agency_Shortname as agency,

    -- status
    Fact_Fire.Basic_Incident_Validity_Score AS score,
    CASE 
        -- This means finished, there's no 'Exported To State' status after a successfull schematron validation
        --- ... but there is an odd edge case where it still happens
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Documentation Finished' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Exported To State' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Edits Complete' THEN 'Finished'
        ELSE Dim_Basic.Basic_Incident_Status 
    END AS status,

    -- Unique Record
    'Exposure ' + CONVERT(VARCHAR(255), Dim_Basic.Basic_Exposure) AS unique_record_id,

    -- incident details
    Dim_Basic.Basic_Incident_Alarm_Time AS alarm_time,
    Dim_Basic.Basic_Incident_Number as RP,
    Dim_Fire.Fire_Initial_CAD_Incident_Type_Description as 'EMD - desc',
    Dim_Basic.Basic_Apparatus_Call_Sign_List as 'Responding Units',
    Dim_Basic.Basic_Shift_Or_Platoon as shift,
    CASE
        WHEN COALESCE(Dim_Basic.Basic_Primary_Station_Name, '') = '' THEN '?'
        ELSE Dim_Basic.Basic_Primary_Station_Name
    END as FMA,
    Dim_Basic.Basic_Incident_Full_Address as address,

    -- crew member / author
    Dim_Basic.Basic_Authorization_Member_Making_Report_Name as 'author',

    -- disposition
    Dim_Basic.Basic_Primary_Action_Taken as 'disposition',

    -- URL
    Fact_Fire.Basic_Incident_Form_Number AS form_number,
    Fact_Fire.Incident_ID_Internal AS url_incident,
    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident' 
    + CONVERT(VARCHAR(255), Fact_Fire.Incident_ID_Internal) 
    + '/Form' 
    + CONVERT(VARCHAR(255), Fact_Fire.Basic_Incident_Form_Number) AS link

FROM [Elite_DWPortland].[DwFire].[Fact_Fire]
INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] 
    ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK

LEFT JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ValidationRules]
    ON Fact_Fire.Fact_Fire_PK = Bridge_Fire_ValidationRules.Fact_Fire_PK
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_ValidationRules]
    ON Bridge_Fire_ValidationRules.Dim_ValidationRules_PK = Dim_ValidationRules.Dim_ValidationRules_PK

INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Fire] 
    ON Fact_Fire.Dim_Fire_FK = Dim_Fire.Dim_Fire_PK
WHERE Fact_Fire.CreatedOn >= '2024-08-19'
AND Fact_Fire.Agency_shortname = 'portlandfi'

-- Needed when running query locally to diagnose DataMart record completeness
--ORDER BY alarm_time DESC
)




-- SELECT 
--     fq.[Responding Units],
--     fq.alarm_time as time,
--     fq.RP,
--     unit_split.unit AS unit -- Select the extracted unit name



-- FROM first_query fq
-- CROSS APPLY (
--     SELECT 
--         TRIM(value) AS unit -- Extract individual units from the delimited list
--     FROM STRING_SPLIT(fq.[Responding Units], ',')
-- ) unit_split

--ORDER BY alarm_time DESC;
