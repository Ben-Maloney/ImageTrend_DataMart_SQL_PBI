CREATE VIEW [dbo].[DSV_Elite_Fire_View] AS SELECT Fact_Fire.*

FROM [DwFire].[Fact_Fire]

FULL JOIN [DwFire].[Dim_Fire_CAD] AS [Dim_Fire_CAD] ON [Fact_Fire].[CAD_ID_FK] = [Dim_Fire_CAD].[Dim_Fire_CAD_PK]

LEFT JOIN [DwFire].[Dim_Basic] AS [Dim_Basic] ON [Fact_Fire].[Dim_Basic_FK] = [Dim_Basic].[Dim_Basic_PK]
LEFT JOIN [DwFire].[Dim_Fire] AS [Dim_Fire] ON [Fact_Fire].[Dim_Fire_FK] = [Dim_Fire].[Dim_Fire_PK]
LEFT JOIN [DwFire].[Dim_StructureFire] AS [Dim_StructureFire] ON [Fact_Fire].[Dim_StructureFire_FK] = [Dim_StructureFire].[Dim_StructureFire_PK]
LEFT JOIN [DwFire].[Dim_Arson] AS [Dim_Arson] ON [Fact_Fire].[Dim_Arson_FK] = [Dim_Arson].[Dim_Arson_PK]


LEFT JOIN [DwFire].[Bridge_Fire_CivilianCasualty] AS [Bridge_Fire_CivilianCasualty] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_CivilianCasualty].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_CivilianCasualty] AS [Dim_CivilianCasualty] ON [Bridge_Fire_CivilianCasualty].[Dim_CivilianCasualty_PK] = [Dim_CivilianCasualty].[Dim_CivilianCasualty_PK]

LEFT JOIN [DwFire].[Bridge_Fire_FireServiceCasualty] AS [Bridge_Fire_FireServiceCasualty] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_FireServiceCasualty].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_FireServiceCasualty] AS [Dim_FireServiceCasualty] ON [Bridge_Fire_FireServiceCasualty].[Dim_FireServiceCasualty_PK] = [Dim_FireServiceCasualty].[Dim_FireServiceCasualty_PK]

---
LEFT JOIN [DwFire].[Bridge_Fire_ApparatusResources] AS [Bridge_Fire_ApparatusResources] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_ApparatusResources].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_ApparatusResources] AS [Dim_ApparatusResources] ON [Bridge_Fire_ApparatusResources].[Dim_ApparatusResources_PK] = [Dim_ApparatusResources].[Dim_ApparatusResources_PK]

LEFT JOIN [DwFire].[Bridge_ApparatusResources_ApparatusPersonnel] AS [Bridge_ApparatusResources_ApparatusPersonnel] ON [Dim_ApparatusResources].[Dim_ApparatusResources_PK] = [Bridge_ApparatusResources_ApparatusPersonnel].[Dim_ApparatusResources_PK]
LEFT JOIN [DwFire].[Dim_ApparatusPersonnel] AS [Dim_ApparatusPersonnel] ON [Bridge_ApparatusResources_ApparatusPersonnel].[Dim_ApparatusPersonnel_PK] = [Dim_ApparatusPersonnel].[Dim_ApparatusPersonnel_PK]



LEFT JOIN [DwFire].[Bridge_FireCAD_Apparatus] AS [Bridge_FireCAD_Apparatus] ON [Dim_Fire_CAD].[Dim_Fire_CAD_PK] = [Bridge_FireCAD_Apparatus].[Dim_Fire_CAD_PK]
LEFT JOIN [DwFire].[Dim_Fire_CAD_Apparatus] AS [Dim_Fire_CAD_Apparatus] ON [Bridge_FireCAD_Apparatus].[Bridge_FireCAD_Apparatus_PK] = [Dim_Fire_CAD_Apparatus].[Dim_Fire_CAD_Apparatus_PK]




LEFT JOIN [DwFire].[Bridge_Basic_BasicNarrativeOther] AS [Bridge_Basic_BasicNarrativeOther] ON [Dim_Basic].[Dim_Basic_PK] = [Bridge_Basic_BasicNarrativeOther].[Dim_Basic_PK]
LEFT JOIN [DwFire].[Dim_BasicNarrativeOther] AS [Dim_BasicNarrativeOther] ON [Bridge_Basic_BasicNarrativeOther].[Dim_BasicNarrativeOther_PK] = [Dim_BasicNarrativeOther].[Dim_BasicNarrativeOther_PK]

LEFT JOIN [DwFire].[Bridge_Basic_BasicPersonInvolved] AS [Bridge_Basic_BasicPersonInvolved] ON [Dim_Basic].[Dim_Basic_PK] = [Bridge_Basic_BasicPersonInvolved].[Dim_Basic_PK]
LEFT JOIN [DwFire].[Dim_BasicPersonInvolved] AS [Dim_BasicPersonInvolved] ON [Bridge_Basic_BasicPersonInvolved].[Dim_BasicPersonInvolved_PK] = [Dim_BasicPersonInvolved].[Dim_BasicPersonInvolved_PK]

