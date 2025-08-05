let
    Source = Table.NestedJoin(ProQA_Fire, {"RP_fire"}, ProQA_Med, {"RP_ems"}, "ProQA_Med", JoinKind.LeftOuter),
    #"Expanded ProQA_Med" = Table.ExpandTableColumn(Source, "ProQA_Med", {"RP_ems", "ems_time", "EMD", "ePCR unit", "Patient_Evaluation_Care", "Transport_Disposition", "Narrative", "proc_desc", "meds_desc", "agency", "ePCR_link"}, {"ProQA_Med.RP_ems", "ProQA_Med.ems_time", "ProQA_Med.EMD", "ProQA_Med.ePCR unit", "ProQA_Med.Patient_Evaluation_Care", "ProQA_Med.Transport_Disposition", "ProQA_Med.Narrative", "ProQA_Med.proc_desc", "ProQA_Med.meds_desc", "ProQA_Med.agency", "ProQA_Med.ePCR_link"}),
    #"Add Patient Treated column" = Table.AddColumn(#"Expanded ProQA_Med", "Patient treated", each if [ProQA_Med.proc_desc] = null and [ProQA_Med.meds_desc] = null then 0 else 1),
    #"PF&R Transported" = Table.AddColumn(#"Add Patient Treated column", "PFR Transported", each if [ProQA_Med.Transport_Disposition] = "Transport by This EMS Unit (This Crew Only)" then 1 else 0),
    #"PR&F Rode in with AMR" = Table.AddColumn(#"PF&R Transported", "PF&R Rode in with AMR", each if [ProQA_Med.Transport_Disposition] = "Transport by Another EMS Unit, with a Member of This Crew" then 1 else 0),
    #"Patient Contact" = Table.AddColumn(#"PR&F Rode in with AMR", "Patient Contact", each if [ProQA_Med.RP_ems] <> null then 1 else 0),
    #"Arrived on scene" = Table.AddColumn(#"Patient Contact", "Arrived", each if [OS] <> null then 1 else 0),
    #"determine 'result' or ultimate disposition" = Table.AddColumn(#"Arrived on scene", "result", each if [PFR Transported] = 1 then "PF&R Transported" else if [#"PF&R Rode in with AMR"] = 1 then "PF&R Rode in with AMR" else if [Patient treated] = 1 then "Patient Treated" else if [Patient Contact] = 1 then "Patient Contact" else if [Arrived] = 1 then "Cancel OS" else "Cancel PTA")
in
    #"determine 'result' or ultimate disposition"
