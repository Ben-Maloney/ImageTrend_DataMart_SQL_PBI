/*
------------------------------------------------------------------------------
 CAD Reconciliation (Fire) - Minimal output
------------------------------------------------------------------------------
 Purpose: Return a compact view for reconciliation with four columns:
  - Incident_Type (from CAD)
  - Constructed_RP_Time_Unit ({RP}{YYYYMMDD:HH:MM:SS}{UNIT})
  - Event_Date (date portion of the time used above)
  - RP_Number (from CAD)
  - Unit_Call_Sign (from apparatus resource)
  - Basic_Incident_Primary_Narrative (from NFIRS Basic)
 Sources used (no filters applied):
  - [Elite_DWPortland].[DwFire].[Fact_Fire] as f
  - [Elite_DWPortland].[DwFire].[Dim_Fire_CAD] as cad
  - [Elite_DWPortland].[DwFire].[Dim_Basic] as b
  - [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] as ar
 Notes:
  - The apparatus (UNIT) comes from the first-arriving apparatus via f.FirstApparatusArrived_Dim_ApparatusResources_FK.
  - The time used is COALESCE(ar.Apparatus_Resource_Dispatch_Date_Time, cad.CAD_Basic_Incident_Alarm_Time).
------------------------------------------------------------------------------
*/

SELECT TOP (100)
    -- Incident type
    cad.[CAD_Initial_CAD_Incident_Type_Description] AS Incident_Type,

    -- Constructed {RP}{YYYYMMDD:HH:MM:SS}{UNIT}
    CONCAT(
        cad.[CAD_CAD_ID],
        CASE WHEN COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]) IS NOT NULL
             THEN CONVERT(char(8), COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]), 112)
                  + ':' + CONVERT(char(8), COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]), 108)
             ELSE ''
        END,
        COALESCE(ar.[Apparatus_Resource_Vehicle_Call_Sign], '')
    ) AS Constructed_RP_Time_Unit,

    -- Unit call sign (from apparatus resource)
    ar.[Apparatus_Resource_Vehicle_Call_Sign] AS Unit_Call_Sign,

    -- Date (from the time used above)
    CAST(COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]) AS date) AS Event_Date,

    -- RP number
    cad.[CAD_CAD_ID] AS RP_Number,

    -- Narrative from NFIRS Basic
    b.[Basic_Incident_Primary_Narrative] AS Basic_Incident_Primary_Narrative

FROM [Elite_DWPortland].[DwFire].[Fact_Fire] AS f
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Fire_CAD] AS cad
    ON f.[CAD_ID_FK] = cad.[Dim_Fire_CAD_PK]
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] AS b
    ON f.[Dim_Basic_FK] = b.[Dim_Basic_PK]
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] AS ar
    ON f.[FirstApparatusArrived_Dim_ApparatusResources_FK] = ar.[Dim_ApparatusResources_PK]

ORDER BY cad.[Dim_Fire_CAD_PK] DESC

