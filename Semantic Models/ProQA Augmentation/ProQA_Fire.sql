-- fire_try3.sql

WITH RankedArrivals AS (

SELECT
    Dim_Basic.Basic_Incident_Number AS RP_fire,
    Dim_Basic.Basic_Incident_Alarm_Time AS fire_time,

    Dim_Fire.Fire_Initial_CAD_Incident_Type_Description AS 'EMD - desc',
    Dim_Basic.Basic_Primary_Action_Taken AS 'disposition',

    Dim_Basic.Basic_Apparatus_Call_Sign_List AS 'All Responding Units',

    -- ###############################################################################################
    Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign AS 'unit',

    Dim_ApparatusResources.Apparatus_Resource_Dispatch_Date_Time as 'DP',
    Dim_ApparatusResources.Appratus_Resource_Enroute_Date_Time as 'ER',
    Dim_ApparatusResources.Apparatus_Resource_Arrival_Date_Time as 'OS',
    Dim_ApparatusResources.Apparatus_Resource_Clear_Date_Time as 'CL',
    Dim_ApparatusResources.Apparatus_Resource_In_Service_Date_Time as 'AV',
    Dim_ApparatusResources.Apparatus_Resource_Staging_Date_Time as 'SG',
    Dim_ApparatusResources.Apparatus_Resource_Leave_Scene_Date_Time as 'TR',
    Dim_ApparatusResources.Apparatus_Resource_Arrival_At_Hospital_Time as 'TC',
    Dim_ApparatusResources.Apparatus_Resource_In_Quarters_Date_Time as 'AIQ',

GREATEST(
        Apparatus_Resource_Dispatch_Date_Time,
        Appratus_Resource_Enroute_Date_Time,
        Apparatus_Resource_Arrival_Date_Time,
        Apparatus_Resource_Clear_Date_Time,
        Apparatus_Resource_In_Service_Date_Time,
        Apparatus_Resource_Staging_Date_Time,
        Apparatus_Resource_Leave_Scene_Date_Time,
        Apparatus_Resource_Arrival_At_Hospital_Time,
        Apparatus_Resource_In_Quarters_Date_Time
    ) as Latest_Time,
    
    CAST(DATEDIFF(SECOND, Apparatus_Resource_Dispatch_Date_Time, 
        GREATEST(
            Apparatus_Resource_Dispatch_Date_Time,
            Appratus_Resource_Enroute_Date_Time,
            Apparatus_Resource_Arrival_Date_Time,
            Apparatus_Resource_Clear_Date_Time,
            Apparatus_Resource_In_Service_Date_Time,
            Apparatus_Resource_Staging_Date_Time,
            Apparatus_Resource_Leave_Scene_Date_Time,
            Apparatus_Resource_Arrival_At_Hospital_Time,
            Apparatus_Resource_In_Quarters_Date_Time
        )) / 60 AS VARCHAR) + ':' +
    RIGHT('0' + CAST(DATEDIFF(SECOND, Apparatus_Resource_Dispatch_Date_Time, 
        GREATEST(
            Apparatus_Resource_Dispatch_Date_Time,
            Appratus_Resource_Enroute_Date_Time,
            Apparatus_Resource_Arrival_Date_Time,
            Apparatus_Resource_Clear_Date_Time,
            Apparatus_Resource_In_Service_Date_Time,
            Apparatus_Resource_Staging_Date_Time,
            Apparatus_Resource_Leave_Scene_Date_Time,
            Apparatus_Resource_Arrival_At_Hospital_Time,
            Apparatus_Resource_In_Quarters_Date_Time
        )) % 60 AS VARCHAR), 2) 
    as Total_Time_MM_SS,

    DATEDIFF(
        SECOND,
        Apparatus_Resource_Dispatch_Date_Time,
        GREATEST(
            Apparatus_Resource_Dispatch_Date_Time,
            Appratus_Resource_Enroute_Date_Time,
            Apparatus_Resource_Arrival_Date_Time,
            Apparatus_Resource_Clear_Date_Time,
            Apparatus_Resource_In_Service_Date_Time,
            Apparatus_Resource_Staging_Date_Time,
            Apparatus_Resource_Leave_Scene_Date_Time,
            Apparatus_Resource_Arrival_At_Hospital_Time,
            Apparatus_Resource_In_Quarters_Date_Time
        )
    ) as Total_Seconds,


    -- ROW_NUMBER() OVER (
    --         PARTITION BY Dim_Basic.Basic_Incident_Number 
    --         ORDER BY Dim_ApparatusResources.Apparatus_Resource_Arrival_Date_Time
    --     ) as arrival_order,


    ROW_NUMBER() OVER (
            PARTITION BY Dim_Basic.Basic_Incident_Number 
            ORDER BY 
                CASE 
                    WHEN Dim_ApparatusResources.Apparatus_Resource_Arrival_Date_Time IS NOT NULL 
                    THEN 0 ELSE 1 END,
                Dim_ApparatusResources.Apparatus_Resource_Arrival_Date_Time
        ) as arrival_order,

    -- ###############################################################################################

    -- Column 1: Full Code (before the dash)
    CASE
        WHEN CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) > 0 
        THEN LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description, 
                CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) - 1)
        ELSE Dim_Fire.Fire_Initial_CAD_Incident_Type_Description 
    END as ProQA_Code,

    -- Column 2: Initial Numbers
    CASE 
        WHEN CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) > 0 
        THEN LEFT(
                LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description, 
                    CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) - 1),
                PATINDEX('%[^0-9]%',
                        LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description, 
                            CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) - 1) + 'A') - 1)
        ELSE LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description,
                PATINDEX('%[^0-9]%', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description + 'A') - 1)
    END as ProQA_Numeric,

    -- Column 3: Letter after initial numbers (only if code starts with numbers)
    CASE 
        WHEN CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) > 0 
            AND PATINDEX('[0-9]%', 
                LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description, 
                    CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) - 1)) = 1
        THEN SUBSTRING(
                LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description, 
                    CHARINDEX(' -', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) - 1),
                PATINDEX('%[^0-9]%', 
                        LEFT(Dim_Fire.Fire_Initial_CAD_Incident_Type_Description, 
                            CHARINDEX(' - ', Dim_Fire.Fire_Initial_CAD_Incident_Type_Description) - 1)),
                1)
        ELSE NULL
    END as ProQA_Letter,

    -- ###############################################################################################
    -- just for filtering
    Fact_Fire.Agency_Shortname AS agency,
    Dim_Basic.Basic_Exposure as Fire_Report_Exposure_Number,
   

    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident'
        + CONVERT(VARCHAR(255), Fact_Fire.Incident_ID_Internal)
        + '/Form'
        + CONVERT(VARCHAR(255), Fact_Fire.Basic_Incident_Form_Number) AS fire_link






