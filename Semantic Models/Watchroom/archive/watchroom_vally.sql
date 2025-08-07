-- Watchroom "all reports" table with validation rule errors


--########################################################################################
--TODO:
--########################################################################################
WITH fire_validation_rules AS (
    SELECT
        Fact_Fire.Fact_Fire_PK,
    
        --########################################################################################
        -- let's grab each validation rule error message and combine them, for each FIRE incident
        CASE 
            WHEN Dim_Basic.Basic_Incident_Status = 'In Progress'
            THEN COALESCE(
                STRING_AGG(
                    CASE 
                        -- is the validation rule error message null or empty?  .. just use the validation rule name, instead!
                        WHEN Dim_ValidationRules.Incident_Validation_Rule_Error_Message IS NULL 
                          OR Dim_ValidationRules.Incident_Validation_Rule_Error_Message = '' 
                        THEN Dim_ValidationRules.Incident_Validation_Rule_Name
                        -- we can "cast" as a varchar(65) to limit the length and avoid that one error we got.
                        ELSE CAST(Dim_ValidationRules.Incident_Validation_Rule_Error_Message AS VARCHAR(65))
                    END, ', '
                ), 'None')
            ELSE 'None'
        END AS validation_rule_error


    FROM [Elite_DWPortland].[DwFire].[Fact_Fire] Fact_Fire

    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK

    LEFT JOIN
        [Elite_DWPortland].[DwFire].[Bridge_Fire_ValidationRules] Bridge_Fire_ValidationRules
        ON Fact_Fire.Fact_Fire_PK = Bridge_Fire_ValidationRules.Fact_Fire_PK


    LEFT JOIN
        [Elite_DWPortland].[DwFire].[Dim_ValidationRules] Dim_ValidationRules
        ON Bridge_Fire_ValidationRules.Dim_ValidationRules_PK = Dim_ValidationRules.Dim_ValidationRules_PK


    WHERE
    -- '2024-08-19' is the "go live date" for the fire data
        Fact_Fire.CreatedOn >= '2024-08-19'

        -- Pull only data for the 'portlandfi' agency
        AND Fact_Fire.Agency_Shortname = 'portlandfi'
        --AND Dim_ValidationRules.Incident_Validation_Rule_Error_Message IS NOT NULL  -- Filter to only relevant validation rules


    GROUP BY
        -- NOTE: because we use an aggregation function above (STRING_AGG) - we need to "group" all other columns #shrug
        Fact_Fire.Fact_Fire_PK,
        Dim_Basic.Basic_Incident_Status
),


--########################################################################################
--TODO:
--########################################################################################

ems_validation_rules AS (
    SELECT
        Fact_Incident.Fact_Incident_PK,

        --########################################################################################
        -- let's grab each validation rule error message and combine them, for each FIRE incident
        CASE 
            WHEN Dim_Incident.Incident_Status = 'In Progress' OR Dim_Incident.Incident_Status = 'Crew Documentation Finished' OR Dim_Incident.Incident_Status = 'Auto Posted'
            THEN COALESCE(
                STRING_AGG(
                    CASE 
                        -- is the validation rule error message null or empty?  .. just use the validation rule name, instead!
                        WHEN Dim_ValidationRules.Incident_Validation_Rule_Error_Message IS NULL 
                          OR Dim_ValidationRules.Incident_Validation_Rule_Error_Message = '' 
                        THEN Dim_ValidationRules.Incident_Validation_Rule_Name
                        -- we can "cast" as a varchar(65) to limit the length and avoid that one error we got.
                        ELSE CAST(Dim_ValidationRules.Incident_Validation_Rule_Error_Message AS VARCHAR(65))
                    END, ', '
                ), 'None')
            ELSE 'None'
        END AS validation_rule_error

    FROM [Elite_DWPortland].[DwEms].[Fact_Incident] Fact_Incident

    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] ON Fact_Incident.Dim_Incident_FK = Dim_Incident.Dim_Incident_PK

    LEFT JOIN
        [Elite_DWPortland].[DwEms].[Bridge_Incident_ValidationRules] Bridge_Incident_ValidationRules
        ON Fact_Incident.Fact_Incident_PK = Bridge_Incident_ValidationRules.Fact_Incident_PK

    LEFT JOIN
        [Elite_DWPortland].[DwEms].[Dim_ValidationRules] Dim_ValidationRules
        ON Bridge_Incident_ValidationRules.Dim_ValidationRules_PK = Dim_ValidationRules.Dim_ValidationRules_PK

    WHERE
        -- '2024-08-19' is the "go live date" for the fire data
        Fact_Incident.CreatedOn >= '2024-08-19'

        -- Pull only data for the 'portlandfi' agency
        AND Fact_Incident.Incident_Agency_Short_Name = 'portlandfi'

        --AND Dim_ValidationRules.Incident_Validation_Rule_Error_Message IS NOT NULL  -- Filter to only relevant validation rules
    GROUP BY

        Fact_Incident.Fact_Incident_PK,
        Dim_Incident.Incident_Status
),

