select top(50)
       ---[PMI ID_HP] as HP_PMI_ID__c

      ---,[Last Name_HP] as LastName
      ---,[First Name_HP] as FirstName
      ---,[Date of Birth_HP] as Birthdate
	  concat('P00000',[Row_Id]) as HP_PMI_ID__c
	  ,LEFT([Last Name_HP],2) as LastName
	  ,LEFT([First Name_HP],2) as FirstName
	  ,concat(year([Date of Birth_HP]), '-01-01') as Birthdate
      ,[Street Address_HP] as MailingStreet
      ,[City_HP] as MailingCity
      ,'0010a00001Qa6gPAAR' as AccountId ---Primary Organization Columbia
      ,CASE WHEN [State_HP] = 'AL' THEN 'ALABAMA'
      WHEN [State_HP] = 'AR' THEN 'ARKANSAS'
      WHEN [State_HP] = 'AS' THEN 'AMERICAN SAMOA'
      WHEN [State_HP] = 'AZ' THEN 'ARIZONA '
      WHEN [State_HP] = 'CA' THEN 'CALIFORNIA '
      WHEN [State_HP] = 'CO' THEN 'COLORADO '
      WHEN [State_HP] = 'CT' THEN 'CONNECTICUT'
      WHEN [State_HP] = 'DC' THEN 'DISTRICT OF COLUMBIA'
      WHEN [State_HP] = 'DE' THEN 'DELAWARE'
      WHEN [State_HP] = 'FL' THEN 'FLORIDA'
      WHEN [State_HP] = 'FM' THEN 'FEDERATED STATES OF MICRONESIA'
      WHEN [State_HP] = 'GA' THEN 'GEORGIA'
      WHEN [State_HP] = 'GU' THEN 'GUAM '
      WHEN [State_HP] = 'HI' THEN 'HAWAII'
      WHEN [State_HP] = 'IA' THEN 'IOWA'
      WHEN [State_HP] = 'ID' THEN 'IDAHO'
      WHEN [State_HP] = 'IL' THEN 'ILLINOIS'
      WHEN [State_HP] = 'IN' THEN 'INDIANA'
      WHEN [State_HP] = 'KS' THEN 'KANSAS'
      WHEN [State_HP] = 'KY' THEN 'KENTUCKY'
      WHEN [State_HP] = 'LA' THEN 'LOUISIANA'
      WHEN [State_HP] = 'MA' THEN 'MASSACHUSETTS'
      WHEN [State_HP] = 'MD' THEN 'MARYLAND'
      WHEN [State_HP] = 'ME' THEN 'MAINE'
      WHEN [State_HP] = 'MH' THEN 'MARSHALL ISLANDS'
      WHEN [State_HP] = 'MI' THEN 'MICHIGAN'
      WHEN [State_HP] = 'MN' THEN 'MINNESOTA'
      WHEN [State_HP] = 'MO' THEN 'MISSOURI'
      WHEN [State_HP] = 'MP' THEN 'NORTHERN MARIANA ISLANDS'
      WHEN [State_HP] = 'MS' THEN 'MISSISSIPPI'
      WHEN [State_HP] = 'MT' THEN 'MONTANA'
      WHEN [State_HP] = 'NC' THEN 'NORTH CAROLINA'
      WHEN [State_HP] = 'ND' THEN 'NORTH DAKOTA'
      WHEN [State_HP] = 'NE' THEN 'NEBRASKA'
      WHEN [State_HP] = 'NH' THEN 'NEW HAMPSHIRE'
      WHEN [State_HP] = 'NJ' THEN 'NEW JERSEY'
      WHEN [State_HP] = 'NM' THEN 'NEW MEXICO'
      WHEN [State_HP] = 'NV' THEN 'NEVADA'
      WHEN [State_HP] = 'NY' THEN 'NEW YORK'
      WHEN [State_HP] = 'OH' THEN 'OHIO'
      WHEN [State_HP] = 'OK' THEN 'OKLAHOMA'
      WHEN [State_HP] = 'OR' THEN 'OREGON'
      WHEN [State_HP] = 'PA' THEN 'PENNSYLVANIA'
      WHEN [State_HP] = 'PR' THEN 'PUERTO RICO'
      WHEN [State_HP] = 'RI' THEN 'RHODE ISLAND'
      WHEN [State_HP] = 'SC' THEN 'SOUTH CAROLINA'
      WHEN [State_HP] = 'SD' THEN 'SOUTH DAKOTA'
      WHEN [State_HP] = 'TN' THEN 'TENNESSEE'
      WHEN [State_HP] = 'TX' THEN 'TEXAS'
      WHEN [State_HP] = 'UT' THEN 'UTAH'
      WHEN [State_HP] = 'VA' THEN 'VIRGINIA '
      WHEN [State_HP] = 'VI' THEN 'VIRGIN ISLANDS'
      WHEN [State_HP] = 'VT' THEN 'VERMONT'
      WHEN [State_HP] = 'WA' THEN 'WASHINGTON'
      WHEN [State_HP] = 'WI' THEN 'WISCONSIN'
      WHEN [State_HP] = 'WV' THEN 'WEST VIRGINIA'
      WHEN [State_HP] = 'WY' THEN 'WYOMING'
      ELSE '' END AS MailingState
      ,[ZIP_HP] as MailingPostalCode
	  ---,[Email_HP] as Email
      ,lower(concat(LEFT([Last Name_HP],2),LEFT([First Name_HP],2),'@gmail.com')) as Email
	  ,concat(LEFT([Phone_HP], 4), '000000') as Phone
      ---,[Phone_HP] as Phone
      ,[Sex_HP] as HP_Sex__c
      ,[Gender Identity_HP] as HP_Gender_Identity__c
      ,[Race/Ethnicity_HP] as HP_Race_Ethnicity__c
      ,case when [aou_enroller_RC] is null then ''
      else [aou_enroller_RC]
      end as CH_All_of_Us_Enroller_UNI__c
	  ,concat('3-', [Row_Id]) as CH_REDCap_Record_ID__c
      ---,convert(varchar, [record_id_RC]) as CH_REDCap_Record_ID__c
      ,case when [spec_provider_RC] is null then ''
      else [spec_provider_RC]
      end as CH_Specify_Health_Care_Provider__c
      ,case when [learn_aou_other_RC] is null then ''
      else [learn_aou_other_RC]
      end as CH_Other_details__c
      ,case when [tech_asst_RC] is null then ''
      else [tech_asst_RC]
      end as CH_Technical_Assistance_Required__c
      ,case when [learn_aou_other_RC] is null then ''
      else [learn_aou_other_RC]
      end as CH_How_did_contact_learn_about_AoU__c
      ,case when [tech_asst_other_RC] is null then ''
      else [tech_asst_other_RC]
      end as CH_Other_technical_assistance_details__c
      ,case when [clinical_outreach_name_RC] is null then ''
      else [clinical_outreach_name_RC]
      end as CH_Specify_clinical_outreach__c
      ,[Participant Status_HP] as NYC_AoU_Status__c
      ,[Language_HP] as HP_Language__c/*
      ,'' as WCM_Attempted_Recruitment_Site__c
      ,'' as WCM_Best_Mode_of_Contact__c
      ,'' as WCM_Best_Time_of_Day_to_Contact__c
      ,'' as WCM_Contact_Notes__c
      ,'' as WCM_Date_of_Contact__c
      ,'' as WCM_Date_to_Follow_Up_with_Patient__c
      ,'' as WCM_Daytime_Phone_Number__c
      ,'' as WCM_Enrollment_Site__c
      ,'' as WCM_Is_a_reminder_needed__c
      ,'' as WCM_Is_another_contact_required__c
      ,'' as WCM_Method_of_Contact__c
      ,'' as WCM_Notes__c
      ,'' as WCM_Other_Reason_for_Contact__c
      ,'' as WCM_Participant_Availability__c
      ,'' as WCM_Participant_Contact_Date__c
      ,'' as WCM_Personal_Email_Address__c
      ,'' as WCM_Please_Contact_Participant_Date__c
      ,'' as WCM_Post_enrollment_Coordinator__c
      ,'' as WCM_Primary_Method_of_Contact__c
      ,'' as WCM_Reason_for_Re_Contact__c
      ,'' as WCM_REDCap_Record_ID__c
      ,'' as WCM_Recruiting_Coordinator__c
      ,'' as WCM_Recruitment_Sourcer__c
      ,'' as WCM_Reminder_Notes__c
      ,'' as WCM_Result_for_Participant_Contact__c
      ,'' as WCM_Scheduled_Visit_Date__c
      ,'' as CM_Secondary_Method_of_Contact__c
      ,'' as WCM_Enrolling_Research_Coordinator__c*/
from [dm_aou].[dbo].[vw_reporting_base](nolock)
where org_RC = 'Columbia' and [PMI ID_HP] is not null and [Paired Site_HP] is not null