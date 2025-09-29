let
    // Normalize join keys to TRIMMED + UPPER text on both sides
    LeftPrepared = Table.TransformColumns(Query2, {{"CAD_CAD_ID", each Text.Upper(Text.Trim(Text.From(_))), type text}}),
    RightPrepared = Table.TransformColumns(Query1, {{"Constructed_Incident_Time_UnitID", each Text.Upper(Text.Trim(Text.From(_))), type text}}),

    // Left join: Query2[CAD_CAD_ID] -> Query1[Constructed_Incident_Time_UnitID]
    Merged = Table.NestedJoin(
        LeftPrepared,
        {"CAD_CAD_ID"},
        RightPrepared,
        {"Constructed_Incident_Time_UnitID"},
        "Query1",
        JoinKind.LeftOuter
    ),

    // Expand ALL right-side columns
    Expanded = Table.ExpandTableColumn(Merged, "Query1", Table.ColumnNames(RightPrepared), Table.ColumnNames(RightPrepared))
in
    Expanded
