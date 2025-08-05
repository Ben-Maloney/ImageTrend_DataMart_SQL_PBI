SELECT


    ----------------------------
    Fact_Fire.Agency_Shortname as agency,
    Fact_Fire.CreatedOn AS 'Report CreatedOn',
    dar.CreatedOn as 'Action CreatedOn',
    dar.ModifiedOn as 'Action ModifiedOn',

    -----------------------------------
    dap.Apparatus_Personnel_Full_Name AS personnel_name,
    dap.Apparatus_Personnel_Rank_Or_Grade AS personnel_rank,
    dap.Apparatus_Personnel_Role AS personnel_role,
    dap.Apparatus_Personnel_Badge_Number AS badge_number,

    -----------------------------------

    dar.Apparatus_Resource_Vehicle_Call_Sign as 'apparatus',
    dar.Apparatus_Resource_Primary_Action_Taken as 'primary action taken',
    dar.Apparatus_Resource_Actions_Taken_List as 'other actions taken list',
    dar.Apparatus_Resource_Narrative as 'app narrative',
    dar.Apparatus_Personnel_Name_List as 'crew names',

    Dim_Basic.Basic_Incident_Alarm_Time AS 'Incident alarm date_time',
    dar.Apparatus_Resource_Dispatch_Date_Time as 'Unit dispatch date_time',    

    -- incident details
    Dim_Basic.Basic_Incident_Number as RP,
    Dim_Fire.Fire_Initial_CAD_Incident_Type_Description as 'EMD - desc',
    Dim_Basic.Basic_Apparatus_Call_Sign_List as 'Responding Units',
    Dim_Basic.Basic_Shift_Or_Platoon as shift,
    Dim_Basic.Basic_Incident_Full_Address as address



FROM [Elite_DWPortland].[DwFire].[Fact_Fire]
    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
    INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Fire] ON Fact_Fire.Dim_Fire_FK = Dim_Fire.Dim_Fire_PK
    JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ApparatusResources] bfar ON Fact_Fire.Fact_Fire_PK = bfar.Fact_Fire_PK
    JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] dar ON bfar.Dim_ApparatusResources_PK = dar.Dim_ApparatusResources_PK



    JOIN [Elite_DWPortland].[DwFire].[Bridge_ApparatusResources_ApparatusPersonnel] brap 
        ON dar.Dim_ApparatusResources_PK = brap.Dim_ApparatusResources_PK
    JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusPersonnel] dap 
        ON brap.Dim_ApparatusPersonnel_PK = dap.Dim_ApparatusPersonnel_PK


WHERE
    Fact_Fire.CreatedOn >= '2024-08-19'
    -- AND Fact_Fire.Agency_shortname = 'portlandfi'
    AND (dar.Apparatus_Resource_Actions_Taken_List LIKE '%trauma%' OR dar.Apparatus_Resource_Primary_Action_Taken LIKE '%trauma%')

--- IGNORE THESE UNIT RESPONCES
AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'M%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'PSR%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'LZ%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[B][0-9]%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHAT%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHS%'
