/*
------------------------------------------------------------------------------
    Purpose:
        This SQL query retrieves the top 1000 records from the [Fact_CAD] table,
        joining with the [Dim_CAD] and [Dim_CAD_Response] tables to enrich the result set with additional
        CAD event and response details.  It also joins to Fact_Incident
        on CAD_Incident_ID_Internal to pull in incident data.
    Parameters:
        - None (static query; add WHERE clauses as needed for filtering).
    Tables Involved:
        - [Elite_DWPortland].[DwEms].[Fact_CAD]: Fact table containing CAD event facts.
        - [Elite_DWPortland].[DwEms].[Dim_CAD]: Dimension table with detailed CAD event information.
        - [Elite_DWPortland].[DwEms].[Dim_CAD_Response]: Dimension table with CAD response details.
        - [Elite_DWPortland].[DwEms].[Fact_Incident]: Fact table containing incident information.
    Output:
        - Returns columns from Fact_CAD, Dim_CAD, Dim_CAD_Response, and Fact_Incident, including identifiers, foreign keys,
          event times, descriptive fields, and response details.
    Usage:
        - Use this query to analyze CAD event facts alongside their detailed dimension and response data, as well as related incident data.
        - Ensure all tables are accessible in the data warehouse.
    Notes:
        - Consider adding WHERE clauses for performance or filtering.
        - Adjust SELECT columns as needed for your reporting requirements.
    Author:
        - [Your Name or Team]
    Date:
        - [Creation Date]
    Last Modified:
        - [Last Modification Date and Reason]
------------------------------------------------------------------------------
*/
WITH EnrichedCADData AS (
    SELECT
        -- Fact_CAD columns
          f.[Fact_CAD_PK]
        , f.[CAD_ID_Internal]
        , f.[CreatedOn]
        , dcd.[CAD_EMD_Card_Number]
        -- Dim_CAD columns
        , d.[CAD_PSAP_Call_Date_Time]
        , d.[CAD_Dispatch_Notified_Date_Time]
        , d.[CAD_Unit_Notified_By_Dispatch_Date_Time]
        , d.[CAD_Unit_Canceled_Date_Time]
        , d.[CAD_Unit_Back_In_Service_Date_Time]
        , d.[CAD_Patient_Arrived_At_Destination_Date_Time]
        , d.[CAD_Unit_Arrived_On_Scene_Date_Time]
        , d.[CAD_Unit_En_Route_Date_Time]
        , d.[CAD_Unit_Left_Scene_Date_Time]
        , d.[CAD_Unit_Back_At_Home_Location_Date_Time]
        , d.[CAD_Response_EMS_Shift]
        , d.[CAD_Response_EMS_Agency_Name] as Dim_CAD_Agency
        , d.[CreatedOn] AS Dim_CAD_CreatedOn
        , d.[CAD_Incident_Initial_CAD_Dispatch_Code]
        , d.[CAD_Incident_Final_CAD_Dispatch_Code]
        , d.[CAD_Incident_Dispatched_Hospital_Code]
        -- Dim_CAD_Response columns
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
        , r.[CAD_Response_EMS_Agency_Name] as Dim_Response_agency
        , r.[CAD_Response_Standby_Purpose]
        , r.[CAD_Response_Type_Of_Dispatch_Delay_List]
        , r.[CAD_Response_Type_Of_Response_Delay_List]
        , r.[CAD_Response_Type_Of_Scene_Delay_List]
        , r.[CAD_Response_Type_Of_Transport_Delay_List]
        , r.[CAD_Response_Type_Of_Turnaround_Delay_List]
        , r.[CAD_Response_Level_Of_Care_Of_This_Unit]
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
        , dcd.[CAD_ID_Internal] AS Dim_CAD_Dispatch_CAD_ID_Internal  -- Alias to avoid name clash
        , dcd.[Unit_Dispatched_CAD_Record_ID]
        , dcd.[CAD_Complaint_Reported_By_Dispatch]
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
        , fi.[Dim_Unit_Arrived_On_Scene_Date_FK]
        , fi.[Dim_Unit_Arrived_On_Scene_TimeOfDay_FK]
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
    FROM [Elite_DWPortland].[DwEms].[Fact_CAD] f
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD] d
        ON f.Dim_CAD_FK = d.Dim_CAD_PK
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Response] r
        ON f.Dim_CAD_Response_FK = r.Dim_CAD_Response_PK
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Scene] s
        ON f.Dim_CAD_Scene_FK = s.Dim_CAD_Scene_PK
    LEFT JOIN [Elite_DWPortland].[DwEms].[Fact_Incident] fi
        ON f.CAD_ID_Internal = fi.CAD_Incident_ID_Internal
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_CAD_Dispatch] dcd
        ON f.Dim_CAD_Dispatch_FK = dcd.Dim_CAD_Dispatch_PK
    WHERE
        d.CAD_Response_EMS_Agency_Name LIKE 'Portland%'
        AND CAD_Unit_Notified_By_Dispatch_Date_Time >= '2024-07-01'
)
SELECT
    *,
    CASE
        WHEN CAD_EMD_Card_Number LIKE '[1-9][A-Z0-9]%' OR CAD_EMD_Card_Number LIKE '[1-3][0-9][A-Z0-9]%' THEN
            CASE
                WHEN LEFT(CAD_EMD_Card_Number, 2) LIKE '[1-3][0-9]' THEN LEFT(CAD_EMD_Card_Number, 2)
                ELSE LEFT(CAD_EMD_Card_Number, 1) 
            END
        ELSE NULL
    END AS Extracted_Card_Number,
    CASE
        WHEN CASE
                WHEN CAD_EMD_Card_Number LIKE '[1-9][A-Z0-9]%' OR CAD_EMD_Card_Number LIKE '[1-3][0-9][A-Z0-9]%' THEN
                    CASE
                        WHEN LEFT(CAD_EMD_Card_Number, 2) LIKE '[1-3][0-9]' THEN LEFT(CAD_EMD_Card_Number, 2)
                        ELSE LEFT(CAD_EMD_Card_Number, 1)
                    END
                ELSE NULL
            END IS NOT NULL AND TRY_CAST(CASE
                                                WHEN CAD_EMD_Card_Number LIKE '[1-9][A-Z0-9]%' OR CAD_EMD_Card_Number LIKE '[1-3][0-9][A-Z0-9]%' THEN
                                                    CASE
                                                        WHEN LEFT(CAD_EMD_Card_Number, 2) LIKE '[1-3][0-9]' THEN LEFT(CAD_EMD_Card_Number, 2)
                                                        ELSE LEFT(CAD_EMD_Card_Number, 1)
                                                    END
                                                ELSE NULL
                                            END AS INT) BETWEEN 1 AND 33 THEN 1
        ELSE 0
    END AS Card_Type
FROM
    EnrichedCADData
ORDER BY Fact_CAD_PK DESC;
