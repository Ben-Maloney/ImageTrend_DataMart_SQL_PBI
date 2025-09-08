# lift assists

This Power BI semantic model will track "lift assist" fire reports done by fire crews.

Below will be the Power Query needed to pull the needed SQL tables.  


**Fact_Fire**

```m
let
    Source = Sql.Database("pfbsql3", "Elite_DWPortland"),
    DwFire_Fact_Fire = Source{[Schema="DwFire",Item="Fact_Fire"]}[Data]
in
    DwFire_Fact_Fire
```


**DwEms.Dim_IncidentSupplementalQuestions**
Supplemental Question: "Is this a lift assist at a facility? (Nursing/Care Home)" located at QA212

```m

```