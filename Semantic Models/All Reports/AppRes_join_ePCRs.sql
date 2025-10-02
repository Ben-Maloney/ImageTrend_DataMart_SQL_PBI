-- ePCR Listing: Extract Fact_Incident with RP number, unit, and time dispatched
-- Joins Fact_Incident with Dim_Incident for CAD reconciliation

WITH ePCR_Records AS (
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
    AND di.Incident_Date_Time > '2025-01-01'
)







-- THE BELOW SHOULD TAKE THE CTE ABOVE AND DO A MULTI-PART JOIN TO GET RP NUMBER AND UNIT TO ALIGN.  THEN, SOME UNIT RESPONCES WILL SHOW THE EPCR THAT WAS WRITTEN FOR THAT RUN

SELECT
	  Dim_Basic.[Basic_Incident_Number]

	   ,[Dim_ApparatusResources_PK]
    ,[Apparatus_ID_Internal]

	  -- ePCR fields from CTE
    ,[Apparatus_Resource_ID]
    -- ,epcr.[unit] AS ePCR_Unit
	  -- ,epcr.[Time_Dispatched] AS ePCR_DP
	  ,epcr.[Fact_Incident_PK]
	  ,epcr.[Incident_Initial_CAD_Dispatch_Code] AS ePCR_Initial_Dispatch_Code
	  ,epcr.[Incident_Form_Number] AS ePCR_Form_Number
    




    ,[Apparatus_Resource_Dispatch_Date_Time]
    ,[Appratus_Resource_Enroute_Date_Time]
    ,[Apparatus_Resource_Staging_Date_Time]
    ,[Apparatus_Resource_Arrival_Date_Time]
    ,[Apparatus_Resource_Clear_Date_Time]
    ,[Apparatus_Resource_In_Service_Date_Time]
    ,[Apparatus_Resource_In_Quarters_Date_Time]

    ,[Apparatus_Resource_Leave_Scene_Date_Time]
    ,[Apparatus_Resource_Arrival_At_Hospital_Time]
    ,[Apparatus_Resource_Primary_Action_Taken]
    ,[Apparatus_Resource_Primary_Action_Taken_Code]
    ,[Apparatus_Resource_Primary_Action_Taken_Code_And_Description]
    ,[Apparatus_Resource_Arrival_Sequence_Number_By_Overall_Incident]
    ,[Apparatus_Resource_Narrative]
    -- ,[Apparatus_Resource_Dispatch_Location]
    
    , DATEDIFF(
        SECOND,
        [Apparatus_Resource_Dispatch_Date_Time],
        GREATEST(
            [Apparatus_Resource_Dispatch_Date_Time],
            [Appratus_Resource_Enroute_Date_Time],
            [Apparatus_Resource_Arrival_Date_Time],
            [Apparatus_Resource_Clear_Date_Time],
            [Apparatus_Resource_Leave_Scene_Date_Time],

            [Apparatus_Resource_In_Service_Date_Time],
            [Apparatus_Resource_In_Quarters_Date_Time]
        )
    ) as Total_Seconds

    , DATEDIFF(
        SECOND,
        [Apparatus_Resource_Arrival_Date_Time],
        GREATEST(
            [Apparatus_Resource_Arrival_Date_Time],
            [Apparatus_Resource_Clear_Date_Time],
            [Apparatus_Resource_Leave_Scene_Date_Time],

            [Apparatus_Resource_In_Service_Date_Time],
            [Apparatus_Resource_In_Quarters_Date_Time]
        )
    ) as Total_OnScene_Seconds

	  -- Fact_Fire fields
	  ,Fact_Fire.[Fact_Fire_PK]
	  ,Fact_Fire.[Agency_shortname]
	  ,Fact_Fire.[Basic_Incident_Form_Number]


  FROM [Elite_DWPortland].[DwFire].[Dim_ApparatusResources]
  
  LEFT JOIN [Elite_DWPortland].[DwFire].[Fact_Fire] 
	ON [Dim_ApparatusResources].[Incident_ID_Internal] = [Fact_Fire].[Incident_ID_Internal]
  
  LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] 
	ON [Fact_Fire].[Dim_Basic_FK] = [Dim_Basic].[Dim_Basic_PK]

  LEFT JOIN ePCR_Records epcr
    ON Dim_Basic.[Basic_Incident_Number] = epcr.RP_Number
    AND [Dim_ApparatusResources].[Apparatus_Resource_ID] = epcr.Unit

WHERE Apparatus_Resource_Dispatch_Date_Time is NOT NULL
    AND Fact_Fire.[Agency_shortname] = 'portlandfi'
    AND Apparatus_Resource_Dispatch_Date_Time > '2025-01-01'
