USE [aou_sf]
GO
/****** Object:  View [dbo].[v2_sf_contact_export_view]    Script Date: 7/23/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[v2_sf_contact_export_view] as 
select 
hashbytes('SHA1', (
select [Id]
,ltrim(rtrim([HP_PMI_ID__c])) as HP_PMI_ID__c
,ltrim(rtrim([LastName])) as LastName
,ltrim(rtrim([FirstName])) as FirstName
,ltrim(rtrim([Birthdate])) as Birthdate
,ltrim(rtrim([MailingStreet])) as MailingStreet
,ltrim(rtrim([MailingCity])) as MailingCity
,[AccountId]
,ltrim(rtrim([MailingState])) as MailingState
,ltrim(rtrim([MailingPostalCode])) as MailingPostalCode
,ltrim(rtrim([Email])) as Email
,ltrim(rtrim([Phone])) as Phone
,ltrim(rtrim([HP_Sex__c])) as HP_Sex__c
,ltrim(rtrim([HP_Gender_Identity__c])) as HP_Gender_Identity__c
,ltrim(rtrim([HP_Race_Ethnicity__c])) as HP_Race_Ethnicity__c
,ltrim(rtrim([CH_All_of_Us_Enroller_UNI__c])) as CH_All_of_Us_Enroller_UNI__c
,ltrim(rtrim([CH_REDCap_Record_ID__c])) as CH_REDCap_Record_ID__c
,ltrim(rtrim([CH_Specify_Health_Care_Provider__c])) as CH_Specify_Health_Care_Provider__c
,ltrim(rtrim([CH_Other_details__c])) as CH_Other_details__c
,ltrim(rtrim([CH_Technical_Assistance_Required__c])) as CH_Technical_Assistance_Required__c
,ltrim(rtrim([CH_How_did_contact_learn_about_AoU__c])) as CH_How_did_contact_learn_about_AoU__c
,ltrim(rtrim([CH_Other_technical_assistance_details__c])) as CH_Other_technical_assistance_details__c
,ltrim(rtrim([CH_Specify_clinical_outreach__c])) as CH_Specify_clinical_outreach__c
,ltrim(rtrim([HP_Language__c])) as HP_Language__c
for xml raw)) as rowsha1
,*
from [dbo].[v2_sf_contact]
GO
/****** Object:  View [dbo].[v2_sf_contact_view]    Script Date: 7/23/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE view [dbo].[v2_sf_contact_view] as 
select hashbytes('SHA1', (select a.* for xml raw)) as rowsha1
,*
from(
select sfc.Id
	  ,ltrim(rtrim([PMI ID_HP])) as HP_PMI_ID__c
      ,ltrim(rtrim([Last Name_HP])) as LastName
      ,ltrim(rtrim([First Name_HP])) as FirstName
      ,ltrim(rtrim([Date of Birth_HP])) as Birthdate
      ,ltrim(rtrim([Street Address_HP])) as MailingStreet
      ,ltrim(rtrim([City_HP])) as MailingCity
      ,'0010a00001Qa6gPAAR' as AccountId
      ,CASE WHEN [State_HP] = 'AL' THEN 'ALABAMA'
      WHEN [State_HP] = 'AR' THEN 'ARKANSAS'
      WHEN [State_HP] = 'AS' THEN 'AMERICAN SAMOA'
      WHEN [State_HP] = 'AZ' THEN 'ARIZONA'
      WHEN [State_HP] = 'CA' THEN 'CALIFORNIA'
      WHEN [State_HP] = 'CO' THEN 'COLORADO'
      WHEN [State_HP] = 'CT' THEN 'CONNECTICUT'
      WHEN [State_HP] = 'DC' THEN 'DISTRICT OF COLUMBIA'
      WHEN [State_HP] = 'DE' THEN 'DELAWARE'
      WHEN [State_HP] = 'FL' THEN 'FLORIDA'
      WHEN [State_HP] = 'FM' THEN 'FEDERATED STATES OF MICRONESIA'
      WHEN [State_HP] = 'GA' THEN 'GEORGIA'
      WHEN [State_HP] = 'GU' THEN 'GUAM'
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
      WHEN [State_HP] = 'VA' THEN 'VIRGINIA'
      WHEN [State_HP] = 'VI' THEN 'US VIRGIN ISLANDS'
      WHEN [State_HP] = 'VT' THEN 'VERMONT'
      WHEN [State_HP] = 'WA' THEN 'WASHINGTON'
      WHEN [State_HP] = 'WI' THEN 'WISCONSIN'
      WHEN [State_HP] = 'WV' THEN 'WEST VIRGINIA'
      WHEN [State_HP] = 'WY' THEN 'WYOMING'
      ELSE '' END AS MailingState
      ,[ZIP_HP] as MailingPostalCode
	  ,ltrim(rtrim(lower([Email_HP]))) as Email
      ,ltrim(rtrim([Phone_HP])) as Phone
      ,ltrim(rtrim([Sex_HP])) as HP_Sex__c
      ,ltrim(rtrim([Gender Identity_HP])) as HP_Gender_Identity__c
      ,ltrim(rtrim([Race/Ethnicity_HP])) as HP_Race_Ethnicity__c
      ,case when [aou_enroller_RC] is null then ''
      else ltrim(rtrim([aou_enroller_RC]))
      end as CH_All_of_Us_Enroller_UNI__c
	  ,case when [record_id_RC] is null then ''
	  else ltrim(rtrim([record_id_RC]))
	  end as CH_REDCap_Record_ID__c
      ,case when [spec_provider_RC] is null then ''
      else ltrim(rtrim([spec_provider_RC])) 
      end as CH_Specify_Health_Care_Provider__c
      ,case when [learn_aou_other_RC] is null then ''
      else ltrim(rtrim([learn_aou_other_RC]))
      end as CH_Other_details__c
      ,case when [tech_asst_RC] is null then ''
      else ltrim(rtrim([tech_asst_RC]))
      end as CH_Technical_Assistance_Required__c
      ,case when [learn_aou_RC] is null then ''
      else ltrim(rtrim([learn_aou_RC]))
      end as CH_How_did_contact_learn_about_AoU__c
      ,case when [tech_asst_other_RC] is null then ''
      else ltrim(rtrim([tech_asst_other_RC]))
      end as CH_Other_technical_assistance_details__c
      ,case when [clinical_outreach_name_RC] is null then ''
      else ltrim(rtrim([clinical_outreach_name_RC]))
      end as CH_Specify_clinical_outreach__c
      ,ltrim(rtrim([Language_HP])) as HP_Language__c
from [dm_aou].[dbo].[vw_reporting_base] (nolock)
left outer join [aou_sf].[dbo].[v2_sf_contact] sfc on [PMI ID_HP] = sfc.HP_PMI_ID__c 
where [PMI ID_HP] is not null and [Paired Organization_HP] = 'COLUMBIA_COLUMBIA') a
GO
/****** Object:  View [dbo].[v2_sf_contact_export_update]    Script Date: 7/23/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[v2_sf_contact_export_update] as 
select scv.*  
from [dbo].[v2_sf_contact_view] scv
join [dbo].[v2_sf_contact_export_view] sce on (scv.Id = sce.Id and scv.rowsha1 != sce.rowsha1)

GO
/****** Object:  View [dbo].[v2_sf_journey_export_view]    Script Date: 7/23/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[v2_sf_journey_export_view] as 
select 
hashbytes('SHA1', (
select [Id]
      ,[Contact__c]
	  ,[HP_PMI_ID__c]
      ,[AccountId]
      ,[HP_Participant_Status__c]
      ,[HP_General_Consent_Status__c]
      ,[HP_General_Consent_Date__c]
      ,[HP_EHR_Consent_Status__c]
      ,[HP_EHR_Consent_Date__c]
      ,[HP_Withdrawal_Date__c]
      ,[HP_Withdrawal_Status__c]
      ,[HP_Basics_PPI_Survey_Completion_Date__c]
      ,[HP_Health_PPI_Survey_Completion_Date__c]
      ,[HP_Lifestyle_PPI_Survey_Completion_Date__c]
      ,[HP_Hist_PPI_Survey_Completion_Date__c]
      ,[HP_Meds_PPI_Survey_Completion_Date__c]
      ,[HP_Family_PPI_Survey_Completion_Date__c]
      ,[HP_Access_PPI_Survey_Completion_Date__c]
      ,[HP_Physical_Measurements_Completion_Date__c]
      ,[HP_Samples_for_DNA_Received__c]
      ,[HP_8_mL_SST_Collection_Date__c]
      ,[HP_8_mL_PST_Collection_Date__c]
      ,[HP_4_mL_Na_Hep_Collection_Date__c]
      ,[HP_4_mL_EDTA_Collection_Date__c]
      ,[HP_1st_10_mL_EDTA_Collection_Date__c]
      ,[HP_2nd_10_mL_EDTA_Collection_Date__c]
      ,[HP_Saliva_Collection_Date__c]
      ,[HP_Urine_10_ml_Collection_Date__c]
      ,[HP_2_mL_EDTA_Collection_Date__c]
      ,[HP_Cell_Free_DNA_Collection_Date__c]
      ,[HP_Paxgene_RNA_Collection_Date__c]
      ,[HP_Urine_90_ml_Collection_Date__c]
for xml raw)) as rowsha1
,*
from [aou_sf].[dbo].[v2_sf_journey_export]
GO
/****** Object:  View [dbo].[v2_sf_journey_view]    Script Date: 7/23/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[v2_sf_journey_view] as 
select hashbytes('SHA1', (select a.* for xml raw)) as rowsha1
,*
from(select
	c.Journey_Id as Id,
	c.Contact_Id as Contact__c,
	'' as HP_PMI_ID__c,
	'0010a00001Qa6gPAAR' as AccountId, ---Primary Organization Columbia,
	[Participant Status] as HP_Participant_Status__c,
	case [General Consent Status]
		when 1 then 1 
		when 0 then 0
	end as HP_General_Consent_Status__c,

	case 
		when [General Consent Date] is null then ''
		else replace(convert(varchar(10), [General Consent Date], 102), '.', '-') 
	end as HP_General_Consent_Date__c,

	case [EHR Consent Status]
		when 1 then 1 
		when 0 then 0
	end as HP_EHR_Consent_Status__c,
	
	case 
		when [EHR Consent Date] is null then ''
		else replace(convert(varchar(10), [EHR Consent Date], 102), '.', '-') 
	end as HP_EHR_Consent_Date__c,

	case 
		when [Withdrawal Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Withdrawal Date], 102), '.', '-') 
	end as HP_Withdrawal_Date__c,

    case [Withdrawal Status]
		when 1 then 1
		when 0 then 0
	end as HP_Withdrawal_Status__c,

	case 
		when [Basics PPI Survey Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Basics PPI Survey Completion Date], 102), '.', '-') 
		end as HP_Basics_PPI_Survey_Completion_Date__c,

	case 
		when [Health PPI Survey Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Health PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Health_PPI_Survey_Completion_Date__c,

	case 
		when [Lifestyle PPI Survey Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Lifestyle PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Lifestyle_PPI_Survey_Completion_Date__c,

	case 
		when [Hist PPI Survey Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Hist PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Hist_PPI_Survey_Completion_Date__c,

	case 
		when [Meds PPI Survey Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Meds PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Meds_PPI_Survey_Completion_Date__c,

	case 
		when [Family PPI Survey Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Family PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Family_PPI_Survey_Completion_Date__c,

	case 
		when [Access PPI Survey Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Access PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Access_PPI_Survey_Completion_Date__c,

	case 
		when [Physical Measurements Completion Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Physical Measurements Completion Date], 102), '.', '-') 
	end as HP_Physical_Measurements_Completion_Date__c,

	case [Samples for DNA Received]
		when 1 then 1
		when 0 then 0
	end as HP_Samples_for_DNA_Received__c,

	case 
		when [8 mL SST Collection Date] = '1900-01-01' then ''
		else replace(convert(varchar(10), [8 mL SST Collection Date], 102), '.', '-') 
	end as HP_8_mL_SST_Collection_Date__c,

	case 
		when [8 mL PST Collection Date] = '1900-01-01' then ''
		else replace(convert(varchar(10), [8 mL PST Collection Date], 102), '.', '-') 
	end as HP_8_mL_PST_Collection_Date__c,

	case 
		when [4 mL Na-Hep Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [4 mL Na-Hep Collection Date], 102), '.', '-')  
	end as HP_4_mL_Na_Hep_Collection_Date__c,

	case 
		when [4 mL EDTA Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [4 mL EDTA Collection Date], 102), '.', '-')  
	end as HP_4_mL_EDTA_Collection_Date__c,

	case 
		when [1st 10 mL EDTA Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [1st 10 mL EDTA Collection Date], 102), '.', '-')  
	end as HP_1st_10_mL_EDTA_Collection_Date__c,

	case 
		when [2nd 10 mL EDTA Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [2nd 10 mL EDTA Collection Date], 102), '.', '-') 
	end as HP_2nd_10_mL_EDTA_Collection_Date__c,

	case 
		when [Saliva Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Saliva Collection Date], 102), '.', '-') 
	end as HP_Saliva_Collection_Date__c,

	case 
		when [Urine 10 mL Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Urine 10 mL Collection Date], 102), '.', '-')
	end as HP_Urine_10_ml_Collection_Date__c,

	case 
		when [2 mL EDTA Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [2 mL EDTA Collection Date], 102), '.', '-')
	end as HP_2_mL_EDTA_Collection_Date__c,

	case 
		when [Cell-Free DNA Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Cell-Free DNA Collection Date], 102), '.', '-')
	end as HP_Cell_Free_DNA_Collection_Date__c,

	case 
		when [Paxgene RNA Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Paxgene RNA Collection Date], 102), '.', '-') 
	end as HP_Paxgene_RNA_Collection_Date__c,

	case 
		when [Urine 90 mL Collection Date] = '1900-01-01' 
		then ''
		else replace(convert(varchar(10), [Urine 90 mL Collection Date], 102), '.', '-') 
	end as HP_Urine_90_ml_Collection_Date__c

	from [dm_aou].[dbo].[healthpro](nolock) a

	left outer join(
	select r.PMI_Id, r.Contact_Id, r.Journey_Id 
	from [aou_sf].[dbo].[v2_contact_journey_relation] (nolock) r)c on a.[PMI ID] = c.[PMI_Id]
	where c.Journey_Id is not null) a
GO
/****** Object:  View [dbo].[v2_sf_journey_export_update]    Script Date: 7/23/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[v2_sf_journey_export_update] as 
select sjv.*  
from [dbo].[v2_sf_journey_view] sjv
join [dbo].[v2_sf_journey_export_view] sje on (sjv.Id = sje.Id and sjv.rowsha1 != sje.rowsha1)

GO
/****** Object:  View [dbo].[v2_pardot_contact_export_update]    Script Date: 7/23/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[v2_pardot_contact_export_update] as 
select pcew.Id
	  ,[PMI ID_HP] as HP_PMI_ID__c
      ,[Last Name_HP] as LastName
      ,[First Name_HP] as FirstName
      ,[Date of Birth_HP] as Birthdate
      ,[Street Address_HP] as MailingStreet
      ,[City_HP] as MailingCity
      ,'0010a00001Qa6gPAAR' as AccountId
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
	  ,[Email_HP] as Email
      ,[Phone_HP] as Phone
      ,[Sex_HP] as HP_Sex__c
      ,[Gender Identity_HP] as HP_Gender_Identity__c
      ,[Race/Ethnicity_HP] as HP_Race_Ethnicity__c
      ,case when [aou_enroller_RC] is null then ''
      else [aou_enroller_RC]
      end as CH_All_of_Us_Enroller_UNI__c
	  ,[record_id_RC] as CH_REDCap_Record_ID__c
      ---,convert(varchar, [record_id_RC]) as CH_REDCap_Record_ID__c
      ,case when [spec_provider_RC] is null then ''
      else [spec_provider_RC]
      end as CH_Specify_Health_Care_Provider__c
      ,case when [learn_aou_other_RC] is null then ''
      else [learn_aou_other_RC]
      end as CH_Other_details__c
      ,case when [tech_asst_RC] is null then ''
      else ltrim(rtrim([tech_asst_RC]))
      end as CH_Technical_Assistance_Required__c
      ,case when [learn_aou_RC] is null then ''
      else ltrim(rtrim([learn_aou_RC]))
      end as CH_How_did_contact_learn_about_AoU__c
      ,case when [tech_asst_other_RC] is null then ''
      else [tech_asst_other_RC]
      end as CH_Other_technical_assistance_details__c
      ,case when [clinical_outreach_name_RC] is null then ''
      else ltrim(rtrim([clinical_outreach_name_RC]))
      end as CH_Specify_clinical_outreach__c
      ---,[Participant Status_HP] as NYC_AoU_Status__c
      ,[Language_HP] as HP_Language__c
	  ---,[General Consent Date_HP] as Consent_Date 
from [dm_aou].[dbo].[vw_reporting_base] vw
join [dbo].[v2_pardot_contact] pcew on (lower(vw.[Email_HP]) = lower(pcew.Email) or replace(replace(vw.[Phone_HP], '-', ''), ' ', '') = replace(replace(pcew.Phone, '-', ''), ' ', '')) 
and difference(ltrim(rtrim(vw.[Last Name_HP])), ltrim(rtrim(pcew.LastName))) = 4 and difference(ltrim(rtrim(vw.[First Name_HP])), ltrim(rtrim(pcew.FirstName))) = 4

GO
