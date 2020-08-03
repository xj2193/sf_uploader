SELECT Id,
HP_PMI_ID__c,
LastName,
FirstName,
Birthdate,
MailingStreet,
MailingCity,
AccountId,
MailingState,
MailingPostalCode,
Email,
Phone,
HP_Sex__c,
HP_Gender_Identity__c,
HP_Race_Ethnicity__c,
CH_All_of_Us_Enroller_UNI__c,
CH_REDCap_Record_ID__c,
CH_Specify_Health_Care_Provider__c,
CH_Other_details__c,
CH_Technical_Assistance_Required__c,
CH_How_did_contact_learn_about_AoU__c,
CH_Other_technical_assistance_details__c,
CH_Specify_clinical_outreach__c,
HP_Language__c,
DV_Enrollment__c
FROM Contact
WHERE HP_PMI_ID__c = NULL
AND (OwnerId = '{}' or OwnerId = '{}')