FROM [Elite_DWPortland].[DwFire].[Fact_Fire]
    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] 
        ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Fire] 
        ON Fact_Fire.Dim_Fire_FK = Dim_Fire.Dim_Fire_PK
    LEFT JOIN [Elite_DWPortland].[DwEms].[Fact_Incident]
        INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One] 
            ON Fact_Incident.Dim_Incident_One_To_One_PK = Dim_Incident_One_To_One.Dim_Incident_One_To_One_PK
        INNER JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] 
            ON Fact_Incident.Dim_Incident_FK = Dim_Incident.Dim_Incident_PK
        ON Dim_Basic.Basic_Incident_Number = Dim_Incident_One_To_One.Response_Incident_Number

    LEFT JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ApparatusResources] AS [Bridge_Fire_ApparatusResources] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_ApparatusResources].[Fact_Fire_PK]
    LEFT JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] AS [Dim_ApparatusResources] ON [Bridge_Fire_ApparatusResources].[Dim_ApparatusResources_PK] = [Dim_ApparatusResources].[Dim_ApparatusResources_PK]


WHERE
    Fact_Fire.Agency_shortname = 'portlandfi'
    AND Dim_Basic.Basic_Incident_Alarm_Time >= '2024-08-19'
    AND Dim_Basic.Basic_Incident_Number IS NOT NULL
    AND Dim_Basic.Basic_Exposure = 0



    -- NACHO UNITS!
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHS%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHAT%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'PSR%'
    -- AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'M%' -- this will exclude MC9 :(
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[M][0-9]%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[B][0-9]%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'LZ%'

    -- Fire inspectors
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[I][0-9]%'


    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'MCCL%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'MS%'

    -- AIRPORT FIRE
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'C8%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'NOPDX%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'NOBOEC%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E80%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'R82%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'INFO%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'RB80%'

    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'VA%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CC%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'D3%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'LO%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'TV%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'TIPF%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'POISON%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'INFFA1%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'EMS%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'FT%'

    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E32%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU33%'

    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'S6%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E61%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU61%'

    --AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU33%' -- ????

    -- GRESHAM UNITS <3
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'C7%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'T71%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E71%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E72%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E73%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E74%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E75%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'E76%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'R74%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'BU74%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'RHB74%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'HR71%'
    AND Dim_ApparatusResources.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'HS81%'



)
SELECT *
FROM RankedArrivals
WHERE arrival_order = 1;
