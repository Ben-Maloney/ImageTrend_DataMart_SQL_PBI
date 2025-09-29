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
 Sources used (minimal filters applied for data quality):
  - [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] as ar
  - [Elite_DWPortland].[DwFire].[Dim_Basic] as b
 Notes:
  - We operate at the unit-response grain using Dim_ApparatusResources as ground truth.
  - The time used is ar.Apparatus_Resource_Dispatch_Date_Time (non-null enforced below).
------------------------------------------------------------------------------
*/

SELECT TOP (1000)
    -- Incident type (from NFIRS Basic)
    b.[Basic_EFD_Card_Number] AS Incident_Type,

    -- Constructed {BasicIncidentNumber}{YYYYMMDD:HH:MM:SS}{Apparatus_ID}
    CONCAT(
        b.[Basic_Incident_Number],
        CONVERT(char(8), ar.[Apparatus_Resource_Dispatch_Date_Time], 112)
            + ':' + CONVERT(char(8), ar.[Apparatus_Resource_Dispatch_Date_Time], 108),
        ar.[Apparatus_Resource_ID]
    ) AS Constructed_Incident_Time_UnitID,

    -- Unit call sign (from apparatus resource)
    ar.[Apparatus_Resource_Vehicle_Call_Sign] AS Unit_Call_Sign,

    -- Date (from the time used above)
    CAST(ar.[Apparatus_Resource_Dispatch_Date_Time] AS date) AS Event_Date,

    -- Incident number (from NFIRS Basic)
    b.[Basic_Incident_Number] AS Incident_Number,
    b.[Basic_Incident_Primary_Narrative] AS Basic_Incident_Primary_Narrative,
    ar.[Apparatus_Resource_Narrative] AS Apparatus_Resource_Narrative,
    b.[Basic_Incident_Type] as Incident_Type,
    b.[Basic_Incident_Type_Code] as Incident_Type_Code

FROM [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] AS ar
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] AS b
    ON ar.[Incident_ID_Internal] = b.[Incident_ID_Internal]

WHERE
    b.Basic_Agency_ID_Internal = '6dc7ba46-6723-eb11-a95e-001dd8b72424'
    -- AND ar.[Apparatus_Resource_Dispatch_Date_Time] IS NOT NULL
    -- AND ar.[Apparatus_Resource_ID] IS NULL
    -- AND b.[Basic_Incident_Number] IS NOT NULL
    -- AND ar.[Apparatus_Resource_Vehicle_Call_Sign] IS NULL
    -- AND LTRIM(RTRIM(ar.[Apparatus_Resource_Vehicle_Call_Sign])) <> ''

ORDER BY ar.[Apparatus_Resource_Dispatch_Date_Time] DESC, ar.[Dim_ApparatusResources_PK] DESC
