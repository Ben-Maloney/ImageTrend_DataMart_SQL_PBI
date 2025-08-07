/*
########################################################################################
DATE: 2025-02-17
AUTHOR: Micah Fullerton
LICENSE: MIT License
DESCRIPTION:
    #TODO

CHANGE LOG:
    2025-02-17: created

########################################################################################
*/


SELECT
    'FIRE' AS report,
    Fact_Fire.CreatedOn AS created_on,

    CASE
        WHEN CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) > 0 
        THEN LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description, 
                CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) - 1)
        ELSE Dim_Fire.Fire_Initial_CAD_Incident_Type_Description 
    END as ProQA_Code,

    Fact_Fire.Agency_Shortname AS agency,
    dar.Apparatus_Personnel_Name_List AS crew_names, -- Individual crew names per apparatus

    --########################################################################################
    dap.Apparatus_Personnel_Full_Name AS personnel_name,
    dap.Apparatus_Personnel_Rank_Or_Grade AS personnel_rank,
    dap.Apparatus_Personnel_Role AS personnel_role,
    dap.Apparatus_Personnel_Badge_Number AS badge_number,
    --########################################################################################


    CASE
        -- let's make it explicit when the database is in a bad state
        WHEN Dim_Basic.Basic_Incident_Status IS NULL OR Dim_Basic.Basic_Incident_Status = '' THEN 'ErrorNoData'
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Documentation Finished' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Exported To State' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Edits Complete' THEN 'Finished'
        ELSE Dim_Basic.Basic_Incident_Status
    END AS status,

    'Exposure ' + CONVERT(VARCHAR(255), Dim_Basic.Basic_Exposure) AS unique_record_id,

    Dim_Basic.Basic_Incident_Alarm_Time AS alarm_time,
    Dim_Basic.Basic_Incident_Number AS RP,
    Dim_Fire.Fire_Initial_CAD_Incident_Type_Description AS 'EMD - desc',
    dar.Apparatus_Resource_Vehicle_Call_Sign AS 'Responding Units', -- Individual apparatus
    Dim_Basic.Basic_Apparatus_Call_Sign_List AS 'All Responding Units', -- Full list of apparatus
    Dim_Basic.Basic_Shift_Or_Platoon AS shift,

    CASE
        WHEN COALESCE(Dim_Basic.Basic_Primary_Station_Name, '') = '' THEN '?'
        ELSE Dim_Basic.Basic_Primary_Station_Name
    END AS FMA, -- TODO: '?' means that ImageTrend is unable to determine the FMA - this needs to be fixed as it has been misconfigured since we moved from FIS to ITE

    Dim_Basic.Basic_Incident_Full_Address AS address,
    Dim_Basic.Basic_Authorization_Member_Making_Report_Name AS 'author',


    Fact_Fire.Basic_Incident_Form_Number AS form_number,

    -- URL link
    Fact_Fire.Incident_ID_Internal AS url_incident,
    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident'
        + CONVERT(VARCHAR(255), Fact_Fire.Incident_ID_Internal)
        + '/Form'
        + CONVERT(VARCHAR(255), Fact_Fire.Basic_Incident_Form_Number) AS link


FROM [Elite_DWPortland].[DwFire].[Fact_Fire]
INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Fire] ON Fact_Fire.Dim_Fire_FK = Dim_Fire.Dim_Fire_PK


JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ApparatusResources] bfar 
    ON Fact_Fire.Fact_Fire_PK = bfar.Fact_Fire_PK

JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] dar 
    ON bfar.Dim_ApparatusResources_PK = dar.Dim_ApparatusResources_PK


JOIN [Elite_DWPortland].[DwFire].[Bridge_ApparatusResources_ApparatusPersonnel] brap 
    ON dar.Dim_ApparatusResources_PK = brap.Dim_ApparatusResources_PK
JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusPersonnel] dap 
    ON brap.Dim_ApparatusPersonnel_PK = dap.Dim_ApparatusPersonnel_PK


WHERE
    Fact_Fire.CreatedOn >= '2024-08-19'
    AND Fact_Fire.Agency_shortname = 'portlandfi'
    --AND Dim_Basic.Basic_Authorization_Member_Making_Report_Name IS NULL


    -- NACHO UNITS!
    --AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHAT%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'PSR%'
    -- AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'M%' -- this will exclude MC9 :(
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[M][0-9]%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[B][0-9]%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'LZ%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHS%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'MCCL%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'MS%'

    -- AIRPORT FIRE
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'C8%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'NOPDX%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'NOBOEC%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E80%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'R82%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'INFO%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'RB80%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'VA%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CC%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'D3%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'LO%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'TV%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'TIPF%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'POISON%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'INFFA1%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'EMS%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'FT%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E32%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU33%'

    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'S6%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E61%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU61%'

    --AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU33%' -- ????

    -- GRESHAM UNITS <3
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'C7%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'T71%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E71%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E72%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E73%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E75%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E76%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'R74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'RHB74%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'HR71%'
    AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'HS81%'
