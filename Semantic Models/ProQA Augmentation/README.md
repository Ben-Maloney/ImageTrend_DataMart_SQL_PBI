


```m
Pass_Fail = 
SWITCH(
    RELATED('Dim_CQICategory'[CQI_Name]),
    "Burns", RELATED('Dim_CQISupplementalQuestions1'[QA354]),
    "Cardiac Arrest", RELATED('Dim_CQISupplementalQuestions'[QA137]),
    "Diabetic", RELATED('Dim_CQISupplementalQuestions'[QA193]),
    "Generic", RELATED('Dim_CQISupplementalQuestions'[QA16]),
    "Pediatric", RELATED('Dim_CQISupplementalQuestions'[QA51]),
    "Respiratory", RELATED('Dim_CQISupplementalQuestions1'[QA304]),
    "Sepsis", RELATED('Dim_CQISupplementalQuestions'[QA77]),
    // "STEMI", RELATED('Dim_CQISupplementalQuestions'[QA192]),
    "Stroke", RELATED('Dim_CQISupplementalQuestions'[QA18]),
    "Trauma", RELATED('Dim_CQISupplementalQuestions'[QA13]),
    BLANK()
)


```