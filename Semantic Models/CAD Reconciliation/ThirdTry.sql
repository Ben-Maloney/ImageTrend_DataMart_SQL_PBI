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
    -- , far.[Apparatus_Resource_Vehicle_Call_Sign] AS Fire_Unit_Call_Sign
    , far.[Apparatus_Resource_ID] AS Fire_Apparatus_Resource_ID
    , far.[Basic_Incident_Number] AS Fire_Basic_Incident_Number

    , r.[CAD_Incident_Number] as RP_NUMBER


    , r.[CAD_EMS_Response_Number]

    -- Fact_CAD columns
    , f.[Fact_CAD_PK]

    -- NOTE: These two are the SAME (or appear to be the same!) :)
    , f.[CAD_ID_Internal]
    , dcd.[CAD_ID_Internal] AS Dim_CAD_Dispatch_CAD_ID_Internal  -- Alias to avoid name clash
    -- , de.[CAD_CAD_ID] AS CAD_CAD_ID
    , f.[CreatedOn]

    -- NOTE: THIS IS THE REGULAR EXPRESSION FOR CALL TYPE DETERMINATE
    , dcd.[CAD_EMD_Card_Number]

    , LEFT(dcd.[CAD_EMD_Card_Number], PATINDEX('%[^0-9]%', dcd.[CAD_EMD_Card_Number] + 'A') - 1) as ProQA_CARD

    , d.[CAD_PSAP_Call_Date_Time]
    , d.[CAD_Dispatch_Notified_Date_Time]
    , d.[CAD_Unit_Notified_By_Dispatch_Date_Time]
    , d.[CAD_Unit_Canceled_Date_Time]
    , d.[CAD_Unit_Back_In_Service_Date_Time]
    -- , d.[CAD_Arrived_At_Patient_Date_Time]
    , d.[CAD_Patient_Arrived_At_Destination_Date_Time]
    -- , d.[CAD_Transfer_Of_EMS_Patient_Care_Date_Time]
    , d.[CAD_Unit_Arrived_On_Scene_Date_Time]
    , d.[CAD_Unit_En_Route_Date_Time]
    , d.[CAD_Unit_Left_Scene_Date_Time]
    , d.[CAD_Unit_Back_At_Home_Location_Date_Time]

    , d.[CAD_Response_EMS_Shift]
    , d.[CAD_Response_EMS_Agency_Name]
    , d.[CreatedOn] AS Dim_CAD_CreatedOn


    , d.[CAD_Incident_Unit_Dispatched_CAD_Record_ID] -- NOTE: This one is the HUGE concat'd thing
    , d.[CAD_Incident_Initial_CAD_Dispatch_Code]
    , d.[CAD_Incident_Final_CAD_Dispatch_Code]
    , d.[CAD_Incident_Dispatched_Hospital_Code]


    -- Dim_CAD_Response columns
    -- , r.[Dim_CAD_Response_PK]
    , r.[CAD_Beginning_Odometer_Reading_Of_Responding_Vehicle]
    , r.[CAD_Response_Vehicle_Dispatch_Location]
    , r.[CAD_Response_EMS_Unit_Call_Sign]

    , r.[CAD_Response_EMS_Vehicle_Unit_Number]

    , r.[CAD_Response_EMS_Agency_Name]

    , r.[CreatedOn] AS Dim_CAD_Response_CreatedOn

    -- Dim_CAD_Scene columns
    , s.[Dim_CAD_Scene_PK]
    , s.[CAD_Initial_Responder_Arrived_On_Scene_Date_Time]
    , s.[CAD_Scene_Incident_GPS_Latitude]
    , s.[CAD_Scene_Incident_GPS_Longitude]
    , s.[CAD_Scene_Incident_State_Name]
    , s.[CAD_Scene_Incident_Street_Address]

    , s.[CreatedOn] AS Dim_CAD_Scene_CreatedOn
    , s.[ModifiedOn] AS Dim_CAD_Scene_ModifiedOn


    , dcd.[Dim_CAD_Dispatch_PK]
    , dcd.[Unit_Dispatched_CAD_Record_ID]
    , dcd.[CAD_Complaint_Reported_By_Dispatch]

    , dcd.[CreatedOn] AS Dim_CAD_Dispatch_CreatedOn
    , dcd.[ModifiedOn] AS Dim_CAD_Dispatch_ModifiedOn

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

-- Dim_CAD_Response Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Response] r
    ON f.Dim_CAD_Response_FK = r.Dim_CAD_Response_PK

-- Dim_CAD_Scene Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Scene] s
    ON f.Dim_CAD_Scene_FK = s.Dim_CAD_Scene_PK

-- Dim_CAD_Dispatch Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Dispatch] dcd
    ON f.Dim_CAD_Dispatch_FK = dcd.Dim_CAD_Dispatch_PK

-- Join to Fire ApparatusResources CTE using RP+Time+Unit constructed key
LEFT JOIN FireAR far
    ON far.[Fire_RP_Time_UnitKey] = CONCAT(
        UPPER(LTRIM(RTRIM(r.[CAD_Incident_Number]))),
        '|',
        UPPER(LTRIM(RTRIM(r.[CAD_Response_EMS_Unit_Call_Sign])))
    )


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
