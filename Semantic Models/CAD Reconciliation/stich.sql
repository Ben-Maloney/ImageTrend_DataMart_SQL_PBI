/*
------------------------------------------------------------------------------


------------------------------------------------------------------------------
*/
SELECT
    -- Fact_CAD columns
      f.[Fact_CAD_PK]

    -- NOTE: These two are the SAME (or appear to be the same!) :)
    , f.[CAD_ID_Internal]
    , dcd.[CAD_ID_Internal] AS Dim_CAD_Dispatch_CAD_ID_Internal  -- Alias to avoid name clash
    , de.[CAD_CAD_ID] AS CAD_CAD_ID

    -- , f.[Dim_CAD_FK]
    -- , f.[Dim_CAD_Dispatch_FK]
    -- , f.[Dim_CAD_Disposition_FK]
    -- , f.[Dim_CAD_Patient_FK]
    -- , f.[Dim_CAD_Response_FK]
    -- , f.[Dim_CAD_Scene_FK]
    -- , f.[Dim_Agency_FK]
    --- NOTE: SKIPPED A BUNCH OF COLUMNS HERE
    -- , f.[CAD_Current_Time_PSAP_Notifying_Dispatch_In_Seconds]
    -- , f.[CAD_Current_Time_PSAP_Notifying_Unit_In_Seconds]
    -- , f.[CAD_Current_Time_Dispatch_Notifying_Unit_In_Seconds]
    -- , f.[CAD_Current_Time_Unit_Assembling_In_Minutes]
    -- , f.[CAD_Current_Time_Unit_Responding_In_Minutes]
    -- , f.[CAD_Current_Time_Unit_On_Scene_In_Minutes]
    -- , f.[CAD_Current_Time_Unit_With_Patient_On_Scene_In_Minutes]
    -- , f.[CAD_Current_Time_Unit_En_Route_To_Destination_In_Minutes]
    -- , f.[CAD_Current_Time_Unit_At_Destination_In_Minutes]
    -- , f.[CAD_Current_Time_Unit_Returning_Home_In_Minutes]
    , f.[CreatedOn]

    -- NOTE: THIS IS THE REGULAR EXPRESSION FOR CALL TYPE DETERMINATE
    , dcd.[CAD_EMD_Card_Number]

    , LEFT(dcd.[CAD_EMD_Card_Number], PATINDEX('%[^0-9]%', dcd.[CAD_EMD_Card_Number] + 'A') - 1) as ProQA_CARD


    -- , f.[ModifiedOn]
    -- Dim_CAD columns
    -- , d.[CAD_Date_Time]
    -- , d.[CAD_Response_Urgency]
    -- , d.[CAD_ID]
    -- , d.[CAD_Crew_Member_Licensure_ID_List]
    -- , d.[CAD_Crew_Member_Full_Name_List]
    -- , d.[CAD_Crew_Member_Level_List]
    -- , d.[CAD_Crew_Member_Respose_Role_List]
    -- , d.[CAD_Agency_ID]
    -- , d.[CAD_Patient_Care_Report_Number_PCR]

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


    -- , d.[CAD_Response_Narrative]
    , d.[CAD_Response_EMS_Shift]
    -- , d.[CAD_Scene_Incident_Map_Coordinates]
    -- , d.[CAD_Scene_Incident_Map_Page]
    -- , d.[CAD_Scene_Incident_Map_Year]
    -- , d.[CAD_Response_EMS_Agency_Number]
    , d.[CAD_Response_EMS_Agency_Name]
    -- , d.[CAD_Response_EMS_Agency_State_GNIS_Code]
    -- , d.[CAD_Response_EMS_Agency_State_Name]
    -- , d.[CAD_Dispatch_Center_CAD_Name_Or_ID_List]
    -- , d.[CAD_Dispatch_Acknowledged_By_EMS_Unit_Date_Time]
    -- , d.[CAD_Arrival_At_Destination_Landing_Area_Date_Time]
    -- , d.[CAD_Destination_Patient_Transfer_Of_Care_Date_Time]
    -- , d.[CAD_EMS_Call_Completed_Date_Time]
    , d.[CreatedOn] AS Dim_CAD_CreatedOn
    -- , d.[ModifiedOn] AS Dim_CAD_ModifiedOn
    -- , d.[CAD_Agency_Location_Number] -- NOTE: TRY THIS OUT TODO:
    -- , d.[CAD_Agency_Location_Name]-- NOTE: TRY THIS OUT TODO:

    -- , d.[CAD_Agency_Location_Type]
    -- , d.[CAD_Agency_Location_Latitude]
    -- , d.[CAD_Agency_Location_Longitude]
    -- , d.[CAD_Agency_Location_US_National_Grid_Coordianates]
    -- , d.[CAD_Agency_Location_Zone_District]
    -- , d.[CAD_Agency_Location_Address]
    -- , d.[CAD_Agency_Location_Address2]
    -- , d.[CAD_Agency_Location_Postal_Code]
    -- , d.[CAD_Agency_Location_City]
    -- , d.[CAD_Agency_Location_State]
    -- , d.[CAD_Agency_Location_County]
    -- , d.[CAD_Agency_Location_Country]
    -- , d.[CAD_First_Posted_Date_Time]
    -- , d.[CAD_Incident_Unit_Dispatched_CAD_Record_ID] -- NOTE: This one is the HUGE concat'd thing
    , d.[CAD_Incident_Initial_CAD_Dispatch_Code]
    , d.[CAD_Incident_Final_CAD_Dispatch_Code]
    , d.[CAD_Incident_Dispatched_Hospital_Code]
    -- , d.[CAD_Incident_Dispatched_Hospital_Name]
    -- , d.[CAD_Narrative]

    -- Dim_CAD_Response columns
    -- , r.[Dim_CAD_Response_PK]
    , r.[CAD_Incident_Number] as RP_NUMBER
    , r.[CAD_Beginning_Odometer_Reading_Of_Responding_Vehicle]
    , r.[CAD_Response_Vehicle_Dispatch_Location]
    , r.[CAD_Response_EMS_Unit_Call_Sign]
    , r.[CAD_Response_EMS_Vehicle_Unit_Number]
    , r.[CAD_Ending_Odometer_Reading_Of_Responding_Vehicle]
    , r.[CAD_On_Scene_Odometer_Reading_Of_Responding_Vehicle]
    , r.[CAD_Patient_Destination_Odometer_Reading_Of_Responding_Vehcle]
    , r.[CAD_Response_Primary_Role_Of_Unit]
    , r.[CAD_Response_Mode_To_Scene]
    , r.[CAD_Response_Type_Of_Service_Requested]
    , r.[CAD_EMS_Response_Number]
    , r.[CAD_Response_EMS_Agency_Number]
    , r.[CAD_Response_EMS_Agency_Name]
    , r.[CAD_Response_Standby_Purpose]
    , r.[CAD_Response_Type_Of_Dispatch_Delay_List]
    , r.[CAD_Response_Type_Of_Response_Delay_List]
    , r.[CAD_Response_Type_Of_Scene_Delay_List]
    , r.[CAD_Response_Type_Of_Transport_Delay_List]
    , r.[CAD_Response_Type_Of_Turnaround_Delay_List]
    , r.[CAD_Response_Level_Of_Care_Of_This_Unit]
    -- , r.[CAD_Response_Vehicle_Dispatch_GPS_Location]
    -- , r.[CAD_Response_Vehicle_Dispatch_GPS_Latitude]
    -- , r.[CAD_Response_Vehicle_Dispatch_GPS_Longitude]
    , r.[CAD_Response_Vehicle_Dispatch_US_National_Grid_Location]
    , r.[CAD_Response_Additional_Response_Mode_Descriptors_List]
    , r.[CAD_Response_Vehicle_Distance_Begin_To_Scene]
    , r.[CAD_Response_Vehicle_Distance_Scene_To_Destination]
    , r.[CAD_Response_Vehicle_Distance_Destination_To_End]
    , r.[CAD_Response_Vehicle_Total_Distance_Begin_To_End]
    , r.[CAD_Response_Vehicle_Distance_Begin_To_Scene_Range_Sort_Order]
    , r.[CAD_Response_Vehicle_Distance_Scene_To_Destination_Range_Sort_Order]
    , r.[CAD_Response_Vehicle_Distance_Destination_To_End_Range_Sort_Order]
    , r.[CAD_Response_Vehicle_Total_Distance_Begin_To_End_Range_Sort_Order]
    , r.[CAD_Response_Vehicle_Distance_Begin_To_Scene_Range]
    , r.[CAD_Response_Vehicle_Distance_Scene_To_Destination_Range]
    , r.[CAD_Response_Vehicle_Distance_Destination_To_End_Range]
    , r.[CAD_Response_Vehicle_Total_Distance_Begin_To_End_Range]
    , r.[CreatedOn] AS Dim_CAD_Response_CreatedOn
    , r.[ModifiedOn] AS Dim_CAD_Response_ModifiedOn

    -- Dim_CAD_Scene columns
    , s.[Dim_CAD_Scene_PK]
    , s.[CAD_Initial_Responder_Arrived_On_Scene_Date_Time]
    , s.[CAD_Scene_Incident_GPS_Latitude]
    , s.[CAD_Scene_Incident_GPS_Longitude]
    -- , s.[CAD_Scene_Incident_GPS_Location]
    , s.[CAD_Scene_Incident_Zone_Number]
    , s.[CAD_Scene_Incident_Apartment_Number]
    , s.[CAD_Scene_Incident_City_GNIS_Code]
    , s.[CAD_Scene_Incident_City_Name]
    , s.[CAD_Scene_Incident_County_GNIS_Code]
    , s.[CAD_Scene_Incident_County_Name]
    , s.[CAD_Scene_Incident_Postal_Code]
    , s.[CAD_Scene_Incident_State_GNIS_Code]
    , s.[CAD_Scene_Incident_State_Name]
    , s.[CAD_Scene_Incident_Street_Address]
    , s.[CAD_Scene_Incident_Street_Address2]
    , s.[CAD_Scene_Incident_Facility_Code]
    , s.[CAD_Scene_Incident_Location_Type]

    , s.[CAD_Scene_Mass_Casualty_Incident]
    , s.[CAD_Scene_Incident_US_National_Grid_Coordinates]
    , s.[CAD_Scene_Incident_Facility_Or_Location_Name]
    , s.[CAD_Scene_Incident_Mile_Post_Or_Major_Roadway]
    , s.[CAD_Scene_Incident_Cross_Street_Or_Directions]
    , s.[CAD_Scene_Incident_Country_Code]
    , s.[CAD_Scene_Incident_Country_Name]
    , s.[CAD_Incident_Census_Tract]
    , s.[CreatedOn] AS Dim_CAD_Scene_CreatedOn
    , s.[ModifiedOn] AS Dim_CAD_Scene_ModifiedOn
    , s.[CAD_Scene_Area_Classification]
    , s.[CAD_Scene_Area_Of_Operation]
    , s.[CAD_Scene_Incident_Zone_Description]

    -- Dim_CAD_Dispatch Columns
    , dcd.[Dim_CAD_Dispatch_PK]
    -- , dcd.[CAD_ID_Internal] AS Dim_CAD_Dispatch_CAD_ID_Internal  -- Alias to avoid name clash
    , dcd.[Unit_Dispatched_CAD_Record_ID]
    , dcd.[CAD_Complaint_Reported_By_Dispatch]
    -- EMD card thing is taken from here... NOTE: TODO:

    , dcd.[CAD_Dispatch_Center_Name_Or_ID]
    , dcd.[CAD_Dispatch_Priority_Patient_Acuity]
    , dcd.[CreatedOn] AS Dim_CAD_Dispatch_CreatedOn
    , dcd.[ModifiedOn] AS Dim_CAD_Dispatch_ModifiedOn

    -- Fact_Incident Columns
    , fi.[Fact_Incident_PK]
    , fi.[Incident_Transaction_GUID_Internal]
    , fi.[Agency_ID_Internal]
    , fi.[Dim_Agency_FK]
    , fi.[Dim_Airway_FK]
    , fi.[Dim_CardiacArrest_FK]
    , fi.[Dim_Disposition_FK]
    , fi.[Dim_Incident_FK]
    , fi.[Dim_Patient_FK]
    , fi.[Dim_Response_FK]
    , fi.[Dim_Scene_FK]
    , fi.[Dim_Situation_FK]
    , fi.[Dim_VitalsHighLowInitLast_FK]
    , fi.[Dim_Outcome_FK]
    , fi.[Dim_PatientHistory_FK]
    , fi.[Dim_Payment_FK]
    , fi.[Dim_InjuryDetails_FK]
    , fi.[Incident_Validity_Score]
    , fi.[Dim_Incident_Date_FK]
    , fi.[Dim_Incident_TimeOfDay_FK]
    , fi.[Dim_PSAP_Date_FK]
    , fi.[Dim_PSAP_TimeOfDay_FK]
    , fi.[Dim_Dispatch_Notified_Date_FK]
    , fi.[Dim_Dispatch_Notified_TimeOfDay_FK]
    , fi.[Dim_Unit_Notified_By_Dispatch_Date_FK]
    , fi.[Dim_Unit_Notified_By_Dispatch_TimeOfDay_FK]
    , fi.[Dim_Dispatch_Acknowledged_Date_FK]
    , fi.[Dim_Dispatch_Acknowledged_TimeOfDay_FK]
    , fi.[Dim_Unit_Enroute_Date_FK]
    , fi.[Dim_Unit_Enroute_TimeOfDay_FK]
    , fi.[Dim_Unit_Arrived_On_Scene_Date_FK]    , fi.[Dim_Unit_Arrived_On_Scene_TimeOfDay_FK]
    , fi.[Dim_Arrived_At_Patient_Date_FK]
    , fi.[Dim_Arrived_At_Patient_TimeOfDay_FK]
    , fi.[Dim_Transfer_Of_Patient_Date_FK]
    , fi.[Dim_Transfer_Of_Patient_TimeOfDay_FK]
    , fi.[Dim_Unit_Left_Scene_Date_FK]
    , fi.[Dim_Unit_Left_Scene_TimeOfDay_FK]
    , fi.[Dim_Arrival_At_Destination_Landing_Area_Date_FK]
    , fi.[Dim_Arrival_At_Destination_Landing_Area_TimeOfDay_FK]
    , fi.[Dim_Unit_Back_In_Service_Date_FK]
    , fi.[Dim_Unit_Back_In_Service_TimeOfDay_FK]
    , fi.[Dim_Unit_Canceled_Date_FK]
    , fi.[Dim_Unit_Canceled_TimeOfDay_FK]
    , fi.[Dim_Unit_Back_At_Home_Date_FK]
    , fi.[Dim_Unit_Back_At_Home_TimeOfDay_FK]


    , fi.[CreatedOn] AS Fact_Incident_CreatedOn

    , fi.[Incident_Agency_Short_Name]
    , fi.[Patient_Age_In_Years]

    , fi.[Dim_Narrative_FK]
    , fi.[Dim_Incident_One_To_One_PK]
    , fi.[CAD_Incident_ID_Internal]
    , fi.[CAD_ID_FK]
    , fi.[CAD_ID1_FK]
    , fi.[CAD_Incident_ID1_Internal]
    , fi.[Dim_IncidentSupplementalQuestions_FK]
    , fi.[Dim_IncidentSupplementalQuestions1_FK]
    , fi.[Dim_IncidentSupplementalQuestions2_FK]

    , di.[Incident_Status]

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

