-- This expirimental query attempts to reverse-engineer the behaviour of the Dim_EMS_CAD table and Dim_Fire_CAD table

-- My hypothesis is that they can be joined using CAD_Incident_ID_Internal

WITH f AS (
    SELECT *
    FROM [Elite_DWPortland].[DwFire].[Dim_Fire_CAD]
    WHERE [CAD_Basic_Incident_Agency_ID_Internal] = '6dc7ba46-6723-eb11-a95e-001dd8b72424'
),
e AS (
    SELECT *
    FROM [Elite_DWPortland].[DwEms].[Dim_EMS_CAD]
    WHERE [CAD_EMS_Agency_Name] = 'Portland Fire & Rescue - EMS'
)
SELECT TOP (500)
    -- Keys
    f.[Dim_Fire_CAD_PK],
    e.[Dim_CAD_PK]                                 AS [Dim_EMS_CAD_PK],
    -- RP Number fields (should be equivalent)
    f.[CAD_CAD_ID]                                 AS [Fire_RP_Number],
    e.[CAD_EMS_Response_Number]                    AS [EMS_RP_Number],
    -- Secondary CAD IDs
    f.[CAD_CAD_ID]                                 AS [Fire_CAD_ID],
    e.[CAD_CAD_ID]                                 AS [EMS_CAD_ID],
    -- Other possible link fields (for reference only)
    f.[CAD_Incident_ID_Internal]                   AS [Fire_CAD_Incident_ID_Internal],
    e.[CAD_Incident_ID_Internal]                   AS [EMS_CAD_Incident_ID_Internal],
    f.[Incident_Incident_ID_Internal]              AS [Fire_Incident_Incident_ID_Internal],
    e.[Incident_Incident_ID_Internal]              AS [EMS_Incident_Incident_ID_Internal],
    -- Diagnostics: normalized join keys
    UPPER(REPLACE(REPLACE(LTRIM(RTRIM(f.[CAD_CAD_ID])),'-',''),' ',''))   AS [Fire_RP_norm],
    UPPER(REPLACE(REPLACE(LTRIM(RTRIM(e.[CAD_EMS_Response_Number])),'-',''),' ','')) AS [EMS_RP_norm],
    -- Useful data points
    f.[CAD_Basic_Incident_Final_CAD_Dispatch_Code] AS [Fire_Final_Dispatch_Code],
    e.[CAD_Incident_Initial_CAD_Dispatch_Code]     AS [EMS_Initial_Dispatch_Code],
    f.[CAD_Basic_Incident_Date]                    AS [Fire_Incident_Date],
    e.[CAD_PSAP_Call_Date_Time]                    AS [EMS_PSAP_Call_Date_Time],
    e.[CAD_Agency_ID]                              AS [EMS_CAD_Agency_ID],
    -- Match status
    CASE 
      WHEN f.[Dim_Fire_CAD_PK] IS NOT NULL AND e.[Dim_CAD_PK] IS NOT NULL THEN 'MATCH'
      WHEN f.[Dim_Fire_CAD_PK] IS NOT NULL AND e.[Dim_CAD_PK] IS NULL THEN 'FIRE_ONLY'
      WHEN f.[Dim_Fire_CAD_PK] IS NULL AND e.[Dim_CAD_PK] IS NOT NULL THEN 'EMS_ONLY'
    END AS [MatchStatus]
FROM f
FULL OUTER JOIN e
  ON UPPER(REPLACE(REPLACE(LTRIM(RTRIM(e.[CAD_EMS_Response_Number])),'-',''),' ',''))
     = UPPER(REPLACE(REPLACE(LTRIM(RTRIM(f.[CAD_CAD_ID])),'-',''),' ',''))


-- NOTE: I DO NOT KNOW HOW TO HANDLE THESE NON-MATCHES... MORE RESEARCH NEEDS TO BE DONE
-- -- Show only UNMATCHED rows (can't filter on alias MatchStatus in same SELECT)
-- WHERE (f.[Dim_Fire_CAD_PK] IS NULL OR e.[Dim_CAD_PK] IS NULL)

ORDER BY COALESCE(f.[Dim_Fire_CAD_PK], -1) DESC, COALESCE(e.[Dim_CAD_PK], -1) DESC;

-- KEEP THESE COMMENTS FOR REFERENCE
-- DOESN'T WORK
-- INNER JOIN [Elite_DWPortland].[DwEms].[Dim_EMS_CAD] AS e
--     ON e.[CAD_Incident_ID_Internal] = f.[CAD_Incident_ID_Internal]

-- DOESN'T WORK
-- INNER JOIN [Elite_DWPortland].[DwEms].[Dim_EMS_CAD] AS e
--     ON e.[Incident_Incident_ID_Internal] = f.[Incident_Incident_ID_Internal]

