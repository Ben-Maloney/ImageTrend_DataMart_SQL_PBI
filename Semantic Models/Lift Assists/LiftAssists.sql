/*
Lift Assists semantic model
- Fire reports filtered to QA27 = '5102' (Lifting Person to Bed or Chair- Facility)
- Agency filters:
    Fact_Fire.Agency_shortname = 'portlandfi'
    Dim_Fire_CAD.CAD_Basic_Incident_Agency_Name = 'Portland Fire & Rescue - EMS'
- CreatedOn date window applied on Fact_Fire.CreatedOn (adjust @StartDate/@EndDate as needed)
*/

DECLARE @StartDate DATETIME = DATEADD(DAY, -365, GETDATE());
DECLARE @EndDate   DATETIME = GETDATE();

SELECT
    -- FF.Fact_Fire_PK,
    FF.CreatedOn,
    FF.Agency_shortname,
    FF.Basic_Incident_Form_Number,

    -- DBasic.Dim_Basic_PK,
    DBasic.Basic_Incident_Number,
    DBasic.Basic_Incident_Date_Time,
    DBasic.Basic_Incident_Type_Code,
    DBasic.Basic_Incident_Type_Code_And_Description,
    DBasic.Basic_Incident_Full_Address,
    DBasic.Basic_Apparatus_Call_Sign_List,
    DBasic.Basic_Incident_First_Unit_Arrived_Date_Time,
    DBasic.Basic_Incident_Primary_Narrative,

    -- CAD.Dim_Fire_CAD_PK,
    -- CAD.CAD_CAD_ID            AS RP_Number,
    -- CAD.CAD_Basic_Incident_Agency_Name,

    QA27_Value = S0.QA27,
    QA28_UnitRoom = S0.QA28,
    QA29_FacilityRP = S0.QA29,

    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident'
        + CONVERT(VARCHAR(255), FF.Incident_ID_Internal)
        + '/Form'
        + CONVERT(VARCHAR(255), FF.Basic_Incident_Form_Number) AS fire_link


FROM [Elite_DWPortland].[DwFire].[Fact_Fire] AS FF
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] AS DBasic
    ON DBasic.[Dim_Basic_PK] = FF.[Dim_Basic_FK]
-- LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_Fire_CAD] AS CAD
    -- ON CAD.[Dim_Fire_CAD_PK] = FF.[CAD_ID_FK]
LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_FireSupplementalQuestions] AS S0
    ON S0.[Dim_FireSupplementalQuestions_PK] = FF.[Dim_FireSupplementalQuestions_FK]
WHERE
    FF.[Agency_shortname] = 'portlandfi'
    -- AND CAD.[CAD_Basic_Incident_Agency_Name] = 'Portland Fire & Rescue - EMS'
    AND FF.[CreatedOn] >= @StartDate
    AND FF.[CreatedOn] <  DATEADD(DAY, 1, @EndDate)
    AND (
        S0.QA27 LIKE '5102%'
        OR DBasic.Basic_Incident_Type_Code = '5102'
        OR DBasic.Basic_Incident_Type_Code_And_Description LIKE '5102%'
    )
ORDER BY DBasic.Basic_Incident_Date_Time DESC;
