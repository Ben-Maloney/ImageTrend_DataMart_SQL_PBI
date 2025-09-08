/*FOR Fire SUPPLEMENTAL QUESTIONS:*/
SELECT Question_Text, Answer_Table_Name, Answer_Column_Name,
Answer_Column_Number, Data_Type, Field_Definition_ID_Internal,
ActiveFlag FROM DwFire.Dim_FireSupplementalQuestions_RW_Mapping
where Question_Text IS NOT NULL
    AND Question_Text like '%Facility%'
ORDER BY 2 ASC;

/*FOR EMS SUPPLEMENTAL QUESTIONS:*/
-- SELECT *
-- SELECT Question_Text, Answer_Table_Name, Answer_Column_Name,
-- Answer_Column_Number, Data_Type, Field_Definition_ID_Internal, ActiveFlag
-- FROM Elite_DWPortland.DwEms.Dim_IncidentSupplementalQuestions_RW_Mapping
-- where Question_Text IS NOT NULL
--     AND Question_Text like '%Resident%'
-- ORDER BY 2 ASC;

/*FOR EMS CQI QUESTIONS*/
-- SELECT DISTINCT Question_Text,[CQI_Name], Answer_Table_Name, Answer_Column_Name,
-- Answer_Column_Number, Field_Definition_ID_Internal, ActiveFlag
-- FROM Elite_DWPortland.DwEms.Dim_CQISupplementalQuestions_RW_Mapping
--                 LEFT JOIN Elite_DWPortland.[DwEms].[Dim_CQICategory] ON [Dim_CQICategory].[CQI_Category_ID_Internal] = Dim_CQISupplementalQuestions_RW_Mapping.[CQI_Category_ID_Internal]
-- where Question_Text IS NOT NULL
--     AND Question_Text like '%flag%'
-- ORDER BY CQI_Name;

-- /*FOR EMS WORKSHEET QUESTIONS:*/
-- SELECT [Agency_Name],[Worksheet_Name],Question_Text, Answer_Table_Name, Answer_Column_Name,
-- Answer_Column_Number, Field_Definition_ID_Internal, ActiveFlag
-- FROM DwEms.Dim_IncidentWorksheetQuestions_RW_Mapping
-- where Question_Text IS NOT NULL
-- ORDER BY Worksheet_Name ASC;
