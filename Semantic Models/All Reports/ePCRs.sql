-- This query joins Fact_Incident with Dim_Incident and Dim_Response to get the ePCR listing
-- It also joins Dim_Incident_One_To_One to get the RP number
-- We can use Fact_Incident_PK to join with the ApparatusResponse table to get the apparatus dispatched to the incident
-- This way we can figure out which unit responses resulted in an ePCR being written


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

    -- Narrative
    ,dn.[Narrative] AS ePCR_Narrative
    
    ,fi.[Incident_Transaction_GUID_Internal]

    , 'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/EmsRunForm#/Incident'
      + CONVERT(VARCHAR(255), fi.Incident_Transaction_GUID_Internal)
      + '/Form'
      + CONVERT(VARCHAR(255), fi.Incident_Form_Number) AS link

FROM [Elite_DWPortland].[DwEms].[Fact_Incident] fi

LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] di
    ON fi.[Dim_Incident_FK] = di.[Dim_Incident_PK]

LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Response] dr
    ON fi.[Dim_Response_FK] = dr.[Dim_Response_PK]

LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Narrative] dn
    ON fi.[Dim_Narrative_FK] = dn.[Dim_Narrative_PK]

INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One] dio
    ON fi.[Dim_Incident_One_To_One_PK] = dio.[Dim_Incident_One_To_One_PK]

WHERE fi.[Agency_ID_Internal] = '6dc7ba46-6723-eb11-a95e-001dd8b72424'
    AND dio.[Response_Incident_Number] IS NOT NULL
    AND fi.Incident_Form_Number = 118
    AND di.Incident_Date_Time > '2025-01-01'