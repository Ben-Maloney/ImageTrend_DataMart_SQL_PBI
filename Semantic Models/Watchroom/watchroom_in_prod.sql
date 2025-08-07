/*
########################################################################################
DATE: 2024-12-11
AUTHOR: Micah Fullerton
LICENSE: MIT License
DESCRIPTION:
    This query attempts to reconcile two divergent schemas by using a UNION ALL of the 'ems' and 'fire' data sets.
    This query will be imported into the Power BI platform and is custom-designed to be built into a single 'watchroom' report.
    The purpose of this report is to provide similar functionality to Portland Fire's legacy FIS software.

CHANGE LOG:
    2024-10-01: Initial commit

    2024-11-05: Added validation rule error collation

    2024-12-10: Removed filter for CHAT units

    2024-12-10: Added mitigation for error: 'STRING_AGG aggregation result exceeded the limit of 8000 bytes. Use LOB types to avoid result truncation.'

    2024-12-11: Combined functionality of 'all reports' and 'unit responses' reports into a single 'watchroom' report

########################################################################################
*/

WITH numbered_fire_rules AS (
    SELECT 
        Fact_Fire.Fact_Fire_PK,
        Dim_Basic.Basic_Incident_Status,
        Dim_ValidationRules.Incident_Validation_Rule_Error_Message,
        Dim_ValidationRules.Incident_Validation_Rule_Name,
        ROW_NUMBER() OVER (PARTITION BY Fact_Fire.Fact_Fire_PK ORDER BY Dim_ValidationRules.Incident_Validation_Rule_Name) as rn
    FROM [Elite_DWPortland].[DwFire].[Fact_Fire] Fact_Fire
    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
    LEFT JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ValidationRules] Bridge_Fire_ValidationRules
        ON Fact_Fire.Fact_Fire_PK = Bridge_Fire_ValidationRules.Fact_Fire_PK
    LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_ValidationRules] Dim_ValidationRules
        ON Bridge_Fire_ValidationRules.Dim_ValidationRules_PK = Dim_ValidationRules.Dim_ValidationRules_PK
    WHERE Fact_Fire.CreatedOn >= '2024-08-19'
        AND Fact_Fire.Agency_Shortname = 'portlandfi'
),
fire_validation_rules AS (
    SELECT
        Fact_Fire_PK,
        CASE
            WHEN Basic_Incident_Status = 'In Progress'
            THEN COALESCE(
                STRING_AGG(
                    CASE
                        WHEN Incident_Validation_Rule_Error_Message IS NULL
                          OR Incident_Validation_Rule_Error_Message = ''
                        THEN Incident_Validation_Rule_Name
                        ELSE CAST(Incident_Validation_Rule_Error_Message AS VARCHAR(MAX))
                    END, ', '
                ), '-')
            ELSE '-'
        END AS validation_rule_error
    FROM numbered_fire_rules
    WHERE rn <= 8  -- Limit to top 8 validation rules per incident to avoid error: 'STRING_AGG aggregation result exceeded the limit of 8000 bytes.'
    GROUP BY Fact_Fire_PK, Basic_Incident_Status
),

-- ########################################################################################
numbered_ems_rules AS (
    SELECT 
        Fact_Incident.Fact_Incident_PK,
        Dim_Incident.Incident_Status,
        Dim_ValidationRules.Incident_Validation_Rule_Error_Message,
        Dim_ValidationRules.Incident_Validation_Rule_Name,
        ROW_NUMBER() OVER (PARTITION BY Fact_Incident.Fact_Incident_PK ORDER BY Dim_ValidationRules.Incident_Validation_Rule_Name) as rn
    FROM [Elite_DWPortland].[DwEms].[Fact_Incident] Fact_Incident
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] ON Fact_Incident.Dim_Incident_FK = Dim_Incident.Dim_Incident_PK
    LEFT JOIN [Elite_DWPortland].[DwEms].[Bridge_Incident_ValidationRules] Bridge_Incident_ValidationRules
        ON Fact_Incident.Fact_Incident_PK = Bridge_Incident_ValidationRules.Fact_Incident_PK
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_ValidationRules] Dim_ValidationRules
        ON Bridge_Incident_ValidationRules.Dim_ValidationRules_PK = Dim_ValidationRules.Dim_ValidationRules_PK
    WHERE Fact_Incident.CreatedOn >= '2024-08-19'
        AND Fact_Incident.Incident_Agency_Short_Name = 'portlandfi'
),
ems_validation_rules AS (
    SELECT
        Fact_Incident_PK,
        CASE
            WHEN Incident_Status IN ('In Progress', 'Crew Documentation Finished', 'Auto Posted')
            THEN COALESCE(
                STRING_AGG(
                    CASE
                        WHEN Incident_Validation_Rule_Error_Message IS NULL
                          OR Incident_Validation_Rule_Error_Message = ''
                        THEN Incident_Validation_Rule_Name
                        ELSE CAST(Incident_Validation_Rule_Error_Message AS VARCHAR(MAX))
                    END, ', '
                ), '-')
            ELSE '-'
        END AS validation_rule_error
    FROM numbered_ems_rules
    WHERE rn <= 8  -- Limit to top 8 validation rules per incident to avoid error: 'STRING_AGG aggregation result exceeded the limit of 8000 bytes.'
    GROUP BY Fact_Incident_PK, Incident_Status
),


