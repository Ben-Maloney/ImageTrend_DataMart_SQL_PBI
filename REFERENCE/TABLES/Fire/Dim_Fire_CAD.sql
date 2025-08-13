SELECT TOP (1000) [Dim_Fire_CAD_PK]

      ,[CAD_CAD_ID] -- "RP Number" eg RP21-74519
      ,[CAD_Incident_ID_Internal]

      ,[CAD_Initial_CAD_Incident_Type_Description] -- ProQA call type plus human-readable description eg. "10D1 - CHEST PAIN - NOT ALERT"
      ,[CAD_Basic_Incident_Final_CAD_Dispatch_Code] -- ProQA call type eg. "10D1"

      ,[Incident_Incident_ID_Internal]
      ,[Incident_Number_FK]

      ,[incident_number1_FK]
      ,[Incident_Incident_ID1_Internal]


      ,[CAD_Basic_Incident_Agency_ID_Internal] -- "6dc7ba46-6723-eb11-a95e-001dd8b72424"
      ,[CAD_Basic_Incident_Agency_Name] -- "Portland Fire & Rescue - EMS"

      ,[CAD_Basic_Shift]


      ,[CAD_Basic_Incident_Completed]
      ,[CAD_Basic_Exposure]
      ,[CAD_Basic_Fire_Departement_ID_FDID]
      ,[CAD_Basic_Incident_Import_Method]
      ,[CAD_Basic_Incident_Date]
      ,[CAD_Basic_Incident_Number]
      ,[CAD_Basic_Incident_Origin]
      ,[CAD_Basic_Incident_Type]
      ,[CAD_Basic_Incident_Locked]
      ,[CAD_Basic_NFIRS_Number]
      ,[CAD_Basic_Incident_Status]
      ,[CAD_Basic_Incident_Validity]
      ,[CAD_Basic_Incident_Apartment_Number]
      ,[CAD_Basic_Incident_City_GNIS]
      ,[CAD_Basic_Incident_City_Name]
      ,[CAD_Basic_Incident_Country_Code]
      ,[CAD_Basic_Incident_Country_Name]
      ,[CAD_Basic_Incident_County_GNIS]
      ,[CAD_Basic_Incident_County_Name]
      ,[CAD_Basic_Incident_Cross_Street]
      ,[CAD_Basic_Incident_GPS_Location]
      ,[CAD_Basic_Incident_Post_Office_Box]
      ,[CAD_Basic_Incident_State_GNIS]
      ,[CAD_Basic_Incident_State]
      ,[CAD_Basic_Incident_Street_Name]
      ,[CAD_Basic_Incident_Street_Number]
      ,[CAD_Basic_Incident_Postal_Code]
      ,[CAD_Basic_Incident_Street_Prefix]
      ,[CAD_Basic_Incident_Street_Suffix]
      ,[CAD_Basic_Incident_Street_Type]
      ,[CAD_Basic_Alarms]
      ,[CAD_Basic_Incident_Critical]
      ,[CAD_Basic_Incident_Detector]
      ,[CAD_Basic_Incident_Hazardouse_Materials_Count]
      ,[CAD_Basic_Hazardous_Materials_Release_Code_And_Description]
      ,[CAD_Basic_Incident_Patient_Count]
      ,[CAD_Basic_Incident_Reported_By]
      ,[CAD_Basic_Was_State_Team_Mobilized_For_Incident]
      ,[CAD_Basic_Type_Of_Alarm]
      ,[CAD_Basic_Address_Override]
      ,[CAD_Basic_Incident_Census_Tract]
      ,[CAD_Basic_Incident_District]
      ,[CAD_Basic_Incident_Alarm_Time]
      ,[CAD_Basic_Incident_Arrival_Date_Time]
      ,[CAD_Basic_Incident_Controlled_Date_Time]
      ,[CAD_Basic_Incident_In_Service_Date_Time]
      ,[CAD_Basic_Incident_Last_Unit_Cleared_Date_Time]
      ,[CAD_Basic_Incident_PSAP_Date_Time]
      ,[CAD_Basic_Incident_Total_Time_In_Minutes]

      ,[CAD_Basic_Incident_Zone_Number] -- Battalion eg "Battalion 3"
      ,[CAD_Basic_Primary_Station] -- eg "Station 11"
      ,[CAD_Basic_Incident_Primary_Narrative] -- always NULL :(

      ,[CAD_Basic_Incident_Mixed_Use_Property_Code_And_Description]
      ,[CAD_Basic_Property_Use_Code_And_Description]
      ,[CAD_Basic_Incident_Wildland_Location]
      ,[CAD_Basic_Number_Of_Contract_Response]
      ,[CAD_Basic_Incident_Location_Type]

    --   ,[System_ID] -- IGNORE
      ,[CreatedOn]
      ,[ModifiedOn]

  FROM [Elite_DWPortland].[DwFire].[Dim_Fire_CAD]

  ORDER BY Dim_Fire_CAD_PK DESC
