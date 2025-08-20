-- Base union of CAD + Fire Facts, preserving all rows from both sides
-- Fully-qualified DB and CreatedOn filter applied on both sides via CTEs

WITH f AS (
  SELECT f.*
  FROM [Elite_DWPortland].[DwFire].[Fact_Fire] AS f
  WHERE f.[CreatedOn] >= '2025-01-01'
    AND f.[Agency_shortname] = 'portlandfi'
),
d AS (
  SELECT d.*
  FROM [Elite_DWPortland].[DwFire].[Dim_Fire_CAD] AS d
  WHERE d.[CreatedOn] >= '2025-01-01'
    AND d.[CAD_Basic_Incident_Agency_Name] = 'Portland Fire & Rescue - EMS'
)
SELECT
  COALESCE(f.[CAD_ID_FK], d.[Dim_Fire_CAD_PK]) AS CAD_Key,
  CASE WHEN f.[Fact_Fire_PK] IS NOT NULL THEN 1 ELSE 0 END AS Has_Fact_Fire,
  CASE WHEN d.[Dim_Fire_CAD_PK] IS NOT NULL THEN 1 ELSE 0 END AS Has_Dim_Fire_CAD,
  CASE
    WHEN f.[Fact_Fire_PK] IS NOT NULL AND d.[Dim_Fire_CAD_PK] IS NOT NULL THEN 'Both'
    WHEN f.[Fact_Fire_PK] IS NOT NULL THEN 'Fact only'
    WHEN d.[Dim_Fire_CAD_PK] IS NOT NULL THEN 'CAD only'
  END AS Row_Source,
  f.*,
  d.*
FROM f
FULL OUTER JOIN d
  ON f.[CAD_ID_FK] = d.[Dim_Fire_CAD_PK]
;