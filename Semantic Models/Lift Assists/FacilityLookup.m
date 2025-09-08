let
    Source = Excel.Workbook(
        Web.Contents("https://portlandoregongov-my.sharepoint.com/personal/micah_fullerton_portlandoregon_gov/Documents/Desktop/FacilityLiftAssist.xlsx"),
        null,
        true
    ),
    Sheet1_Sheet = Source{[Item="Sheet1", Kind="Sheet"]}[Data],
    PromotedHeaders = Table.PromoteHeaders(Sheet1_Sheet, [PromoteAllScalars = true]),
    AsText = Table.TransformColumnTypes(
        PromotedHeaders,
        List.Transform(Table.ColumnNames(PromotedHeaders), each {_, type text})
    )
in
    AsText