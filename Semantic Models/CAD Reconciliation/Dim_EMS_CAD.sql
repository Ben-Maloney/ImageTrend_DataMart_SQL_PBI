SELECT TOP (10000)

    [Dim_CAD_PK]
    ,[CAD_Incident_ID_Internal]
    ,[Incident_Incident_ID_Internal]
    ,[Incident_Number_FK]
    ,[CAD_CAD_ID]
    ,[incident_number1_FK]
    ,[Incident_Incident_ID1_Internal]
    ,[CAD_Incident_Unit_Dispatched_CAD_Record_ID]



    ,[CAD_Incident_Initial_CAD_Dispatch_Code]
    ,[CAD_Incident_Final_CAD_Dispatch_Code]




    --   ,[CAD_Crew_Member_Licensure_ID_List]
    --   ,[CAD_Crew_Member_Full_Name_List]
    --   ,[CAD_Crew_Member_Level_List]
    -- ,[CAD_Crew_Member_Response_Role_List]
    -- ,[CAD_Crew_Member_Full_Name_And_ID_List]
    -- ,[CAD_Crew_Member_Full_Name_And_Level_List]
    
    --   ,[CAD_Response_EMS_Shift]
    --   ,[CAD_Response_EMS_Unit_Call_Sign]


      ,[CAD_Incident_Number]

      ,[CAD_Dispatch_Notified_Date_Time]
      ,[CAD_PSAP_Call_Date_Time]

      ,[CAD_Complaint_Reported_By_Dispatch]
      ,[CAD_EMD_Card_Number]


    --   ,[CAD_Response_EMS_Vehicle_Unit_Number]

      ,[CAD_EMS_Response_Number]



      ,[CAD_Unit_Back_In_Service_Date_Time]
    --   ,[CAD_Unit_Canceled_Date_Time] -- THIS IS EMPTY ALL THE WAY DOWN
      ,[CAD_Unit_Notified_By_Dispatch_Date_Time]

      ,[CAD_Patient_Arrived_At_Destination_Date_Time] -- THIS SEEMS TO BE THE MEDIC TRC TIME!~!!!!!!!!!!!!!!!!
    --   ,[CAD_Transfer_Of_EMS_Patient_Care_Date_Time]


      ,[CAD_Unit_Arrived_On_Scene_Date_Time]
      ,[CAD_Unit_En_Route_Date_Time]
      ,[CAD_Unit_Left_Scene_Date_Time]
      ,[CAD_Scene_Incident_GPS_Latitude]
      ,[CAD_Scene_Incident_GPS_Longitude]

    --   ,[CAD_Scene_Incident_Zone_Number] -- BATTALION of incident
    --   ,[CAD_Scene_Incident_Apartment_Number]


    --   ,[CAD_Scene_Incident_Street_Address]
    --   ,[System_ID]
    --   ,[CreatedOn]
    --   ,[ModifiedOn]

    --   ,[CAD_Agency_ID]
    --   ,[CAD_EMS_Agency_Number]
    --   ,[CAD_EMS_Agency_Name]





    --   ,[CAD_Scene_Incident_Zone_Description]
    --   ,[CAD_Narrative]
  FROM [Elite_DWPortland].[DwEms].[Dim_EMS_CAD]

  WHERE [CAD_EMS_Agency_Name] = 'Portland Fire & Rescue - EMS'

  ORDER BY Dim_CAD_PK DESC

