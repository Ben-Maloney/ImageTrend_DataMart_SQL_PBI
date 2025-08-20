SELECT COUNT(*) AS CAD_Without_Facts
FROM DwFire.Dim_Fire_CAD d
LEFT JOIN DwFire.Fact_Fire f
  ON f.CAD_ID_FK = d.Dim_Fire_CAD_PK
WHERE f.Fact_Fire_PK IS NULL;