-- ########################################################################################
micah_watchroom AS (

    -- First UNION ALL: MEDICAL section.
    SELECT
        'MED' AS report, -- report type
        Fact_Incident.CreatedOn AS created_on, -- used only for filtering
        Fact_Incident.Incident_Agency_Short_Name AS agency, -- used only for filtering
        '---' As 'crew names', -- TODO: add crew names found in associated ePCR

        -- Status
        Fact_Incident.Incident_Validity_Score AS score,
        -- CASE
        --      WHEN Dim_Incident.Incident_Status = 'Exported To State' THEN 'Finished' -- simplify for end user
        --       -- these have failed state export.  All ePCRs now change status to 'Finished' (TODO: add date of ImageTrend settings change)
        --      WHEN Dim_Incident.Incident_Status = 'Crew Documentation Finished' THEN 'Failed'
        --      ELSE Dim_Incident.Incident_Status -- otherwise, just show status
        -- END AS status,
        CASE
            -- let's make it explicit when the database is in a bad state
            WHEN Dim_Incident.Incident_Status IS NULL OR Dim_Incident.Incident_Status = '' THEN 'ErrorNoData'
            WHEN Dim_Incident.Incident_Status = 'Exported To State' THEN 'Finished'  -- simplify for end user
            -- these have failed state export.  All ePCRs now change status to 'Finished' (TODO: add date of ImageTrend settings change)
            WHEN Dim_Incident.Incident_Status = 'Crew Documentation Finished' THEN 'Failed'
            ELSE Dim_Incident.Incident_Status
        END AS status,

        -- Unique Record
        COALESCE(CONVERT(VARCHAR(255), Fact_Incident.Patient_Age_In_Years), '__') + ' year old' AS unique_record_id,

        -- Incident details
        --Dim_Incident.Incident_Unit_Notified_By_Dispatch_Date_Time AS alarm_time,
        Dim_Incident.[Incident_PSAP_Call_Date_Time] AS alarm_time,
        Dim_Incident_One_To_One.Response_Incident_Number AS RP,
        Dim_Incident.Incident_Initial_CAD_Dispatch_Code AS 'EMD - desc',
        Dim_Response.Response_EMS_Unit_Call_Sign AS 'Responding Units', -- NOTE: be aware of mis-labelling done here (but it works so we ship it!)
        --Dim_Basic.Basic_Apparatus_Call_Sign_List AS 'All Responding Units', -- Full list of apparatus - NOTE: we need this simply to keep the columns consistent between med/fire...
        Dim_Response.Response_EMS_Unit_Call_Sign AS 'All Responding Units', --*shrug* emoji....
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

      --AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHAT%'
      AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'PSR%'
      AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHS%'
    
       -- medical form '3.5.1' rolled out 5/20/2024 for beta test stations and 8/19/2024 for all of PF&R
      AND Fact_Incident.Incident_Form_Number = 118


    UNION ALL -- BOOM BABY!!!

    -- Second UNION ALL: FIRE section.
SELECT
    'FIRE' AS report,
    Fact_Fire.CreatedOn AS created_on,

    Fact_Fire.Agency_Shortname AS agency,
    dar.Apparatus_Personnel_Name_List AS crew_names, -- Individual crew names per apparatus
    Fact_Fire.Basic_Incident_Validity_Score AS score,

    -- CASE
    --      WHEN Dim_Basic.Basic_Incident_Status = 'Crew Documentation Finished' THEN 'Finished'
    --      WHEN Dim_Basic.Basic_Incident_Status = 'Exported To State' THEN 'Finished'
    --      WHEN Dim_Basic.Basic_Incident_Status = 'Crew Edits Complete' THEN 'Finished'
    --      ELSE Dim_Basic.Basic_Incident_Status
    -- END AS status,

    CASE
        -- let's make it explicit when the database is in a bad state
        WHEN Dim_Basic.Basic_Incident_Status IS NULL OR Dim_Basic.Basic_Incident_Status = '' THEN 'ErrorNoData'
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Documentation Finished' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Exported To State' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Edits Complete' THEN 'Finished'
        ELSE Dim_Basic.Basic_Incident_Status
    END AS status,

    'Exposure ' + CONVERT(VARCHAR(255), Dim_Basic.Basic_Exposure) AS unique_record_id,

    Dim_Basic.Basic_Incident_Alarm_Time AS alarm_time,
    Dim_Basic.Basic_Incident_Number AS RP,
    Dim_Fire.Fire_Initial_CAD_Incident_Type_Description AS 'EMD - desc',
    dar.Apparatus_Resource_Vehicle_Call_Sign AS 'Responding Units', -- Individual apparatus
    Dim_Basic.Basic_Apparatus_Call_Sign_List AS 'All Responding Units', -- Full list of apparatus
    Dim_Basic.Basic_Shift_Or_Platoon AS shift,

    CASE
        WHEN COALESCE(Dim_Basic.Basic_Primary_Station_Name, '') = '' THEN '?'
        ELSE Dim_Basic.Basic_Primary_Station_Name
    END AS FMA, -- TODO: '?' means that ImageTrend is unable to determine the FMA - this needs to be fixed as it has been misconfigured since we moved from FIS to ITE

    Dim_Basic.Basic_Incident_Full_Address AS address,
    Dim_Basic.Basic_Authorization_Member_Making_Report_Name AS 'author',
    --Dim_Basic.Basic_Primary_Action_Taken AS 'disposition',
    --dar.Apparatus_Resource_Primary_Action_Taken + ', ' + dar.Apparatus_Resource_Actions_Taken_List AS disposition,
    --ISNULL(dar.Apparatus_Resource_Primary_Action_Taken, '') + ', ' + ISNULL(dar.Apparatus_Resource_Actions_Taken_List, '') AS disposition,
    RTRIM(
        COALESCE(dar.Apparatus_Resource_Primary_Action_Taken, '') + 
        CASE 
            WHEN dar.Apparatus_Resource_Primary_Action_Taken IS NOT NULL AND dar.Apparatus_Resource_Actions_Taken_List IS NOT NULL 
                THEN ', ' 
            ELSE '' 
        END + 
        COALESCE(dar.Apparatus_Resource_Actions_Taken_List, '')
    ) AS disposition,

    Fact_Fire.Basic_Incident_Form_Number AS form_number,

    -- URL link
    Fact_Fire.Incident_ID_Internal AS url_incident,
    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident'
        + CONVERT(VARCHAR(255), Fact_Fire.Incident_ID_Internal)
        + '/Form'
        + CONVERT(VARCHAR(255), Fact_Fire.Basic_Incident_Form_Number) AS link,
    COALESCE(vr.validation_rule_error, 'None') AS 'report validation errors'


FROM [Elite_DWPortland].[DwFire].[Fact_Fire]
INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Fire] ON Fact_Fire.Dim_Fire_FK = Dim_Fire.Dim_Fire_PK
LEFT JOIN fire_validation_rules vr ON Fact_Fire.Fact_Fire_PK = vr.Fact_Fire_PK

JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ApparatusResources] bfar 
    ON Fact_Fire.Fact_Fire_PK = bfar.Fact_Fire_PK

JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] dar 
    ON bfar.Dim_ApparatusResources_PK = dar.Dim_ApparatusResources_PK


WHERE Fact_Fire.CreatedOn >= '2024-08-19'

    AND Fact_Fire.Agency_shortname = 'portlandfi'

    -- NACHO UNITS!
    --AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHAT%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'PSR%'
    -- AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'M%' -- this will exclude MC9 :(
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[M][0-9]%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[B][0-9]%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'LZ%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHS%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'MCCL%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'MS%'

    -- AIRPORT FIRE
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'C8%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'NOPDX%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'NOBOEC%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E80%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'R82%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'INFO%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'RB80%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'VA%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CC%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'D3%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'LO%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'TV%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'TIPF%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'POISON%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'INFFA1%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'EMS%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'FT%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E32%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU33%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'S6%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E61%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU61%'

    --AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU33%' -- ????

    -- GRESHAM UNITS <3
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'C7%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'T71%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E71%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E72%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E73%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E75%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E76%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'R74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'RHB74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'HR71%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'HS81%'

)

SELECT * FROM micah_watchroom;
