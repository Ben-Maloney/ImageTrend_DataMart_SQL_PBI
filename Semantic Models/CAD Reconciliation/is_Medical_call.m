is_Medical = 
VAR ProQA_CARD_Text = Query2[ProQA_CARD] // Capture text value
VAR ProQA_CARD_Value =
    IFERROR(
        VALUE(ProQA_CARD_Text),
        BLANK()  // If VALUE() returns an error, set to BLANK()
    )
VAR Is_Medical_By_Card =
    IF(
        NOT ISBLANK(ProQA_CARD_Text) && // Check if original is blank
        NOT ISBLANK(ProQA_CARD_Value) && // Check if the converted value is blank
        ProQA_CARD_Value >= 1 &&
        ProQA_CARD_Value <= 33,
        TRUE(),
        BLANK()  // Ensure non-medical or blanks result in BLANK()
    )
RETURN
    SWITCH(
        TRUE(),
        Query2[CAD_EMD_Card_Number] = "CPR", TRUE(),
        Query2[CAD_EMD_Card_Number] = "EMS2", TRUE(),
        Query2[CAD_EMD_Card_Number] = "EMS5", TRUE(),
        Query2[CAD_EMD_Card_Number] = "EMS6", TRUE(),
        Query2[CAD_EMD_Card_Number] = "AMR2", TRUE(),
        Query2[CAD_EMD_Card_Number] = "AMR3", TRUE(),
        Query2[CAD_EMD_Card_Number] = "AMR6", TRUE(),
        Is_Medical_By_Card, TRUE(), //use the original logic if none of the switch statements match
        BLANK()  // Default: if none of the conditions are met, return BLANK()
    )