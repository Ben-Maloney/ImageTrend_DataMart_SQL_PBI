
```dax
is_EOPS_Unit = 
-- NOTE: This should be a CALCULATED COLUMN, not a MEASURE!
-- This is a switch statement that checks if the unit is an EOPS unit.
-- Place units in the switch statement to 
SWITCH(
    TRUE(),
    LEFT(UnitResponse[unit], 2) = "M3", FALSE, // MultCo ALS
    LEFT(UnitResponse[unit], 2) = "M1", FALSE, // MultCo hybrid
    LEFT(UnitResponse[unit], 2) = "B4", FALSE, // MultCo BLS
    LEFT(UnitResponse[unit], 2) = "MS", FALSE, // MultCo supervisor
    LEFT(UnitResponse[unit], 2) = "M2", FALSE, // clackamas
    LEFT(UnitResponse[unit], 2) = "LZ", FALSE, // level zero placeholder
    LEFT(UnitResponse[unit], 4) = "CHAT", FALSE, // CHAT
    LEFT(UnitResponse[unit], 3) = "CHS", FALSE, // CHAT supervisor
    LEFT(UnitResponse[unit], 3) = "PSR", FALSE, // PSR
    LEFT(UnitResponse[unit], 3) = "EMS", FALSE, // ???
    LEFT(UnitResponse[unit], 4) = "INFO", FALSE, // ???
    IFERROR(
        LOOKUPVALUE(
            ApparatusLookup[isEOPS],
            ApparatusLookup[Apparatus_Resource_ID],
            UnitResponse[unit]
        ),
        BLANK()
    )
)
```