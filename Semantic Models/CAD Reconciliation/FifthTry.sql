/*
#####################################################################
 CAD Reconciliation - Direct Multi-Column Join Approach
 Starting small: Join on RP Number + Unit Call Sign + Dispatch Time
#####################################################################
*/

-- Build Fire side with RP number, Unit, and Dispatch Time
WITH FireData AS (
    SELECT
        ar.[Dim_ApparatusResources_PK],
        ar.[Apparatus_Resource_ID],
        ar.[Apparatus_Resource_Vehicle_Call_Sign],
        ar.[Apparatus_Resource_Dispatch_Date_Time],
        b.[Basic_Incident_Number] AS Fire_RP_Number,
        b.[Incident_ID_Internal],
        ff.[Fact_Fire_PK]
        
    FROM [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] ar
    
    LEFT JOIN [Elite_DWPortland].[DwFire].[Fact_Fire] ff
        ON ar.[Incident_ID_Internal] = ff.[Incident_ID_Internal]
    
    LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] b
        ON ar.[Incident_ID_Internal] = b.[Incident_ID_Internal]
    
    WHERE b.[Basic_Agency_ID_Internal] = '6dc7ba46-6723-eb11-a95e-001dd8b72424'
        AND b.[Basic_Incident_Number] IS NOT NULL
)

SELECT
    -- EMS Side (from CAD)
    r.[CAD_Incident_Number] AS EMS_RP_Number,
    fire.[Fire_RP_Number],

    r.[CAD_Response_EMS_Unit_Call_Sign] AS EMS_Unit,
    fire.[Apparatus_Resource_Vehicle_Call_Sign] AS Fire_Unit,

    d.[CAD_Unit_Notified_By_Dispatch_Date_Time] AS EMS_Dispatch_Time,
    fire.[Apparatus_Resource_Dispatch_Date_Time] AS Fire_Dispatch_Time,
    
    -- Additional Context
    f.[Fact_CAD_PK],
    fire.[Dim_ApparatusResources_PK],
    d.Dim_CAD_PK
    -- fire.[Fact_Fire_PK],
    -- d.[CAD_Response_EMS_Agency_Name]

FROM [Elite_DWPortland].[DwEms].[Fact_CAD] f

-- Join EMS CAD tables
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD] d
    ON f.Dim_CAD_FK = d.Dim_CAD_PK

LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Response] r
    ON f.Dim_CAD_Response_FK = r.Dim_CAD_Response_PK

-- Multi-column join to Fire data: RP + Unit + Dispatch Time
LEFT JOIN FireData fire
    ON UPPER(LTRIM(RTRIM(fire.[Fire_RP_Number]))) = UPPER(LTRIM(RTRIM(r.[CAD_Incident_Number])))
    AND UPPER(LTRIM(RTRIM(fire.[Apparatus_Resource_Vehicle_Call_Sign]))) = UPPER(LTRIM(RTRIM(r.[CAD_Response_EMS_Unit_Call_Sign])))
    -- AND fire.[Apparatus_Resource_Dispatch_Date_Time] = d.[CAD_Unit_Notified_By_Dispatch_Date_Time]

/*
#####################################################################
 FILTERS
#####################################################################
*/
WHERE
    d.CAD_Response_EMS_Agency_Name LIKE 'Portland%'
    AND d.[CAD_Unit_Notified_By_Dispatch_Date_Time] >= '2025-01-01'
    AND r.[CAD_Incident_Number] IS NOT NULL

ORDER BY f.Fact_CAD_PK DESC
