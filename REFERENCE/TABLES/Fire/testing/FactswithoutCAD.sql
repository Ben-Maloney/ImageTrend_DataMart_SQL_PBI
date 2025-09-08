SELECT COUNT(*) AS Facts_Without_CAD
FROM DwFire.Fact_Fire f
LEFT JOIN DwFire.Dim_Fire_CAD d
  ON f.CAD_ID_FK = d.Dim_Fire_CAD_PK
WHERE d.Dim_Fire_CAD_PK IS NULL;