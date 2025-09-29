This is how we include xlsx (Excel workbook) files into our Power BI semantic models using sharepoint:

```m
// let
//     Source = Excel.Workbook(File.Contents("C:\Users\mifullerton\OneDrive - CITY OF PORTLAND, BUREAU OF TECH. SERVICES\Desktop\CQI REVIEWERS LIST.xlsx"), null, true),
//     Sheet1_Sheet = Source{[Item="Sheet1",Kind="Sheet"]}[Data],
//     #"Changed Type" = Table.TransformColumnTypes(Sheet1_Sheet,{{"Column1", type text}, {"Column2", type text}}),
//     #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column2", "email"}, {"Column1", "reviewer number"}})
// in
//     #"Renamed Columns"
let
    Source = Excel.Workbook(Web.Contents("https://portlandoregongov-my.sharepoint.com/personal/micah_fullerton_portlandoregon_gov/Documents/Desktop/CQI%20REVIEWERS%20LIST.xlsx"), null, true),
    Sheet1_Sheet = Source{[Item="Sheet1",Kind="Sheet"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Sheet1_Sheet,{{"Column1", type text}, {"Column2", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column1", "Reviewer"}})
in
    #"Renamed Columns"

```