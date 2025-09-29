# CAD Reconciliation

This semantic model reconciles CAD data across core CAD fact and dimensions. The diagram below shows the relationships between the CAD tables used by this model. Note: Dim_EMS_CAD is intentionally excluded.

## CAD Tables ER Diagram

```mermaid
erDiagram
    Fact_CAD }o--|| Dim_CAD : "Dim_CAD_FK -> Dim_CAD_PK"
    Fact_CAD }o--|| Dim_CAD_Dispatch : "Dim_CAD_Dispatch_FK -> Dim_CAD_Dispatch_PK"
    Fact_CAD }o--|| Dim_CAD_Response : "Dim_CAD_Response_FK -> Dim_CAD_Response_PK"
    Fact_CAD }o--|| Dim_CAD_Scene : "Dim_CAD_Scene_FK -> Dim_CAD_Scene_PK"

    Fact_CAD }o--|| Fact_Incident : "CAD_ID_Internal -> CAD_Incident_ID_Internal"
    Fact_Incident }o--|| Dim_Incident : "Dim_Incident_FK -> Dim_Incident_PK"

    %% Entities with relevant keys
    Fact_CAD {
      int Fact_CAD_PK
      uniqueidentifier CAD_ID_Internal
      int Dim_CAD_FK
      int Dim_CAD_Dispatch_FK
      int Dim_CAD_Response_FK
      int Dim_CAD_Scene_FK
    }
    Dim_CAD {
      int Dim_CAD_PK
      datetime CAD_Unit_Notified_By_Dispatch_Date_Time
      datetime CAD_Unit_En_Route_Date_Time
      datetime CAD_Unit_Arrived_On_Scene_Date_Time
    }
    Dim_CAD_Dispatch {
      int Dim_CAD_Dispatch_PK
      string CAD_EMD_Card_Number
    }
    Dim_CAD_Response {
      int Dim_CAD_Response_PK
      string CAD_Incident_Number
      string CAD_Response_EMS_Unit_Call_Sign
    }
    Dim_CAD_Scene {
      int Dim_CAD_Scene_PK
    }
    Fact_Incident {
      int Fact_Incident_PK
      uniqueidentifier CAD_Incident_ID_Internal
      int Dim_Incident_FK
    }
    Dim_Incident {
      int Dim_Incident_PK
    }
```

### Notes
- Schemas: All CAD tables shown are in `[Elite_DWPortland].[DwEms]`.
- Exclusions: `Dim_EMS_CAD` is intentionally not shown per design request.
- Join keys: The labels on each relationship show the exact FK -> PK mapping used in SQL (see `Semantic Models/CAD Reconciliation/stich.sql`).
