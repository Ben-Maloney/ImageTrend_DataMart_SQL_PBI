WITH FireAR AS (
  SELECT
    ar.[Dim_ApparatusResources_PK],
    b.[Basic_Incident_Number],
    ar.[Apparatus_Resource_ID],
    ar.[Apparatus_Resource_Vehicle_Call_Sign],
    ar.[Apparatus_Resource_Dispatch_Date_Time],
    CAST(ar.[Apparatus_Resource_Dispatch_Date_Time] AS date) AS Fire_Event_Date,
    b.[Basic_Incident_Number] AS Fire_RP,
    UPPER(LTRIM(RTRIM(b.[Basic_Incident_Number]))) AS Fire_RP_Norm,
    UPPER(LTRIM(RTRIM(ar.[Apparatus_Resource_Vehicle_Call_Sign]))) AS Fire_Unit_Norm,

    -- CONCAT(
    --   UPPER(LTRIM(RTRIM(b.[Basic_Incident_Number]))),
    --   '|',
    --   UPPER(LTRIM(RTRIM(ar.[Apparatus_Resource_Vehicle_Call_Sign])))
    -- ) AS Fire_RP_UnitKey,

    CONCAT(
        UPPER(LTRIM(RTRIM(b.[Basic_Incident_Number]))),
        '|',
        UPPER(LTRIM(RTRIM(ar.[Apparatus_Resource_Vehicle_Call_Sign])))
        ) AS Fire_RP_Time_UnitKey


  FROM [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] AS ar
  LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] AS b
    ON ar.[Incident_ID_Internal] = b.[Incident_ID_Internal]
  WHERE b.[Basic_Agency_ID_Internal] = '6dc7ba46-6723-eb11-a95e-001dd8b72424'
    AND b.[Basic_Incident_Number] IS NOT NULL
)



  SELECT
    --EMS/Fire RP+Unit keys for reconciliation
    CONCAT(
        UPPER(LTRIM(RTRIM(r.[CAD_Incident_Number]))),
        '|',
        UPPER(LTRIM(RTRIM(r.[CAD_Response_EMS_Unit_Call_Sign])))
        ) AS EMS_RP_Time_UnitKey

    , far.[Fire_RP_Time_UnitKey] AS Fire_RP_Time_UnitKey
    , CAST(COALESCE(d.[CAD_Unit_Notified_By_Dispatch_Date_Time], d.[CAD_Unit_En_Route_Date_Time], d.[CAD_Unit_Arrived_On_Scene_Date_Time]) AS date) AS EMS_Event_Date
    , far.[Fire_Event_Date]

    , far.[Apparatus_Resource_ID] AS Fire_Apparatus_Resource_ID
    , far.[Basic_Incident_Number] AS Fire_Basic_Incident_Number

    , r.[CAD_Incident_Number] as RP_NUMBER
    , r.[CAD_EMS_Response_Number]

    -- Fact_CAD columns
    , f.[Fact_CAD_PK]
    , f.[CAD_ID_Internal]
    , d.[CAD_Unit_Notified_By_Dispatch_Date_Time]
    , d.[CAD_Incident_Unit_Dispatched_CAD_Record_ID] -- NOTE: This one is the HUGE concat'd thing

    , DATEDIFF(
        SECOND,
        d.[CAD_Unit_Notified_By_Dispatch_Date_Time],
        GREATEST(
            d.[CAD_Unit_Notified_By_Dispatch_Date_Time],
            d.[CAD_Unit_En_Route_Date_Time],
            d.[CAD_Unit_Arrived_On_Scene_Date_Time],
            d.[CAD_Unit_Canceled_Date_Time],
            d.[CAD_Unit_Left_Scene_Date_Time],

            d.[CAD_Unit_Back_In_Service_Date_Time],
            d.[CAD_Unit_Back_At_Home_Location_Date_Time]
        )
    ) as Total_Seconds

    , DATEDIFF(
        SECOND,
        d.[CAD_Unit_Arrived_On_Scene_Date_Time],
        GREATEST(
            d.[CAD_Unit_Arrived_On_Scene_Date_Time],
            d.[CAD_Unit_Canceled_Date_Time],
            d.[CAD_Unit_Left_Scene_Date_Time],

            d.[CAD_Unit_Back_In_Service_Date_Time],
            d.[CAD_Unit_Back_At_Home_Location_Date_Time]
        )
    ) as Total_OnScene_Seconds


FROM [Elite_DWPortland].[DwEms].[Fact_CAD] f

-- Dim_CAD Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD] d
    ON f.Dim_CAD_FK = d.Dim_CAD_PK


/*
#####################################################################
 FILTERS
#####################################################################
*/
WHERE
    d.CAD_Response_EMS_Agency_Name LIKE 'Portland%'
    AND d.[CAD_Unit_Notified_By_Dispatch_Date_Time] >= '2025-01-01'
    AND r.[CAD_Incident_Number] IS NOT NULL


--NOTE: only for testing
ORDER BY f.Fact_CAD_PK DESC
