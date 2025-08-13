SELECT TOP (1000)

      [Dim_CAD_PK]

      -- ,[CAD_CAD_ID] -- USELESS eg "RP25-9110820250813:09:01:27E19"
      -- ,[CAD_Agency_ID]

      ,[CAD_Incident_Number] -- RP NUMBER eg "RP25-91208"
      ,[CAD_Incident_ID_Internal]

      -- ,[CAD_EMS_Agency_Number]
      ,[CAD_EMS_Agency_Name] -- eg "Portland Fire & Rescue - EMS"

      ,[Incident_Number_FK]
      ,[Incident_Incident_ID_Internal]

    --   ,[incident_number1_FK]            -- appears to all be NULL
    --   ,[Incident_Incident_ID1_Internal] -- appears to all be NULL

    -- NOTE: these two are the same.. just use Unit_Call_Sign
      ,[CAD_Response_EMS_Unit_Call_Sign]
      -- ,[CAD_Response_EMS_Vehicle_Unit_Number]

      ,[CAD_Response_EMS_Shift]
      -- ,[CAD_Response_Primary_Role_Of_Unit] -- appears to all be NULL
      -- ,[CAD_Response_Mode_To_Scene] -- appears to all be NULL
    --   ,[CAD_Response_Type_Of_Service_Requested] -- appears to all be NULL
      -- ,[CAD_Response_Urgency] -- eg "Immediate" or "Non-Immediate" or NULL

      ,[CAD_Crew_Member_Licensure_ID_List]
      ,[CAD_Crew_Member_Full_Name_List]
      ,[CAD_Crew_Member_Level_List]
    --   ,[CAD_Crew_Member_Respose_Role_List] -- TYPO  -- appears to all be NULL
      ,[CAD_Crew_Member_Response_Role_List]
      ,[CAD_Crew_Member_Full_Name_And_ID_List]
      ,[CAD_Crew_Member_Full_Name_And_Level_List]

      -- appears to all be NULL
      -- ,[CAD_Disposition_Destination_Apartment_Number]
      -- ,[CAD_Disposition_Destination_City_GNIS_Code]
      -- ,[CAD_Disposition_Destination_City_Name]
      -- ,[CAD_Disposition_Destination_Street_Address]
      -- ,[CAD_Disposition_Destination_Street_Address2]
      -- ,[CAD_Disposition_Destination_County_GNIS_Code]
      -- ,[CAD_Disposition_Destination_County_Name]
      -- ,[CAD_Disposition_Destination_Postal_Code]
      -- ,[CAD_Disposition_Destination_State_GNIS_Code]
      -- ,[CAD_Disposition_Destination_State_Name]
      -- ,[CAD_Disposition_Destination_Transferred_To_Code]
      -- ,[CAD_Disposition_Destination_Transferred_To_Name]
      -- ,[CAD_Disposition_Transport_Mode_From_Scene]
      -- ,[CAD_Disposition_Patient_Disposition]
      -- ,[CAD_Patient_Care_Report_Number_PCR]

      -- TIMES
      ,[CAD_Dispatch_Notified_Date_Time]
      ,[CAD_PSAP_Call_Date_Time]
      ,[CAD_Unit_Back_In_Service_Date_Time]
      -- ,[CAD_Unit_Canceled_Date_Time] -- appears to all be NULL
      ,[CAD_Unit_Notified_By_Dispatch_Date_Time]
      -- ,[CAD_Arrived_At_Patient_Date_Time] -- appears to all be NULL
      ,[CAD_Patient_Arrived_At_Destination_Date_Time]
      -- ,[CAD_Transfer_Of_EMS_Patient_Care_Date_Time] -- appears to all be NULL
      ,[CAD_Unit_Arrived_On_Scene_Date_Time]
      ,[CAD_Unit_En_Route_Date_Time]
      ,[CAD_Unit_Left_Scene_Date_Time]
      -- ,[CAD_Initial_Responder_Arrived_On_Scene_Date_Time] -- appears to all be NULL
      -- ,[CAD_Unit_Back_At_Home_Location_Date_Time] -- appears to all be NULL
      
       -- appears to all be NULL
      -- ,[CAD_Patient_Home_Apartment_Number]
      -- ,[CAD_Patient_Home_City_GNIS_Code]
      -- ,[CAD_Patient_Home_City_Name]
      -- ,[CAD_Patient_Home_Street_Address]
      -- ,[CAD_Patient_Home_Street_Address2]
      -- ,[CAD_Patient_Home_County_GNIS_Code]
      -- ,[CAD_Patient_Home_County_Name]
      -- ,[CAD_Patient_Home_Postal_Code]
      -- ,[CAD_Patient_Home_State_GNIS_Code]
      -- ,[CAD_Patient_Home_State_Name]
      -- ,[CAD_Patient_Date_Of_Birth]
      -- ,[CAD_Patient_First_Name]
      -- ,[CAD_Patient_Last_Name]
      -- ,[CAD_Patient_Middle_Initial_Name]

      -- ,[CAD_EMD_Performed] -- appears to all be NULL
  
      ,[CAD_EMS_Response_Number] -- "RP Number" eg RP21-74519
      ,[CAD_Complaint_Reported_By_Dispatch] -- Human readable call type description
      -- ,[CAD_Response_Narrative] -- appears to all be NULL
      -- ,[CAD_Response_Vehicle_Type] -- appears to all be NULL
      -- ,[CAD_Response_Vehicle_Dispatch_Location] -- appears to all be NULL
      -- ,[CAD_Incident_Unit_Dispatched_CAD_Record_ID] -- USELESS eg "RP25-9120920250813:01:41:28M1329"

      ,[CAD_EMD_Card_Number] -- PROQA CALL TYPE
      ,[CAD_Incident_Initial_CAD_Dispatch_Code]
      ,[CAD_Incident_Final_CAD_Dispatch_Code]
    --   ,[CAD_Incident_Dispatched_Hospital_Code]
    --   ,[CAD_Incident_Dispatched_Hospital_Name]

      -- Odometer Readings - NEVER USED
      -- ,[CAD_Patient_Destination_Odometer_Reading_Of_Responding_Vehcle]
      -- ,[CAD_Beginning_Odometer_Reading_Of_Responding_Vehicle]
      -- ,[CAD_On_Scene_Odometer_Reading_Of_Responding_Vehicle]
      -- ,[CAD_Ending_Odometer_Reading_Of_Responding_Vehicle]

      ,[CAD_Scene_Incident_GPS_Latitude]
      ,[CAD_Scene_Incident_GPS_Longitude]
      -- ,[CAD_Scene_Incident_Map_Coordinates]
      -- ,[CAD_Scene_Incident_Map_Page]
      -- ,[CAD_Scene_Incident_Map_Year]
      -- ,[CAD_Scene_Incident_GPS_Location]
      -- ,[CAD_Scene_Incident_City_GNIS_Code]
      ,[CAD_Scene_Incident_City_Name]
      -- ,[CAD_Scene_Incident_County_GNIS_Code]
      ,[CAD_Scene_Incident_County_Name]
      ,[CAD_Scene_Incident_Postal_Code]
      -- ,[CAD_Scene_Incident_State_GNIS_Code]
      -- ,[CAD_Scene_Incident_State_Name]
      ,[CAD_Scene_Incident_Street_Address]
      -- ,[CAD_Scene_Incident_Street_Address2] -- appears to all be NULL
      ,[CAD_Scene_Incident_Apartment_Number]

      ,[CAD_Scene_Incident_Zone_Number] -- Battalion
      ,[CAD_Scene_Incident_Zone_Description] -- list of station in the battalion eg "Stations: 2, 7, 11, 19, 29, 30"
      -- ,[CAD_Scene_Incident_Facility_Code]
      -- ,[CAD_Scene_Incident_Location_Type]
      -- ,[CAD_Scene_Incident_Area_Classification]
      -- ,[CAD_Scene_Incident_Area_Of_Operation]

      -- ,[CAD_Narrative]

      -- ,[System_ID] -- IGNORE - never used
      ,[CreatedOn]
      ,[ModifiedOn]
  FROM [Elite_DWPortland].[DwEms].[Dim_EMS_CAD]

WHERE [CAD_Agency_ID] = '6dc7ba46-6723-eb11-a95e-001dd8b72424'
  -- AND CAD_Scene_Incident_Street_Address2 <> NULL

ORDER BY Dim_CAD_PK desc