SELECT TOP (1000) [ID_Internal]
      ,[IncidentNumber]
      ,[AgencyID]
      ,[BasicIncidentDatetime]
      ,[ApparatusNumber]
      ,[IncludeParentFireCAD]
      ,[CreatedOn]
      ,[DeletedStatus]

  FROM [Elite_DWPortland].[DwFire].[Fact_Fire_Recon_Incident]

-- WHERE DeletedStatus <> NULL

ORDER BY ID_Internal DESC