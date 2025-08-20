## Repository Overview and Usage

 - My organization is Portland Fire & Rescue, City of Portland.
 - My team uses Power BI for data analysis and reporting.
 - Our database is Microsoft SQL Server and is READ-ONLY.  Are aren't able to place our SQL code onto the server.
 - Edits should be made to the repo's files so that they can be run in Power BI, or queried locally.
 - We use ImageTrend SaaS software for data collection of NFIRS "fire reports" and NEMSIS "patient care reports"
 - We pay for ImageTrend's DataMart feature which periodically syncronizes an on-site database with ImageTrend's SaaS database for data analysis and reporting.
 - For many reports, we typically build custom SQL queries to extract the data we need from the on-site database, then we copy-paste the query into Power BI for analysis and reporting like this:

```m
let
    Source = Sql.Database("pfbsql3", "Elite_DWPortland", [Query="
 -- SQL query goes here
    "])
in
    Source
```
