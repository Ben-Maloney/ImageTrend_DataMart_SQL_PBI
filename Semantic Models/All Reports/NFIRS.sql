-- This query joins Fact_Fire with Dim_Basic to get the NFIRS listing
-- We can use Fact_Fire_PK to join with the ApparatusResponse table to get the apparatus dispatched to the incident
-- This way we can connect unit responses to NFIRS reports
-- This will allow each Apparatus Narrative to be connected to the 'Basic Summary'

SELECT
    -- Fact_Fire identifiers
    ff.[Fact_Fire_PK]
    ,ff.[Incident_ID_Internal]
    
    -- Basic incident information
    ,db.[Basic_Incident_Number] AS RP_Number
    ,db.[Basic_Incident_Date_Time]
    
    -- Incident classification
    ,db.[Basic_Incident_Type]
    ,db.[Basic_Incident_Type_Code]
    ,db.[Basic_Incident_Type_Code_And_Description]
    
    -- Location information
    ,db.[Basic_Incident_Street_Number]
    ,db.[Basic_Incident_Street_Prefix]
    ,db.[Basic_Incident_Street_Type]
    
    -- Action taken
    -- ,db.[Basic_Action_Taken]
    -- ,db.[Basic_Action_Taken_Code]
    -- ,db.[Basic_Action_Taken_Code_And_Description]
    
    -- Property use
    ,db.[Basic_Property_Use]
    ,db.[Basic_Property_Use_Code]
    ,db.[Basic_Property_Use_Code_And_Description]
    
    -- Agency info
    ,ff.[Agency_shortname]
    ,ff.[Basic_Incident_Form_Number]
    
    -- Additional fields
    -- ,db.[Basic_Incident_CAD_Incident_Number]
    ,db.[Basic_Incident_Primary_Narrative]

    ,db.[Basic_EFD_Card_Number]

    ,LEFT(db.[Basic_EFD_Card_Number], PATINDEX('%[^0-9]%', db.[Basic_EFD_Card_Number] + 'A') - 1) as ProQA_CARD

    ,ff.Incident_ID_Internal AS url_incident,
    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident'
        + CONVERT(VARCHAR(255), ff.Incident_ID_Internal)
        + '/Form'
        + CONVERT(VARCHAR(255), ff.Basic_Incident_Form_Number) AS link

FROM [Elite_DWPortland].[DwFire].[Fact_Fire] ff

INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] db
    ON ff.[Dim_Basic_FK] = db.[Dim_Basic_PK]

WHERE ff.[Agency_shortname] = 'portlandfi'
    AND db.[Basic_Incident_Date_Time] > '2025-01-01'
    AND db.[Basic_Incident_Number] IS NOT NULL
