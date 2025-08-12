 ## List of ALL EMS Tables

 These are the EMS-related tables/views referenced by `Fact_Incident` foreign keys (from `datamart_ems.sql`). This is the minimal set we care about:

 - `DwEms.Fact_Incident` — fact table for EMS incidents
 - `DwEms.Dim_Agency`
 - `DwEms.Dim_Airway`
 - `DwEms.Dim_CardiacArrest`
 - `DwEms.Dim_Disposition`
 - `DwEms.Dim_Incident`
 - `DwEms.Dim_Patient`
 - `DwEms.Dim_Response`
 - `DwEms.Dim_Scene`
 - `DwEms.Dim_Situation`
 - `DwEms.Dim_VitalsHighLowInitLast`
 - `DwEms.Dim_Outcome`
 - `DwEms.Dim_PatientHistory`
 - `DwEms.Dim_Payment`
 - `DwEms.Dim_InjuryDetails`
 - `DwEms.Dim_Narrative`
 - `DwEms.Dim_Incident_One_To_One`
 - `DwEms.Dim_EMS_CAD` — CAD dimension (FULL JOIN in datamart)
 - `DwEms.Dim_IncidentSupplementalQuestions`
 - `DwEms.Dim_IncidentSupplementalQuestions1`
 - `DwEms.Dim_IncidentSupplementalQuestions2`
 - `dbo.DSV_Dim_Incident_Date` — surrogate view for incident date FKs
 - `dbo.DSV_Dim_Incident_Time_Of_Day` — surrogate view for incident time-of-day FKs

 ### Direct FK column -> Dimension (PK)
 - `Dim_Agency_FK` -> `DwEms.Dim_Agency` (`Dim_Agency_PK`)
 - `Dim_Airway_FK` -> `DwEms.Dim_Airway` (`Dim_Airway_PK`)
 - `Dim_CardiacArrest_FK` -> `DwEms.Dim_CardiacArrest` (`Dim_Cardiac_Arrest_PK`)
 - `Dim_Disposition_FK` -> `DwEms.Dim_Disposition` (`Dim_Disposition_PK`)
 - `Dim_Incident_FK` -> `DwEms.Dim_Incident` (`Dim_Incident_PK`)
 - `Dim_Patient_FK` -> `DwEms.Dim_Patient` (`Dim_Patient_PK`)
 - `Dim_Response_FK` -> `DwEms.Dim_Response` (`Dim_Response_PK`)
 - `Dim_Scene_FK` -> `DwEms.Dim_Scene` (`Dim_Scene_PK`)
 - `Dim_Situation_FK` -> `DwEms.Dim_Situation` (`Dim_Situation_PK`)
 - `Dim_VitalsHighLowInitLast_FK` -> `DwEms.Dim_VitalsHighLowInitLast` (`Dim_VitalsHighLowInitLast_PK`)
 - `Dim_Outcome_FK` -> `DwEms.Dim_Outcome` (`Dim_Outcome_PK`)
 - `Dim_PatientHistory_FK` -> `DwEms.Dim_PatientHistory` (`Dim_PatientHistory_PK`)
 - `Dim_Payment_FK` -> `DwEms.Dim_Payment` (`Dim_Payment_PK`)
 - `Dim_InjuryDetails_FK` -> `DwEms.Dim_InjuryDetails` (`Dim_Injury_Details_PK`)
 - `Dim_Narrative_FK` -> `DwEms.Dim_Narrative` (`Dim_Narrative_PK`)
 - `Dim_Incident_One_To_One_PK` -> `DwEms.Dim_Incident_One_To_One` (`Dim_Incident_One_To_One_PK`)
 - `Dim_IncidentSupplementalQuestions_FK` -> `DwEms.Dim_IncidentSupplementalQuestions` (`Dim_IncidentSupplementalQuestions_PK`)
 - `Dim_IncidentSupplementalQuestions1_FK` -> `DwEms.Dim_IncidentSupplementalQuestions1` (`Dim_IncidentSupplementalQuestions1_PK`)
 - `Dim_IncidentSupplementalQuestions2_FK` -> `DwEms.Dim_IncidentSupplementalQuestions2` (`Dim_IncidentSupplementalQuestions2_PK`)
 - `Dim_Incident_Date_FK` -> `dbo.DSV_Dim_Incident_Date` (`Dim_Incident_Date_FK`)
 - `Dim_Incident_TimeOfDay_FK` -> `dbo.DSV_Dim_Incident_Time_Of_Day` (`Dim_Incident_Time_Of_Day_PK`)
 - `CAD_ID_FK` -> `DwEms.Dim_EMS_CAD` (`Dim_CAD_PK`) — FULL JOIN

 ### FKs with no explicit join in `datamart_ems.sql`
 - `Dim_PSAP_Date_FK`
 - `Dim_PSAP_TimeOfDay_FK`
 - `Dim_Dispatch_Notified_Date_FK`
 - `Dim_Dispatch_Notified_TimeOfDay_FK`
 - `Dim_Unit_Notified_By_Dispatch_Date_FK`
 - `Dim_Unit_Notified_By_Dispatch_TimeOfDay_FK`
 - `Dim_Dispatch_Acknowledged_Date_FK`
 - `Dim_Dispatch_Acknowledged_TimeOfDay_FK`
 - `Dim_Unit_Enroute_Date_FK`
 - `Dim_Unit_Enroute_TimeOfDay_FK`
 - `Dim_Unit_Arrived_On_Scene_Date_FK`
 - `Dim_Unit_Arrived_On_Scene_TimeOfDay_FK`
 - `Dim_Arrived_At_Patient_Date_FK`
 - `Dim_Arrived_At_Patient_TimeOfDay_FK`
 - `Dim_Transfer_Of_Patient_Date_FK`
 - `Dim_Transfer_Of_Patient_TimeOfDay_FK`
 - `Dim_Unit_Left_Scene_Date_FK`
 - `Dim_Unit_Left_Scene_TimeOfDay_FK`
 - `Dim_Arrival_At_Destination_Landing_Area_Date_FK`
 - `Dim_Arrival_At_Destination_Landing_Area_TimeOfDay_FK`
 - `Dim_Patient_Arrived_At_Destination_Date_FK`
 - `Dim_Patient_Arrived_At_Destination_TimeOfDay_FK`
 - `Dim_Destination_Patient_Transfer_Of_Care_Date_FK`
 - `Dim_Destination_Patient_Transfer_Of_Care_TimeOfDay_FK`
 - `Dim_Unit_Back_In_Service_Date_FK`
 - `Dim_Unit_Back_In_Service_TimeOfDay_FK`
 - `Dim_Unit_Canceled_Date_FK`
 - `Dim_Unit_Canceled_TimeOfDay_FK`
 - `Dim_Unit_Back_At_Home_Date_FK`
 - `Dim_Unit_Back_At_Home_TimeOfDay_FK`
 - `Dim_EMS_Call_Completed_Date_FK`
 - `Dim_EMS_Call_Completed_TimeOfDay_FK`

 ### Other unmapped/ambiguous FKs
 - `CAD_ID1_FK` — no explicit join in `datamart_ems.sql`
 - `Dim_PatientFluids_FK` — no explicit join in `datamart_ems.sql`

 ### Related dimensions via bridge tables (not direct FKs)
 - `Bridge_Incident_Procedure` -> `Dim_Procedure`
 - `Bridge_Incident_Medication` -> `Dim_Medication`
 - `Bridge_Incident_Labs` -> `Dim_Labs`; plus `Bridge_Labs_LabsImageGroup` -> `Dim_LabsImageGroup`; `Bridge_Labs_LabsResultGroup` -> `Dim_LabsResultGroup`
 - `Bridge_Incident_Vitals` -> `Dim_Vitals`
 - `Bridge_Incident_PatientExam` -> `Dim_PatientExam`; plus `Bridge_PatientExam_*` -> `Dim_PatientExam*` group dimensions
 - `Bridge_Incident_CrewMember` -> `Dim_CrewMember`
 - `Bridge_Incident_Signature` -> `Dim_Signature`
 - `Bridge_Incident_Device` -> `Dim_Device`
 - `Bridge_Incident_IncidentStatus` -> `Dim_IncidentStatus`
 - `Bridge_Incident_WorksheetQuestions` -> `Dim_IncidentWorksheetQuestions`/`Dim_IncidentWorksheetQuestions1`/`Dim_IncidentWorksheetQuestions2`
 - `Bridge_Incident_WorksheetQuestionsFieldNotes` -> `Dim_IncidentWorksheetQuestionsFieldNotes`/`Dim_IncidentWorksheetQuestionsFieldNotes1`/`Dim_IncidentWorksheetQuestionsFieldNotes2`
 - `Bridge_Incident_MedicationOrdered` -> `Dim_MedicationOrdered`
 - `Bridge_Incident_Protocol` -> `Dim_Protocol`
 - `Bridge_Incident_ControlledSubstance` -> `Dim_ControlledSubstance`
 - `Bridge_Payment_PaymentInsuranceGroup` -> `Dim_PaymentInsuranceGroup`; `Bridge_Payment_PaymentSupplyItemGroup` -> `Dim_PaymentSupplyItemGroup`
 - `Bridge_Agency_AgencyServiceGroup` -> `Dim_AgencyServiceGroup`; `Bridge_Agency_AgencyYearGroup` -> `Dim_AgencyYearGroup`
 - `Bridge_Agency_AgencyNoEmsIncident` -> `Dim_AgencyNoEmsIncident`; `Bridge_Agency_AgencyNoFireIncident` -> `Dim_AgencyNoFireIncident`; `Bridge_Agency_AgencyNonFireRelatedIncidents` -> `Dim_AgencyNonFireRelatedIncidents`
 - `Bridge_Scene_SceneResponderGroup` -> `Dim_SceneResponderGroup`
 - `Bridge_Situation_SituationPatientComplaintGroup` -> `Dim_SituationPatientComplaintGroup`
 - `Bridge_InjuryDetails_InjuryDetailsDeltaVelocityGroup` -> `Dim_InjuryDetailsDeltaVelocityGroup`

 Notes:
 - This documentation reflects the joins in `REFERENCE/TABLES/EMS/datamart_ems.sql` in this repo.
 - The production database is read-only; these notes are for reporting join guidance only.
