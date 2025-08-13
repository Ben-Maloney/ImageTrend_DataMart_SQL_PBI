SELECT TOP (1000) [ID_Internal]
      ,[IncidentNumber]
      ,[AgencyID]
      ,[BasicIncidentDatetime]
      ,[ApparatusNumber]
      ,[CreatedOn]
      ,[DeletedStatus]

  FROM [Elite_DWPortland].[DwFire].[Fact_Fire_Recon_CAD]

-- WHERE DeletedStatus <> NULL -- NOTE: They are all NULL as of 2025-08-13

ORDER BY ID_Internal DESC