/*
########################################################################################
Below we do a UNION ALL of both "ems" and "fire" fact tables.

In this way, we can get a table with ALL OF THE REPORTS that are in the system and that crews are responsible for.

NOTE: there are differences between the "fire" and "ems" schemas.  So in each section below we have to grab a different table/column to ensure the resulting table is coherent between both datasets.

Additionally, there are several computed columns.  One such, is "status" TODO: explain more here

########################################################################################
*/
first_query AS (


    -- First UNION ALL: MEDICAL section.
    SELECT
        'MEDICAL' AS report,
        Fact_Incident.CreatedOn AS created_on,
        Fact_Incident.Incident_Agency_Short_Name AS agency,

        -- Status
        Fact_Incident.Incident_Validity_Score AS score,
        CASE
             WHEN Dim_Incident.Incident_Status = 'Exported To State' THEN 'Finished'
             WHEN Dim_Incident.Incident_Status = 'Crew Documentation Finished' THEN 'Failed'
             ELSE Dim_Incident.Incident_Status
        END AS status,

        -- Unique Record
        COALESCE(CONVERT(VARCHAR(255), Fact_Incident.Patient_Age_In_Years), '__') + ' year old' AS unique_record_id,

        -- Incident details
        Dim_Incident.Incident_Unit_Notified_By_Dispatch_Date_Time AS alarm_time,
        Dim_Incident_One_To_One.Response_Incident_Number AS RP,
        Dim_Incident.Incident_Initial_CAD_Dispatch_Code AS 'EMD - desc',
        Dim_Response.Response_EMS_Unit_Call_Sign AS 'Responding Units',
        Dim_Response.Response_EMS_Shift AS shift,

        -- FMA calculation
        CASE
            WHEN Dim_Response.Response_EMS_Unit_Call_Sign = '' THEN '?'
            WHEN Dim_Response.Response_EMS_Unit_Call_Sign LIKE 'M%' THEN '?'
            WHEN Dim_Response.Response_EMS_Unit_Call_Sign LIKE 'B%' THEN '?'
            WHEN Dim_Response.Response_EMS_Unit_Call_Sign LIKE 'LZ%' THEN '?'
            WHEN Dim_Response.Response_EMS_Unit_Call_Sign = 'R99' THEN 'R99'
            ELSE 'Station ' + SUBSTRING(Dim_Response.Response_EMS_Unit_Call_Sign, PATINDEX('%[0-9]%', Dim_Response.Response_EMS_Unit_Call_Sign), LEN(Dim_Response.Response_EMS_Unit_Call_Sign))
        END AS FMA,

        -- Address
        Dim_Scene.Scene_Incident_Full_Address AS address,

        -- Author
        CASE
            WHEN Dim_Incident.Incident_Crew_Member_Name_Completing_This_Report IS NULL
              OR Dim_Incident.Incident_Crew_Member_Name_Completing_This_Report = ''
            THEN Dim_Incident.Incident_Record_Created_By
            ELSE Dim_Incident.Incident_Crew_Member_Name_Completing_This_Report
        END AS author,

        -- Disposition
        Dim_Disposition.Disposition_Transport_Disposition AS 'disposition',

        -- URL link
        Fact_Incident.Incident_Form_Number AS form_number,
        Fact_Incident.Incident_Transaction_GUID_Internal AS url_incident,
        'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/EmsRunForm#/Incident'
            + CONVERT(VARCHAR(255), Fact_Incident.Incident_Transaction_GUID_Internal)
            + '/Form'
            + CONVERT(VARCHAR(255), Fact_Incident.Incident_Form_Number) AS link,

        -- EMS Validation Rule IDs
        COALESCE(ems_vr.validation_rule_error, 'None') AS 'report validation errors'

    FROM [Elite_DWPortland].[DwEms].[Fact_Incident] Fact_Incident
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] ON Fact_Incident.Dim_Incident_FK = Dim_Incident.Dim_Incident_PK
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One] ON Fact_Incident.Dim_Incident_One_To_One_PK = Dim_Incident_One_To_One.Dim_Incident_One_To_One_PK
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Scene] ON Fact_Incident.Dim_Scene_FK = Dim_Scene.Dim_Scene_PK
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Response] ON Fact_Incident.Dim_Response_FK = Dim_Response.Dim_Response_PK
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Disposition] ON Fact_Incident.Dim_Disposition_FK = Dim_Disposition.Dim_Disposition_PK
    LEFT JOIN ems_validation_rules ems_vr ON Fact_Incident.Fact_Incident_PK = ems_vr.Fact_Incident_PK
    WHERE Fact_Incident.CreatedOn >= '2024-08-19'
      AND Fact_Incident.Incident_Agency_Short_Name = 'portlandfi'
      AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHAT%'
      AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'PSR%'
      AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHS%'
      AND Fact_Incident.Incident_Form_Number = 118



    UNION ALL

    -- Second UNION ALL: FIRE section.
    SELECT
        'FIRE' AS report,
        Fact_Fire.CreatedOn AS created_on,
        Fact_Fire.Agency_Shortname AS agency,

        -- Status
        --TODO:
        Fact_Fire.Basic_Incident_Validity_Score AS score,
        CASE
             WHEN Dim_Basic.Basic_Incident_Status = 'Crew Documentation Finished' THEN 'Finished'
             WHEN Dim_Basic.Basic_Incident_Status = 'Exported To State' THEN 'Finished'
             WHEN Dim_Basic.Basic_Incident_Status = 'Crew Edits Complete' THEN 'Finished'
             ELSE Dim_Basic.Basic_Incident_Status
        END AS status,

        -- Unique Record
        'Exposure ' + CONVERT(VARCHAR(255), Dim_Basic.Basic_Exposure) AS unique_record_id,

        -- Incident details
        Dim_Basic.Basic_Incident_Alarm_Time AS alarm_time,
        Dim_Basic.Basic_Incident_Number AS RP,
        Dim_Fire.Fire_Initial_CAD_Incident_Type_Description AS 'EMD - desc',
        Dim_Basic.Basic_Apparatus_Call_Sign_List AS 'Responding Units',
        Dim_Basic.Basic_Shift_Or_Platoon AS shift,
        CASE
            WHEN COALESCE(Dim_Basic.Basic_Primary_Station_Name, '') = '' THEN '?'
            ELSE Dim_Basic.Basic_Primary_Station_Name
        END AS FMA,

        -- Address
        Dim_Basic.Basic_Incident_Full_Address AS address,

        -- Author
        --TODO:
        Dim_Basic.Basic_Authorization_Member_Making_Report_Name AS 'author',

        -- Disposition
        Dim_Basic.Basic_Primary_Action_Taken AS 'disposition',

        -- URL link
        --TODO:
        Fact_Fire.Basic_Incident_Form_Number AS form_number,
        Fact_Fire.Incident_ID_Internal AS url_incident,
        'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident'
            + CONVERT(VARCHAR(255), Fact_Fire.Incident_ID_Internal)
            + '/Form'
            + CONVERT(VARCHAR(255), Fact_Fire.Basic_Incident_Form_Number) AS link,

        -- Validation Rule IDs, compose as comma-separated values
        COALESCE(vr.validation_rule_error, 'None') AS 'report validation errors'


    FROM [Elite_DWPortland].[DwFire].[Fact_Fire]

    --Bring in Basic tables
    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
    -- 
    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Fire] ON Fact_Fire.Dim_Fire_FK = Dim_Fire.Dim_Fire_PK
    LEFT JOIN fire_validation_rules vr ON Fact_Fire.Fact_Fire_PK = vr.Fact_Fire_PK
    WHERE Fact_Fire.CreatedOn >= '2024-08-19'
      AND Fact_Fire.Agency_shortname = 'portlandfi'
)

SELECT * FROM first_query;