-- Fact_Incident Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Fact_Incident] fi
    ON f.CAD_ID_Internal = fi.CAD_Incident_ID_Internal

-- Dim_Incident Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] di
    ON fi.Dim_Incident_FK = di.Dim_Incident_PK


-- Dim_CAD Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD] d
    ON f.Dim_CAD_FK = d.Dim_CAD_PK

-- Dim_EMS_CAD for CAD_CAD_ID and incident-level identifiers
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_EMS_CAD] de
    ON d.[Dim_CAD_PK] = de.[Dim_CAD_PK]

-- Dim_CAD_Response Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Response] r
    ON f.Dim_CAD_Response_FK = r.Dim_CAD_Response_PK

-- Dim_CAD_Scene Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Scene] s
    ON f.Dim_CAD_Scene_FK = s.Dim_CAD_Scene_PK

-- Dim_CAD_Dispatch Columns
LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Dispatch] dcd
    ON f.Dim_CAD_Dispatch_FK = dcd.Dim_CAD_Dispatch_PK


/*
#####################################################################
 FILTERS
#####################################################################
*/
WHERE
    d.CAD_Response_EMS_Agency_Name LIKE 'Portland%'
    AND d.[CAD_Unit_Notified_By_Dispatch_Date_Time] >= '2025-01-01'


--NOTE: only for testing
ORDER BY f.Fact_CAD_PK DESC
