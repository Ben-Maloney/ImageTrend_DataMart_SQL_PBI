-- ePCR Listing: Extract Fact_Incident with RP number, unit, and time dispatched
-- Joins Fact_Incident with Dim_Incident for CAD reconciliation

SELECT
    -- Fact_Incident identifiers
    fi.[Fact_Incident_PK]
    
    -- CAD information
    ,dio.[Response_Incident_Number] AS RP_Number
    ,di.[Incident_Unit_Notified_By_Dispatch_Date_Time] AS Time_Dispatched
    
    -- Unit from Dim_Response
    ,dr.[Response_EMS_Unit_Call_Sign] AS Unit
    
    -- Additional useful fields
    ,di.[Incident_Initial_CAD_Dispatch_Code]
    ,di.[Incident_Final_CAD_Dispatch_Code]
    ,di.[Incident_Complaint_Reported_By_Dispatch]
    ,di.[Incident_Date_Time]
    ,di.[Incident_PSAP_Call_Date_Time]
    ,di.[Incident_Unit_En_Route_Date_Time]
    ,di.[Incident_Unit_Arrived_On_Scene_Date_Time]

    ,fi.[Incident_Agency_Short_Name]
    ,fi.[Incident_Form_Number]



FROM [Elite_DWPortland].[DwEms].[Fact_Incident] fi

LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] di
    ON fi.[Dim_Incident_FK] = di.[Dim_Incident_PK]

LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Response] dr
    ON fi.[Dim_Response_FK] = dr.[Dim_Response_PK]

INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One] dio
    ON fi.[Dim_Incident_One_To_One_PK] = dio.[Dim_Incident_One_To_One_PK]

WHERE fi.[Agency_ID_Internal] = '6dc7ba46-6723-eb11-a95e-001dd8b72424'
    AND dio.[Response_Incident_Number] IS NOT NULL
    AND fi.Incident_Form_Number = 118

ORDER BY fi.[Fact_Incident_PK] DESC