-- med_try2.sql

WITH ProceduresCTE AS (
    SELECT 
        Fact_Incident_PK,
        STRING_AGG(
            CONVERT(VARCHAR(MAX), 
                CASE 
                    WHEN Dim_Procedure.Procedure_Performed_Description NOT LIKE 'ECG - %' 
                    THEN Dim_Procedure.Procedure_Performed_Description 
                END
            ), ', ') AS proc_desc
    FROM [Elite_DWPortland].[DwEms].[Bridge_Incident_Procedure]
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Procedure]
        ON [Bridge_Incident_Procedure].[Dim_Procedure_PK] = [Dim_Procedure].[Dim_Procedure_PK]
    WHERE Dim_Procedure.Procedure_Performed_Description NOT LIKE 'ECG - %'
    GROUP BY Fact_Incident_PK
),


MedicationsCTE AS (
    SELECT
        Fact_Incident_PK,
        STRING_AGG(CONVERT(VARCHAR(MAX), Dim_Medication.Medication_Given_Description), ', ') AS meds_desc
    FROM [Elite_DWPortland].[DwEms].[Bridge_Incident_Medication]
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Medication]
        ON [Bridge_Incident_Medication].[Dim_Medication_PK] = [Dim_Medication].[Dim_Medication_PK]
    GROUP BY Fact_Incident_PK
)


SELECT
    Dim_Incident_One_To_One.Response_Incident_Number as RP_ems,
    Dim_Incident.Incident_PSAP_Call_Date_Time AS ems_time,
    Dim_Incident.Incident_EMD_Card_Number as 'EMD',
    Dim_Response.Response_EMS_Unit_Call_Sign AS 'ePCR unit',
    Dim_Disposition.Disposition_Patient_Evaluation_Care as 'Patient_Evaluation_Care',
    Dim_Disposition.Disposition_Transport_Disposition as 'Transport_Disposition',
    Dim_Narrative.Narrative,
    Dim_Patient.Patient_First_Name as 'FNAME',
    Dim_Patient.Patient_Last_Name as 'LNAME',

    p.proc_desc,
    m.meds_desc,
    Dim_Response.Response_EMS_Shift,

    Fact_Incident.Incident_Agency_Short_Name AS agency,
    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/EmsRunForm#/Incident'
        + CONVERT(VARCHAR(255), Fact_Incident.Incident_Transaction_GUID_Internal)
        + '/Form'
        + CONVERT(VARCHAR(255), Fact_Incident.Incident_Form_Number) AS ePCR_link




FROM [Elite_DWPortland].[DwEms].[Fact_Incident]
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One] 
        ON Fact_Incident.Dim_Incident_One_To_One_PK = Dim_Incident_One_To_One.Dim_Incident_One_To_One_PK
    INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident]
        ON Fact_Incident.Dim_Incident_FK = Dim_Incident.Dim_Incident_PK


    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Disposition] AS [Dim_Disposition] ON [Fact_Incident].[Dim_Disposition_FK] = [Dim_Disposition].[Dim_Disposition_PK]
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Response] ON Fact_Incident.Dim_Response_FK = Dim_Response.Dim_Response_PK
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Patient] AS [Dim_Patient] ON [Fact_Incident].[Dim_Patient_FK] = [Dim_Patient].[Dim_Patient_PK]
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Narrative] AS [Dim_Narrative] ON [Fact_Incident].[Dim_Narrative_FK] = [Dim_Narrative].[Dim_Narrative_PK]

    LEFT JOIN ProceduresCTE p
        ON Fact_Incident.Fact_Incident_PK = p.Fact_Incident_PK
    LEFT JOIN MedicationsCTE m
        ON Fact_Incident.Fact_Incident_PK = m.Fact_Incident_PK




WHERE
    Fact_Incident.Incident_Agency_Short_Name = 'portlandfi'
    AND Dim_Incident.Incident_PSAP_Call_Date_Time >= '2024-08-19'
    AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHS%'
    AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'CHAT%'
    AND Dim_Response.Response_EMS_Unit_Call_Sign NOT LIKE 'PSR%'
    AND (Dim_Patient.Patient_First_Name IS NOT NULL OR Dim_Patient.Patient_Last_Name IS NOT NULL)
