SELECT TOP (100) [Fact_Incident_PK]
      ,[Agency_ID_Internal]
      ,[Incident_Transaction_GUID_Internal]
      ,[CAD_Incident_ID_Internal]
      ,[CAD_ID_FK] -- joins [DwEms].[Dim_EMS_CAD] ([Dim_CAD_PK])

      ,[CAD_ID1_FK] -- no explicit join in datamart_ems.sql
      ,[CAD_Incident_ID1_Internal]

      ,[Dim_Agency_FK] -- joins [DwEms].[Dim_Agency] ([Dim_Agency_PK])
      ,[Dim_Airway_FK] -- joins [DwEms].[Dim_Airway] ([Dim_Airway_PK])
      ,[Dim_CardiacArrest_FK] -- joins [DwEms].[Dim_CardiacArrest] ([Dim_Cardiac_Arrest_PK])
      ,[Dim_Disposition_FK] -- joins [DwEms].[Dim_Disposition] ([Dim_Disposition_PK])
      ,[Dim_Incident_FK] -- joins [DwEms].[Dim_Incident] ([Dim_Incident_PK])
      ,[Dim_Patient_FK] -- joins [DwEms].[Dim_Patient] ([Dim_Patient_PK])
      ,[Dim_Response_FK] -- joins [DwEms].[Dim_Response] ([Dim_Response_PK])
      ,[Dim_Scene_FK] -- joins [DwEms].[Dim_Scene] ([Dim_Scene_PK])
      ,[Dim_Situation_FK] -- joins [DwEms].[Dim_Situation] ([Dim_Situation_PK])
      ,[Dim_VitalsHighLowInitLast_FK] -- joins [DwEms].[Dim_VitalsHighLowInitLast] ([Dim_VitalsHighLowInitLast_PK])
      ,[Dim_Outcome_FK] -- joins [DwEms].[Dim_Outcome] ([Dim_Outcome_PK])
      ,[Dim_PatientHistory_FK] -- joins [DwEms].[Dim_PatientHistory] ([Dim_PatientHistory_PK])
      ,[Dim_Payment_FK] -- joins [DwEms].[Dim_Payment] ([Dim_Payment_PK])
      ,[Dim_InjuryDetails_FK] -- joins [DwEms].[Dim_InjuryDetails] ([Dim_Injury_Details_PK])
      ,[Dim_Incident_Date_FK] -- joins [dbo].[DSV_Dim_Incident_Date] ([Dim_Incident_Date_FK])
      ,[Dim_Incident_TimeOfDay_FK] -- joins [dbo].[DSV_Dim_Incident_Time_Of_Day] ([Dim_Incident_Time_Of_Day_PK])


      ,[Dim_PatientFluids_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_PSAP_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_PSAP_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Dispatch_Notified_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Dispatch_Notified_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Notified_By_Dispatch_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Notified_By_Dispatch_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Dispatch_Acknowledged_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Dispatch_Acknowledged_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Enroute_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Enroute_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Arrived_On_Scene_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Arrived_On_Scene_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Arrived_At_Patient_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Arrived_At_Patient_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Transfer_Of_Patient_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Transfer_Of_Patient_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Left_Scene_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Left_Scene_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Arrival_At_Destination_Landing_Area_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Arrival_At_Destination_Landing_Area_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Patient_Arrived_At_Destination_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Patient_Arrived_At_Destination_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Destination_Patient_Transfer_Of_Care_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Destination_Patient_Transfer_Of_Care_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Back_In_Service_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Back_In_Service_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Canceled_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Canceled_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Back_At_Home_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Unit_Back_At_Home_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_EMS_Call_Completed_Date_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_EMS_Call_Completed_TimeOfDay_FK] -- no explicit join in datamart_ems.sql
      ,[Dim_Narrative_FK] -- joins [DwEms].[Dim_Narrative] ([Dim_Narrative_PK])
      ,[Dim_Incident_One_To_One_PK] -- joins [DwEms].[Dim_Incident_One_To_One] ([Dim_Incident_One_To_One_PK])
      ,[Dim_IncidentSupplementalQuestions_FK] -- joins [DwEms].[Dim_IncidentSupplementalQuestions] ([Dim_IncidentSupplementalQuestions_PK])
      ,[Dim_IncidentSupplementalQuestions1_FK] -- joins [DwEms].[Dim_IncidentSupplementalQuestions1] ([Dim_IncidentSupplementalQuestions1_PK])
      ,[Dim_IncidentSupplementalQuestions2_FK] -- joins [DwEms].[Dim_IncidentSupplementalQuestions2] ([Dim_IncidentSupplementalQuestions2_PK])

      ,[Incident_Agency_Short_Name]
      ,[Incident_Form_Number]
      ,[Incident_Validity_Score]

      ,[Patient_Age_In_Years]
      ,[Patient_Age_In_Months]
      ,[Patient_Age_In_Weeks]
      ,[Patient_Age_In_Days]
      ,[Patient_Weight_In_Kilograms]
      ,[Patient_Weight_In_Pounds]

      -- Target times (these are not used, but are included for completeness)
      ,[Incident_UnitArrivedAtPatient_To_PatientArrivedAtDestination_In_Seconds]
      ,[Incident_UnitArrivedAtPatient_To_PatientArrivedAtDestination_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_UnitEnRoute_In_Seconds]
      ,[Incident_UnitNotifiedByDispatch_To_UnitEnRoute_In_Minutes]
      ,[Incident_PSAPCall_To_UnitNotifiedByDispatch_In_Seconds]
      ,[Incident_PSAPCall_To_UnitNotifiedByDispatch_In_Minutes]
      ,[Incident_UnitEnRoute_To_UnitArrivedOnScene_In_Seconds]
      ,[Incident_UnitEnRoute_To_UnitArrivedOnScene_In_Minutes]
      ,[Incident_UnitArrivedOnScene_To_UnitLeftScene_In_Seconds]
      ,[Incident_UnitArrivedOnScene_To_UnitLeftScene_In_Minutes]
      ,[Incident_UnitArrivedOnScene_To_UnitArrivedAtPatient_In_Seconds]
      ,[Incident_UnitArrivedOnScene_To_UnitArrivedAtPatient_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_UnitArrivedOnScene_In_Seconds]
      ,[Incident_UnitNotifiedByDispatch_To_UnitArrivedOnScene_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_UnitBackInService_In_Seconds]
      ,[Incident_UnitNotifiedByDispatch_To_UnitBackInService_In_Minutes]
      ,[Incident_UnitLeftScene_To_PatientArrivedAtDestination_In_Seconds]
      ,[Incident_UnitLeftScene_To_PatientArrivedAtDestination_In_Minutes]
      ,[Incident_PatientArrivedAtDestination_To_UnitBackInService_In_Seconds]
      ,[Incident_PatientArrivedAtDestination_To_UnitBackInService_In_Minutes]
      ,[Incident_SymptomOnset_To_UnitArrivedAtPatient_In_Seconds]
      ,[Incident_SymptomOnset_To_UnitArrivedAtPatient_In_Minutes]
      ,[Incident_SymptomOnset_To_PatientArrivedAtDestination_In_Seconds]
      ,[Incident_SymptomOnset_To_PatientArrivedAtDestination_In_Minutes]
      ,[Incident_SymptomOnset_To_PSAPCall_In_Seconds]
      ,[Incident_SymptomOnset_To_PSAPCall_In_Minutes]
      ,[Incident_SymptomOnset_To_UnitArrivedOnScene_In_Seconds]
      ,[Incident_SymptomOnset_To_UnitArrivedOnScene_In_Minutes]
      ,[Incident_Time_To_Destination_In_Minutes]
      ,[Incident_PSAPCall_To_DispatchNotified_In_Seconds]
      ,[Incident_PSAPCall_To_DispatchNotified_In_Minutes]
      ,[Incident_PSAPCall_To_UnitArrivedOnScene_In_Seconds]
      ,[Incident_PSAPCall_To_UnitArrivedOnScene_In_Minutes]
      ,[Incident_PSAPCall_To_UnitArrivedAtPatient_In_Seconds]
      ,[Incident_PSAPCall_To_UnitArrivedAtPatient_In_Minutes]
      ,[Incident_DispatchNotified_To_UnitNotifiedByDispatch_In_Seconds]
      ,[Incident_DispatchNotified_To_UnitNotifiedByDispatch_In_Minutes]
      ,[Incident_DispatchNotified_To_UnitEnRoute_In_Seconds]
      ,[Incident_DispatchNotified_To_UnitEnRoute_In_Minutes]
      ,[Incident_DispatchNotified_To_UnitCancelled_In_Seconds]
      ,[Incident_DispatchNotified_To_UnitCancelled_In_Minutes]
      ,[Incident_DispatchNotified_To_UnitArrivedOnScene_In_Seconds]
      ,[Incident_DispatchNotified_To_UnitArrivedOnScene_In_Minutes]
      ,[Incident_DispatchNotified_To_UnitArrivedAtPatient_In_Seconds]
      ,[Incident_DispatchNotified_To_UnitArrivedAtPatient_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_UnitCancelled_In_Seconds]
      ,[Incident_UnitNotifiedByDispatch_To_UnitCancelled_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_PatientArrivedAtDestination_In_Seconds]
      ,[Incident_UnitNotifiedByDispatch_To_PatientArrivedAtDestination_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_UnitBackAtHome_In_Seconds]
      ,[Incident_UnitNotifiedByDispatch_To_UnitBackAtHome_In_Minutes]
      ,[Incident_UnitEnRoute_To_UnitCancelled_In_Seconds]
      ,[Incident_UnitEnRoute_To_UnitCancelled_In_Minutes]
      ,[Incident_UnitEnRoute_To_UnitBackInService_In_Seconds]
      ,[Incident_UnitEnRoute_To_UnitBackInService_In_Minutes]
      ,[Incident_UnitCancelled_To_UnitBackInService_In_Seconds]
      ,[Incident_UnitCancelled_To_UnitBackInService_In_Minutes]
      ,[Incident_UnitCancelled_To_UnitBackAtHome_In_Seconds]
      ,[Incident_UnitCancelled_To_UnitBackAtHome_In_Minutes]
      ,[Incident_UnitArrivedOnScene_To_PatientArrivedAtDestination_In_Seconds]
      ,[Incident_UnitArrivedOnScene_To_PatientArrivedAtDestination_In_Minutes]
      ,[Incident_UnitArrivedAtPatient_To_UnitLeftScene_In_Seconds]
      ,[Incident_UnitArrivedAtPatient_To_UnitLeftScene_In_Minutes]
      ,[Incident_PatientArrivedAtDestination_To_UnitDepartedBedside_In_Seconds]
      ,[Incident_PatientArrivedAtDestination_To_UnitDepartedBedside_In_Minutes]
      ,[Incident_PatientArrivedAtDestination_To_UnitLeftDestination_In_Seconds]
      ,[Incident_PatientArrivedAtDestination_To_UnitLeftDestination_In_Minutes]
      ,[Incident_UnitDepartedBedside_To_UnitLeftDestination_In_Seconds]
      ,[Incident_UnitDepartedBedside_To_UnitLeftDestination_In_Minutes]
      ,[Incident_UnitDepartedBedside_To_UnitBackInService_In_Seconds]
      ,[Incident_UnitDepartedBedside_To_UnitBackInService_In_Minutes]
      ,[Incident_UnitDepartedBedside_To_UnitBackAtHome_In_Seconds]
      ,[Incident_UnitDepartedBedside_To_UnitBackAtHome_In_Minutes]
      ,[Incident_UnitLeftDestination_To_UnitBackInService_In_Seconds]
      ,[Incident_UnitLeftDestination_To_UnitBackInService_In_Minutes]
      ,[Incident_UnitLeftDestination_To_UnitBackAtHome_In_Seconds]
      ,[Incident_UnitLeftDestination_To_UnitBackAtHome_In_Minutes]
      ,[Incident_UnitBackInService_To_UnitBackAtHome_In_Seconds]
      ,[Incident_UnitBackInService_To_UnitBackAtHome_In_Minutes]
      ,[Incident_UnitArrivedAtPatient_To_PatientArrivedAtDestination_In_HHMMSS]
      ,[Incident_UnitNotifiedByDispatch_To_UnitEnRoute_In_HHMMSS]
      ,[Incident_PSAPCall_To_UnitNotifiedByDispatch_In_HHMMSS]
      ,[Incident_UnitEnRoute_To_UnitArrivedOnScene_In_HHMMSS]
      ,[Incident_UnitArrivedOnScene_To_UnitLeftScene_In_HHMMSS]
      ,[Incident_UnitArrivedOnScene_To_UnitArrivedAtPatient_In_HHMMSS]
      ,[Incident_UnitNotifiedByDispatch_To_UnitArrivedOnScene_In_HHMMSS]
      ,[Incident_UnitNotifiedByDispatch_To_UnitBackInService_In_HHMMSS]
      ,[Incident_UnitLeftScene_To_PatientArrivedAtDestination_In_HHMMSS]
      ,[Incident_PatientArrivedAtDestination_To_UnitBackInService_In_HHMMSS]
      ,[Incident_SymptomOnset_To_UnitArrivedAtPatient_In_HHMMSS]
      ,[Incident_SymptomOnset_To_PatientArrivedAtDestination_In_HHMMSS]
      ,[Incident_SymptomOnset_To_PSAPCall_In_HHMMSS]
      ,[Incident_SymptomOnset_To_UnitArrivedOnScene_In_HHMMSS]
      ,[Incident_PSAPCall_To_DispatchNotified_In_HHMMSS]
      ,[Incident_PSAPCall_To_UnitArrivedOnScene_In_HHMMSS]
      ,[Incident_PSAPCall_To_UnitArrivedAtPatient_In_HHMMSS]
      ,[Incident_DispatchNotified_To_UnitNotifiedByDispatch_In_HHMMSS]
      ,[Incident_DispatchNotified_To_UnitEnRoute_In_HHMMSS]
      ,[Incident_DispatchNotified_To_UnitCancelled_In_HHMMSS]
      ,[Incident_DispatchNotified_To_UnitArrivedOnScene_In_HHMMSS]
      ,[Incident_DispatchNotified_To_UnitArrivedAtPatient_In_HHMMSS]
      ,[Incident_UnitNotifiedByDispatch_To_UnitCancelled_In_HHMMSS]
      ,[Incident_UnitNotifiedByDispatch_To_PatientArrivedAtDestination_In_HHMMSS]
      ,[Incident_UnitNotifiedByDispatch_To_UnitBackAtHome_In_HHMMSS]
      ,[Incident_UnitEnRoute_To_UnitCancelled_In_HHMMSS]
      ,[Incident_UnitEnRoute_To_UnitBackInService_In_HHMMSS]
      ,[Incident_UnitCancelled_To_UnitBackInService_In_HHMMSS]
      ,[Incident_UnitCancelled_To_UnitBackAtHome_In_HHMMSS]
      ,[Incident_UnitArrivedOnScene_To_PatientArrivedAtDestination_In_HHMMSS]
      ,[Incident_UnitArrivedAtPatient_To_UnitLeftScene_In_HHMMSS]
      ,[Incident_PatientArrivedAtDestination_To_UnitDepartedBedside_In_HHMMSS]
      ,[Incident_PatientArrivedAtDestination_To_UnitLeftDestination_In_HHMMSS]
      ,[Incident_UnitDepartedBedside_To_UnitLeftDestination_In_HHMMSS]
      ,[Incident_UnitDepartedBedside_To_UnitBackInService_In_HHMMSS]
      ,[Incident_UnitDepartedBedside_To_UnitBackAtHome_In_HHMMSS]
      ,[Incident_UnitLeftDestination_To_UnitBackInService_In_HHMMSS]
      ,[Incident_UnitLeftDestination_To_UnitBackAtHome_In_HHMMSS]
      ,[Incident_UnitBackInService_To_UnitBackAtHome_In_HHMMSS]
      ,[Incident_UnitNotifiedByDispatch_To_UnitEnRoute_Range_In_Minutes]
      ,[Incident_UnitEnRoute_To_UnitArrivedOnScene_Range_In_Minutes]
      ,[Incident_UnitArrivedOnScene_To_UnitLeftScene_Range_In_Minutes]
      ,[Incident_UnitLeftScene_To_PatientArrivedAtDestination_Range_In_Minutes]
      ,[Incident_PatientArrivedAtDestination_To_UnitLeftDestination_Range_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_UnitEnRoute_Range_In_Minutes_Sort_Order]
      ,[Incident_UnitEnRoute_To_UnitArrivedOnScene_Range_In_Minutes_Sort_Order]
      ,[Incident_UnitArrivedOnScene_To_UnitLeftScene_Range_In_Minutes_Sort_Order]
      ,[Incident_UnitLeftScene_To_PatientArrivedAtDestination_Range_In_Minutes_Sort_Order]
      ,[Incident_PatientArrivedAtDestination_To_UnitLeftDestination_Range_In_Minutes_Sort_Order]
      ,[Destination_Adult_Trauma_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_Adult_Trauma_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Destination_Cardiac_Arrest_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_Cardiac_Arrest_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Destination_Obstetrics_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_Obstetrics_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Destination_Other_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_Other_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Destination_Pediatric_Trauma_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_Pediatric_Trauma_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Destination_STEMI_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_STEMI_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Destination_Stroke_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_Stroke_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Destination_Trauma_General_Team_Alert_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Destination_Trauma_General_Team_Alert_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[PSAP_To_First_Defibrillation_In_Minutes]
      ,[PSAP_To_First_Defibrillation_In_Seconds]
      ,[Dispatch_Notified_To_First_Defibrillation_In_Minutes]
      ,[Dispatch_Notified_To_First_Defibrillation_In_Seconds]
      ,[Unit_Arrived_On_Scene_To_First_12_Lead_ECG_Vitals_Reading_In_Minutes]
      ,[Unit_Arrived_On_Scene_To_First_12_Lead_ECG_Vitals_Reading_In_Seconds]
      ,[Unit_Arrived_On_Scene_To_First_12_Lead_Procedure_In_Minutes]
      ,[Unit_Arrived_On_Scene_To_First_12_Lead_Procedure_In_Seconds]
      ,[Incident_PSAPCall_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_PSAPCall_To_IncidentRecordCreated_In_Hours]
      ,[Incident_DispatchNotified_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_DispatchNotified_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitNotifiedByDispatch_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitNotifiedByDispatch_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitEnRoute_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitEnRoute_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitCancelled_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitCancelled_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitArrivedOnScene_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitArrivedOnScene_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitArrivedAtPatient_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitArrivedAtPatient_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitLeftScene_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitLeftScene_To_IncidentRecordCreated_In_Hours]
      ,[Incident_PatientArrivedAtDestination_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_PatientArrivedAtDestination_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitDepartedBedside_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitDepartedBedside_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitLeftDestination_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitLeftDestination_To_IncidentRecordCreated_In_Hours]
      ,[Incident_UnitBackInService_To_IncidentRecordCreated_In_Minutes]
      ,[Incident_UnitBackInService_To_IncidentRecordCreated_In_Hours]
      ,[Incident_Dispatch_Notified_To_Unit_Notified_By_Dispatch_Range_In_Minutes]
      ,[Incident_Patient_Arrived_At_Destination_To_Unit_Back_In_Service_Range_In_Minutes]
      ,[Incident_PSAP_Call_To_Dispatch_Notified_Range_In_Seconds]
      ,[Incident_PSAP_Call_To_Unit_Arrived_On_Scene_Range_In_Minutes]
      ,[Incident_PSAP_Call_To_Unit_Arrived_At_Patient_Range_In_Minutes]
      ,[Incident_PSAP_Call_To_Unit_Notified_By_Dispatch_Range_In_Minutes]
      ,[Incident_Unit_Arrived_At_Patient_to_Patient_Arrived_At_Destination_Range_In_Minutes]
      ,[Incident_Unit_Notified_By_Dispatch_to_Unit_Arrived_On_Scene_Range_In_Minutes]
      ,[Incident_Unit_Notified_By_Dispatch_to_Unit_Cancelled_Range_In_Minutes]
      ,[Incident_Dispatch_Notified_To_Unit_Notified_By_Dispatch_Range_In_Minutes_Sort_Order]
      ,[Incident_Patient_Arrived_At_Destination_To_Unit_Back_In_Service_Range_In_Minutes_Sort_Order]
      ,[Incident_PSAP_Call_To_Dispatch_Notified_Range_In_Seconds_Sort_Order]
      ,[Incident_PSAP_Call_To_Unit_Arrived_On_Scene_Range_In_Minutes_Sort_Order]
      ,[Incident_PSAP_Call_To_Unit_Arrived_At_Patient_Range_In_Minutes_Sort_Order]
      ,[Incident_PSAP_Call_To_Unit_Notified_By_Dispatch_Range_In_Minutes_Sort_Order]
      ,[Incident_Unit_Arrived_At_Patient_to_Patient_Arrived_At_Destination_Range_In_Minutes_Sort_Order]
      ,[Incident_Unit_Notified_By_Dispatch_to_Unit_Arrived_On_Scene_Range_In_Minutes_Sort_Order]
      ,[Incident_Unit_Notified_By_Dispatch_to_Unit_Cancelled_Range_In_Minutes_Sort_Order]
      ,[Incident_Patient_Arrived_at_Destination_To_Destination_Patient_Transfer_Of_Care_In_Minutes]
      ,[Incident_Patient_Arrived_at_Destination_To_Destination_Patient_Transfer_Of_Care_In_Hours]
      ,[Incident_Patient_Arrived_At_Destination_To_Unit_Departed_Bedside_Range_In_Minutes]
      ,[Incident_Patient_Arrived_at_Destination_To_Destination_Patient_Transfer_Of_Care_Range_In_Minutes]
      ,[Incident_Patient_Arrived_At_Destination_To_Unit_Departed_Bedside_Range_In_Minutes_Sort_Order]
      ,[Incident_Patient_Arrived_at_Destination_To_Destination_Patient_Transfer_Of_Care_Range_In_Minutes_Sort_Order]
      ,[Incident_Hours_To_Enter_Record]
      ,[Incident_Minutes_To_Enter_Record]
      ,[Incident_Days_To_Enter_Record]
      ,[Cardiac_Arrest_Estimated_Time_From_Arrest_To_Defibrillation]
      ,[Cardiac_Arrest_Time_Of_Arrest_Prior_To_CPR_In_Minutes]
      ,[Cardiac_Arrest_Time_From_Prior_CPR_To_ALS_In_Minutes]
      ,[Outcome_First_ED_Systolic_Blood_Pressure]
      ,[Outcome_Total_ICU_Length_Of_Stay_In_Patient_Days]
      ,[Outcome_Total_Patient_Days_Spent_On_Ventilator]
      ,[Patient_Initial_Positive_Stroke_Score_To_Stroke_Alert_In_Minutes]
      ,[Patient_Initial_Positive_Stroke_Score_To_Stroke_Alert_In_Seconds]
      ,[Incident_Patient_Last_Known_Well_To_Patient_Arrived_At_Destination_In_Seconds]
      ,[Incident_Patient_Last_Known_Well_To_Patient_Arrived_At_Destination_In_Minutes]
      ,[Unit_Arrived_At_Patient_To_First_12_Lead_Procedure_In_Minutes]
      ,[Unit_Arrived_At_Patient_To_First_12_Lead_Procedure_In_Seconds]
      ,[Unit_Arrived_At_Patient_To_First_12_Lead_ECG_Vitals_Reading_In_Minutes]
      ,[Unit_Arrived_At_Patient_To_First_12_Lead_ECG_Vitals_Reading_In_Seconds]
      ,[CA_APOT_Incident_Patient_Arrived_at_Destination_To_Destination_Patient_Transfer_Of_Care_Range_In_Minutes]
      ,[CA_APOT_Incident_Patient_Arrived_at_Destination_To_Destination_Patient_Transfer_Of_Care_In_Minutes_Sort_Order]


    --   ,[System_ID] -- IGNORE
      ,[ModifiedOn]
      ,[CreatedOn]

      ,[Response_Vehicle_Distance_Begin_To_Scene]
      ,[Response_Vehicle_Distance_Scene_To_Destination]
      ,[Response_Vehicle_Distance_Destination_To_End]
      ,[Response_Vehicle_Total_Distance_Begin_To_End]

      ,[Disposition_Number_Of_Patients_Transported_In_EMS_Unit]
      ,[Injury_Height_Of_Fall_In_Feet]
      ,[Injury_Height_Of_Fall_In_Meters]
      ,[print_report_template_id]

      ,[Incident_Elite_Viewer_Facility_ID_Internal]
      ,[Incident_Elite_Viewer_State_County_GNIS]
      ,[Incident_Elite_Viewer_City_GNIS]

      ,[AreaOfOperation_ID]
      ,[Incident_HIH_Patient_Searched]
      ,[Incident_HIH_Patient_Match_Found]
      ,[Incident_HIH_Patient_Downloaded]
      ,[Incident_Patient_Came_From_HIH]
      ,[Incident_HIH_POLST_Searched]
      ,[Incident_HIH_POLST_Downloaded]
      ,[Incident_HIH_POLST_Came_From_HIH]
      ,[Reporting_Standard]
      ,[Reporting_Standard_ID]
  FROM [Elite_DWPortland].[DwEms].[Fact_Incident]