## List of ALL Fire Tables

These are the Fire-related tables/views referenced by `Fact_Fire` foreign keys (from `datamart_fire.sql`). This is the minimal set we care about:

- `DwFire.Fact_Fire` — fact table for NFIRS fire reports
- `DwFire.Dim_Basic` — basic incident details
- `DwFire.Dim_Fire` — fire module details
- `DwFire.Dim_StructureFire` — structure fire details
- `DwFire.Dim_Arson` — arson details
- `DwFire.Dim_Wildland` — wildland fire details
- `DwEms.Dim_Agency` — agency dimension referenced by fire records
- `dbo.DSV_Dim_Incident_Date_Fire` — date surrogate view for fire incidents
- `dbo.DSV_Dim_Incident_Time_Of_Day_Fire` — time-of-day surrogate view for fire incidents
- `DwFire.Dim_Fire_CAD` — Fire CAD incident dimension
- `DwFire.Dim_ApparatusResources` — apparatus/resources dimension (e.g., `FirstApparatusArrived_*` FKs)

Notes:
- `CAD_ID1_FK` and `Dim_FireSupplementalQuestions*` exist in `Fact_Fire` but have no explicit join targets in `datamart_fire.sql` in this repo.