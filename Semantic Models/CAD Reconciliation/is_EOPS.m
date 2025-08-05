is_EOPS_Unit = 
SWITCH(
    TRUE(),
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 2) = "M3", FALSE, // MultCo ALS
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 2) = "M1", FALSE, // MultCo hybrid
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 2) = "B4", FALSE, // MultCo BLS
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 2) = "MS", FALSE, // MultCo supervisor
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 2) = "M2", FALSE, // clackamas
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 2) = "LZ", FALSE, // level zero placeholder
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 4) = "CHAT", FALSE, // CHAT
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 3) = "CHS", FALSE, // CHAT supervisor
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 3) = "PSR", FALSE, // PSR
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 3) = "EMS", FALSE, // ???
    LEFT(Query2[CAD_Response_EMS_Vehicle_Unit_Number], 4) = "INFO", FALSE, // ???
    IFERROR(
        LOOKUPVALUE(
            Sheet1[isEOPS],
            Sheet1[Apparatus_Resource_ID],
            Query2[CAD_Response_EMS_Vehicle_Unit_Number]
        ),
        BLANK()
    )
)