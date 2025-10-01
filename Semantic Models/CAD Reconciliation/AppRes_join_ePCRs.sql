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
)







-- THE BELOW SHOULD TAKE THE CTE ABOVE AND DO A MULTI-PART JOIN TO GET RP NUMBER AND UNIT TO ALIGN.  THEN, SOME UNIT RESPONCES WILL SHOW THE EPCR THAT WAS WRITTEN FOR THAT RUN

SELECT TOP (1000) 
	  Dim_Basic.[Basic_Incident_Number] as RP
      ,[Apparatus_Resource_Dispatch_Date_Time] as DP
	  ,epcr.[Time_Dispatched] AS ePCR_DP
      -- ,[Apparatus_Resource_Vehicle_Call_Sign] as unit
      ,[Apparatus_Resource_ID] as unit
      ,epcr.[unit] AS ePCR_Unit
  
	   , [Dim_ApparatusResources_PK]
      ,[Apparatus_ID_Internal]
	  -- ePCR fields from CTE
	  ,epcr.[Fact_Incident_PK]
	  ,epcr.[Incident_Initial_CAD_Dispatch_Code] AS ePCR_Initial_Dispatch_Code
	--   ,epcr.[Incident_Final_CAD_Dispatch_Code] AS ePCR_Final_Dis/patch_Code
	--   ,epcr.[Incident_Complaint_Reported_By_Dispatch] AS ePCR_Complaint
	--   ,epcr.[Incident_Date_Time] AS ePCR_Incident_DateTime
	--   ,epcr.[Incident_PSAP_Call_Date_Time] AS ePCR_PSAP_Call_DateTime
	--   ,epcr.[Incident_Unit_En_Route_Date_Time] AS ePCR_EnRoute_DateTime
	--   ,epcr.[Incident_Unit_Arrived_On_Scene_Date_Time] AS ePCR_Arrived_DateTime
	  ,epcr.[Incident_Form_Number] AS ePCR_Form_Number
    




      -- ,[Incident_ID_Internal]
      -- ,[Apparatus_Personnel_ID_List]
      -- ,[Apparatus_Personnel_Name_List]
      -- ,[Apparatus_Resource_Actions_Taken_1]
      -- ,[Apparatus_Resource_Actions_Taken_2]
      -- ,[Apparatus_Resource_Actions_Taken_3]
      -- ,[Apparatus_Resource_Actions_Taken_4]
      -- ,[Apparatus_Resource_Actions_Taken_Code_1]
      -- ,[Apparatus_Resource_Actions_Taken_Code_2]
      -- ,[Apparatus_Resource_Actions_Taken_Code_3]
      -- ,[Apparatus_Resource_Actions_Taken_Code_4]
      -- ,[Apparatus_Resource_Actions_Taken_Code_And_Description_1]
      -- ,[Apparatus_Resource_Actions_Taken_Code_And_Description_2]
      -- ,[Apparatus_Resource_Actions_Taken_Code_And_Description_3]
      -- ,[Apparatus_Resource_Actions_Taken_Code_And_Description_4]
      -- ,[Apparatus_Resource_Actions_Taken_Code_And_Description_List]
      -- ,[Apparatus_Resource_Actions_Taken_Code_List]
      -- ,[Apparatus_Resource_Actions_Taken_List]
      ,[Apparatus_Resource_Arrival_Date_Time]
        -- ,[Apparatus_Resource_Arrived_To_Cleared_In_HHMMSS]
        -- ,[Apparatus_Resource_Arrived_To_Cleared_In_Minutes]
        -- ,[Apparatus_Resource_Arrived_To_Cleared_In_Seconds]
        -- ,[Apparatus_Resource_Arrived_To_In_Service_In_HHMMSS]
        -- ,[Apparatus_Resource_Arrived_To_In_Service_In_Minutes]
        -- ,[Apparatus_Resource_Arrived_To_In_Service_In_Seconds]
      ,[Apparatus_Resource_Clear_Date_Time]
        -- ,[Apparatus_Resource_Cleared_To_In_Service_In_HHMMSS]
        -- ,[Apparatus_Resource_Cleared_To_In_Service_In_Minutes]
        -- ,[Apparatus_Resource_Cleared_To_In_Service_In_Seconds]
        -- ,[Apparatus_Resource_Dispatch_To_Arrival_In_HHMMSS]
        -- ,[Apparatus_Resource_Dispatch_To_Arrival_In_Minutes]
        -- ,[Apparatus_Resource_Dispatch_To_Arrival_In_Seconds]
        -- ,[Apparatus_Resource_Dispatch_To_Enroute_In_HHMMSS]
        -- ,[Apparatus_Resource_Dispatch_To_Enroute_In_Minutes]
        -- ,[Apparatus_Resource_Dispatch_To_Enroute_In_Seconds]
        -- ,[Apparatus_Resource_Dispatch_To_In_Service_In_HHMMSS]
        -- ,[Apparatus_Resource_Dispatch_To_In_Service_In_Minutes]
        -- ,[Apparatus_Resource_Dispatch_To_In_Service_In_Seconds]
        -- ,[Apparatus_Resource_Enroute_To_Arrived_In_HHMMSS]
        -- ,[Apparatus_Resource_Enroute_To_Arrived_In_Minutes]
        -- ,[Apparatus_Resource_Enroute_To_Arrived_In_Seconds]
        -- ,[Apparatus_Resource_Enroute_To_In_Service_In_HHMMSS]
        -- ,[Apparatus_Resource_Enroute_To_In_Service_In_Minutes]
        -- ,[Apparatus_Resource_Enroute_To_In_Service_In_Seconds]
      ,[Apparatus_Resource_In_Service_Date_Time]
        -- ,[Apparatus_Resource_Number_Of_People]
        -- ,[Apparatus_Resource_Response_Mode_To_Scene]
        -- ,[Apparatus_Resource_Sent_Flag]
        -- ,[Apparatus_Resource_Type]
        -- ,[Apparatus_Resource_Type_Category]
        -- ,[Apparatus_Resource_Type_Code]
        -- ,[Apparatus_Resource_Type_Code_And_Description]
        -- ,[Apparatus_Resource_Use]
        -- ,[Apparatus_Resource_Use_Code]
        -- ,[Apparatus_Resource_Use_Code_And_Description]
      ,[Appratus_Resource_Enroute_Date_Time]
      ,[Apparatus_Resource_Staging_Date_Time]
      ,[Apparatus_Resource_Leave_Scene_Date_Time]
      ,[Apparatus_Resource_Arrival_At_Hospital_Time]
      ,[Apparatus_Resource_In_Quarters_Date_Time]
      -- ,[Apparatus_Resource_Dispatch_to_Staging_in_HHMMSS]
      -- ,[Apparatus_Resource_Dispatch_to_Left_Scene_in_HHMMSS]
      -- ,[Apparatus_Resource_Dispatch_to_Cleared_in_HHMMSS]
      -- ,[Apparatus_Resource_Dispatch_to_Arrived_at_Hospital_in_HHMMSS]
      -- ,[Apparatus_Resource_Dispatch_to_In_Quarters_in_HHMMSS]
      -- ,[Apparatus_Resource_Enroute_to_Staging_in_HHMMSS]
      -- ,[Apparatus_Resource_Enroute_to_Left_Scene_in_HHMMSS]
      -- ,[Apparatus_Resource_Enroute_to_Arrived_at_Hospital_in_HHMMSS]
      -- ,[Apparatus_Resource_Enroute_to_Cleared_at_Hospital_in_HHMMSS]
      -- ,[Apparatus_Resource_Enroute_to_In_Quarters_in_HHMMSS]
      -- ,[Apparatus_Resource_Staging_to_Arrived_at_Scene_in_HHMMSS]
      -- ,[Apparatus_Resource_Staging_to_Left_Scene_in_HHMMSS]
      -- ,[Apparatus_Resource_Staging_to_Arrived_at_Hospital_in_HHMMSS]
      -- ,[Apparatus_Resource_Staging_to_Cleared_in_HHMMSS]
      -- ,[Apparatus_Resource_Staging_to_In_Service_in_HHMMSS]
      -- ,[Apparatus_Resource_Staging_to_In_Quarters_in_HHMMSS]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_Left_Scene_in_HHMMSS]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_Arrived_at_Hospital_in_HHMMSS]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_In_Quarters_in_HHMMSS]
      -- ,[Apparatus_Resource_Left_Scene_to_Arrived_at_Hospital_in_HHMMSS]
      -- ,[Apparatus_Resource_Left_Scene_to_Cleared_in_HHMMSS]
      -- ,[Apparatus_Resource_Left_Scene_to_In_Service_in_HHMMSS]
      -- ,[Apparatus_Resource_Left_Scene_to_In_Quarters_in_HHMMSS]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_Cleared_in_HHMMSS]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_In_Service_in_HHMMSS]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_In_Quarters_in_HHMMSS]
      -- ,[Apparatus_Resource_Cleared_to_In_Quarters_in_HHMMSS]
      -- ,[Apparatus_Resource_Dispatch_to_Staging_in_Minutes]
      -- ,[Apparatus_Resource_Dispatch_to_Left_Scene_in_Minutes]
      -- ,[Apparatus_Resource_Dispatch_to_Cleared_in_Minutes]
      -- ,[Apparatus_Resource_Dispatch_to_Arrived_at_Hospital_in_Minutes]
      -- ,[Apparatus_Resource_Dispatch_to_In_Quarters_in_Minutes]
      -- ,[Apparatus_Resource_Enroute_to_Staging_in_Minutes]
      -- ,[Apparatus_Resource_Enroute_to_Left_Scene_in_Minutes]
      -- ,[Apparatus_Resource_Enroute_to_Arrived_at_Hospital_in_Minutes]
      -- ,[Apparatus_Resource_Enroute_to_Cleared_at_Hospital_in_Minutes]
      -- ,[Apparatus_Resource_Enroute_to_In_Quarters_in_Minutes]
      -- ,[Apparatus_Resource_Staging_to_Arrived_at_Scene_in_Minutes]
      -- ,[Apparatus_Resource_Staging_to_Left_Scene_in_Minutes]
      -- ,[Apparatus_Resource_Staging_to_Arrived_at_Hospital_in_Minutes]
      -- ,[Apparatus_Resource_Staging_to_Cleared_in_Minutes]
      -- ,[Apparatus_Resource_Staging_to_In_Service_in_Minutes]
      -- ,[Apparatus_Resource_Staging_to_In_Quarters_in_Minutes]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_Left_Scene_in_Minutes]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_Arrived_at_Hospital_in_Minutes]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_In_Quarters_in_Minutes]
      -- ,[Apparatus_Resource_Left_Scene_to_Arrived_at_Hospital_in_Minutes]
      -- ,[Apparatus_Resource_Left_Scene_to_Cleared_in_Minutes]
      -- ,[Apparatus_Resource_Left_Scene_to_In_Service_in_Minutes]
      -- ,[Apparatus_Resource_Left_Scene_to_In_Quarters_in_Minutes]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_Cleared_in_Minutes]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_In_Service_in_Minutes]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_In_Quarters_in_Minutes]
      -- ,[Apparatus_Resource_Cleared_to_In_Quarters_in_Minutes]
      -- ,[Apparatus_Resource_Dispatch_to_Staging_in_Seconds]
      -- ,[Apparatus_Resource_Dispatch_to_Left_Scene_in_Seconds]
      -- ,[Apparatus_Resource_Dispatch_to_Cleared_in_Seconds]
      -- ,[Apparatus_Resource_Dispatch_to_Arrived_at_Hospital_in_Seconds]
      -- ,[Apparatus_Resource_Dispatch_to_In_Quarters_in_Seconds]
      -- ,[Apparatus_Resource_Enroute_to_Staging_in_Seconds]
      -- ,[Apparatus_Resource_Enroute_to_Left_Scene_in_Seconds]
      -- ,[Apparatus_Resource_Enroute_to_Arrived_at_Hospital_in_Seconds]
      -- ,[Apparatus_Resource_Enroute_to_Cleared_at_Hospital_in_Seconds]
      -- ,[Apparatus_Resource_Enroute_to_In_Quarters_in_Seconds]
      -- ,[Apparatus_Resource_Staging_to_Arrived_at_Scene_in_Seconds]
      -- ,[Apparatus_Resource_Staging_to_Left_Scene_in_Seconds]
      -- ,[Apparatus_Resource_Staging_to_Arrived_at_Hospital_in_Seconds]
      -- ,[Apparatus_Resource_Staging_to_Cleared_in_Seconds]
      -- ,[Apparatus_Resource_Staging_to_In_Service_in_Seconds]
      -- ,[Apparatus_Resource_Staging_to_In_Quarters_in_Seconds]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_Left_Scene_in_Seconds]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_Arrived_at_Hospital_in_Seconds]
      -- ,[Apparatus_Resource_Arrived_at_Scene_to_In_Quarters_in_Seconds]
      -- ,[Apparatus_Resource_Left_Scene_to_Arrived_at_Hospital_in_Seconds]
      -- ,[Apparatus_Resource_Left_Scene_to_Cleared_in_Seconds]
      -- ,[Apparatus_Resource_Left_Scene_to_In_Service_in_Seconds]
      -- ,[Apparatus_Resource_Left_Scene_to_In_Quarters_in_Seconds]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_Cleared_in_Seconds]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_In_Service_in_Seconds]
      -- ,[Apparatus_Resource_Arrived_at_Hospital_to_In_Quarters_in_Seconds]
      -- ,[Apparatus_Resource_Cleared_to_In_Quarters_in_Seconds]
      -- ,[Apparatus_Resource_Dispatch_To_En_Route_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Dispatch_To_Arrival_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Dispatch_To_Left_Scene_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Dispatch_To_Cleared_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Dispatch_To_In_Service_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Dispatch_To_In_Quarters_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Dispatch_To_Staging_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Cleared_To_In_Service_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Cleared_To_In_Quarters_In_Whole_Minutes]
      -- ,[Apparatus_Resource_Vehicle_Category_Type]
      -- ,[Apparatus_Resource_Vehicle_Mutual_Response_Type]
      -- ,[Apparatus_Resource_Last_Arrived_At_Scene_Date_Time]
      ,[Apparatus_Resource_Primary_Action_Taken]
      -- ,[Apparatus_Resource_Primary_Action_Taken_Code]
      -- ,[Apparatus_Resource_Primary_Action_Taken_Code_And_Description]
      ,[Apparatus_Resource_Arrival_Sequence_Number_By_Overall_Incident]
      ,[Apparatus_Resource_Arrival_Sequence_Number_By_Apparatus_Type]
      ,[Apparatus_Resource_Narrative]
      ,[Apparatus_Resource_Dispatch_Location]
      -- ,[Apparatus_Resource_First_Unit_Arrived_To_Last_Unit_Arrived_in_Seconds]
      -- ,[Apparatus_Resource_First_Unit_Arrived_To_Last_Unit_Arrived_in_Minutes]
	  
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


ORDER BY Dim_ApparatusResources_PK DESC