LEFT JOIN [DwFire].[Bridge_Fire_ArsonJuvenileArsonist] AS [Bridge_Fire_ArsonJuvenileArsonist] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_ArsonJuvenileArsonist].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_ArsonJuvenileArsonist] AS [Dim_ArsonJuvenileArsonist] ON [Bridge_Fire_ArsonJuvenileArsonist].[Dim_ArsonJuvenileArsonist_PK] = [Dim_ArsonJuvenileArsonist].[Dim_ArsonJuvenileArsonist_PK]

LEFT JOIN [DwFire].[Bridge_Fire_HazMat] AS [Bridge_Fire_HazMat] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_HazMat].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_HazMat] AS [Dim_HazMat] ON [Bridge_Fire_HazMat].[Dim_HazMat_PK] =[Dim_HazMat].[Dim_HazMat_PK]

LEFT JOIN [DwFire].[Bridge_Fire_HazMatDetail] AS [Bridge_Fire_HazMatDetail] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_HazMatDetail].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_HazMatDetail] AS [Dim_HazMatDetail] ON [Bridge_Fire_HazMatDetail].[Dim_HazMatDetail_PK] = [Dim_HazMatDetail].[Dim_HazMatDetail_PK]

LEFT JOIN [DwFire].[Bridge_HazMat_HazMatResponsibleParty] AS [Bridge_HazMat_HazMatResponsibleParty] ON [Dim_HazMat].[Dim_HazMat_PK] = [Bridge_HazMat_HazMatResponsibleParty].[Dim_HazMat_PK]
LEFT JOIN [DwFire].[Dim_HazMatResponsibleParty] AS [Dim_HazMatResponsibleParty] ON [Bridge_HazMat_HazMatResponsibleParty].[Dim_HazMatResponsibleParty_PK] = [Dim_HazMatResponsibleParty].[Dim_HazMatResponsibleParty_PK]

LEFT JOIN [DwFire].[Bridge_Fire_EMS] AS [Bridge_Fire_EMS] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_EMS].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_EMS] AS [Dim_EMS] ON [Bridge_Fire_EMS].[Dim_EMS_PK] = [Dim_EMS].[Dim_EMS_PK]

LEFT JOIN [DwFire].[Dim_Wildland] AS [Dim_Wildland] ON [Fact_Fire].[Dim_Wildland_FK] = [Dim_Wildland].[Dim_Wildland_PK]

LEFT JOIN [DwFire].[Bridge_Fire_FireAttachment] AS [Bridge_Fire_FireAttachment] ON [Fact_Fire].[Fact_Fire_PK] = [Bridge_Fire_FireAttachment].[Fact_Fire_PK]
LEFT JOIN [DwFire].[Dim_FireAttachment] AS [Dim_FireAttachment] ON [Bridge_Fire_FireAttachment].[Dim_FireAttachment_PK] = [Dim_FireAttachment].[Dim_FireAttachment_PK]

LEFT JOIN [DwFire].[Bridge_FireServiceCasualty_FireServiceCasualtyProtectiveEquipment] AS [Bridge_FireServiceCasualty_FireServiceCasualtyProtectiveEquipment] ON [Dim_FireServiceCasualty].[Dim_FireServiceCasualty_PK] = [Bridge_FireServiceCasualty_FireServiceCasualtyProtectiveEquipment].[Dim_FireServiceCasualty_PK]
LEFT JOIN [DwFire].[Dim_FireServiceCasualtyProtectiveEquipment] AS [Dim_FireServiceCasualtyProtectiveEquipment] ON [Bridge_FireServiceCasualty_FireServiceCasualtyProtectiveEquipment].[Dim_FireServiceCasualtyProtectiveEquipment_PK] = [Dim_FireServiceCasualtyProtectiveEquipment].[Dim_FireServiceCasualtyProtectiveEquipment_PK]

LEFT JOIN [DwEms].[Dim_Agency] AS [Dim_Agency] ON [Fact_Fire].[Dim_Agency_FK] = [Dim_Agency].[Dim_Agency_PK]

LEFT JOIN [dbo].[DSV_Dim_Incident_Date_Fire] AS [DSV_Dim_Incident_Date_Fire] ON [Fact_Fire].[Dim_Date_Fire_PK] = [DSV_Dim_Incident_Date_Fire].[Dim_Incident_Date_Fire_FK]
LEFT JOIN [dbo].[DSV_Dim_Incident_Time_Of_Day_Fire] AS [DSV_Dim_Incident_Time_Of_Day_Fire] ON [Fact_Fire].[Dim_TimeOfDay_Fire_PK] = [DSV_Dim_Incident_Time_Of_Day_Fire].[Dim_Incident_Time_Of_Day_Fire_PK]

GO