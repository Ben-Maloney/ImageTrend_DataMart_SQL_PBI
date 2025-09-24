/*
------------------------------------------------------------------------------
 CAD Reconciliation (Fire) - Test query
------------------------------------------------------------------------------
 Purpose: Compare key identifiers and timestamps between Fire Fact and CAD Dim.
 Sources:
 - [Elite_DWPortland].[DwFire].[Fact_Fire] as f
 - [Elite_DWPortland].[DwFire].[Dim_Fire_CAD] as cad
 - [Elite_DWPortland].[DwFire].[Dim_Basic] as b
 - [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] as ar
 Filters:
 - Agency_shortname = 'portlandfi'
 - CAD_Basic_Incident_Agency_Name = 'Portland Fire & Rescue - EMS'
 - CreatedOn window >= '2025-01-01' (adjust as needed)
------------------------------------------------------------------------------
*/

SELECT TOP (10000)
    -- Keys
    f.[Fact_Fire_PK],
    f.[Agency_shortname],
    f.[Dim_Basic_FK],
    f.[CAD_ID_FK],
    f.[CAD_Incident_ID_Internal] AS Fact_CAD_Incident_ID_Internal,

    cad.[Dim_Fire_CAD_PK] AS Dim_Fire_CAD_PK,
    cad.[CAD_CAD_ID] AS RP_Number,
    cad.[CAD_Incident_ID_Internal] AS DimCAD_CAD_Incident_ID_Internal,

    b.[Dim_Basic_PK] AS Dim_Basic_PK,
    b.[Basic_Incident_Number] AS NFIRS_Incident_Number,

    -- Dispatch codes / types
    cad.[CAD_Initial_CAD_Incident_Type_Description],
    cad.[CAD_Basic_Incident_Final_CAD_Dispatch_Code],
    b.[Basic_Final_NFIRS_Code],
    b.[Basic_Final_NFIRS_Description],

    -- Times (NFIRS Basic)
    b.[Basic_Incident_PSAP_Date_Time],
    b.[Basic_Incident_Alarm_Time],
    b.[Basic_Incident_First_Unit_Arrived_Date_Time],
    b.[Basic_Incident_Last_Unit_Arrived_Date_Time],
    b.[Basic_Incident_Last_Unit_Cleared_Date_Time],

    -- Times (CAD)
    cad.[CAD_Basic_Incident_PSAP_Date_Time],
    cad.[CAD_Basic_Incident_Alarm_Time],
    cad.[CAD_Basic_Incident_Arrival_Date_Time],
    cad.[CAD_Basic_Incident_Last_Unit_Cleared_Date_Time],

    -- First arrived apparatus details
    ar.[Apparatus_Resource_Vehicle_Call_Sign] AS First_Arrived_Call_Sign,
    ar.[Apparatus_Resource_Type] AS First_Arrived_Apparatus_Type,
    ar.[Apparatus_Resource_Arrival_Sequence_Number_By_Overall_Incident] AS First_Arrived_Sequence,
    ar.[Apparatus_Resource_Arrival_Date_Time] AS First_Arrived_Arrival_Date_Time,
    ar.[Apparatus_Resource_ID] AS First_Arrived_Apparatus_ID,

    -- Dispatch/Notify time to use for key
    COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]) AS Notified_By_Dispatch_Date_Time,

    -- Composite reconciliation key in the format: {RP}{YYYYMMDD:HH:MM:SS}{CallSign}
    CONCAT(
        COALESCE(cad.[CAD_CAD_ID], ''),
        CASE WHEN COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]) IS NOT NULL
             THEN CONVERT(char(8), COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]), 112)
                  + ':' + CONVERT(char(8), COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]), 108)
             ELSE ''
        END,
        COALESCE(ar.[Apparatus_Resource_Vehicle_Call_Sign], '')
    ) AS Reconciliation_Key,

    -- Alternate key using Basic Incident Number + time + Apparatus_ID
    CONCAT(
        COALESCE(b.[Basic_Incident_Number], ''),
        CASE WHEN COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]) IS NOT NULL
             THEN CONVERT(char(8), COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]), 112)
                  + ':' + CONVERT(char(8), COALESCE(ar.[Apparatus_Resource_Dispatch_Date_Time], cad.[CAD_Basic_Incident_Alarm_Time]), 108)
             ELSE ''
        END,
        COALESCE(ar.[Apparatus_Resource_ID], '')
    ) AS Reconciliation_Key_Basic,

    -- -- Deltas
    -- DATEDIFF(second, b.[Basic_Incident_PSAP_Date_Time], cad.[CAD_Basic_Incident_PSAP_Date_Time]) AS PSAP_Time_Delta_Sec,
    -- DATEDIFF(second, b.[Basic_Incident_First_Unit_Arrived_Date_Time], cad.[CAD_Basic_Incident_Arrival_Date_Time]) AS First_Arrival_Time_Delta_Sec,

    -- Audit
    f.[CreatedOn] AS Fact_CreatedOn,
    cad.[CreatedOn] AS DimCAD_CreatedOn,
    b.[CreatedOn] AS DimBasic_CreatedOn

FROM [Elite_DWPortland].[DwFire].[Fact_Fire] AS f
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Fire_CAD] AS cad
    ON f.[CAD_ID_FK] = cad.[Dim_Fire_CAD_PK]
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] AS b
    ON f.[Dim_Basic_FK] = b.[Dim_Basic_PK]
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] AS ar
    ON f.[FirstApparatusArrived_Dim_ApparatusResources_FK] = ar.[Dim_ApparatusResources_PK]

WHERE
    f.[Agency_shortname] = 'portlandfi'
    AND cad.[CAD_Basic_Incident_Agency_Name] = 'Portland Fire & Rescue - EMS'
    AND f.[CreatedOn] >= '2025-01-01'
    AND cad.[CreatedOn] >= '2025-01-01'

-- Helpful sort while testing
ORDER BY f.[Fact_Fire_PK] DESC;

/*
This module should join in Fact_Fire, Apparatus Resource and Dim Basic.

The goal is to create a new column with a specific format.

We need the Dim_Basic Incident number concatenated with the "notified by dispatch time" then the Apparatus_ID

The format should be: 
RP25-9120820250813:09:01:27E19

*/