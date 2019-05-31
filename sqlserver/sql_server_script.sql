USE [aou_sf]
GO
/****** Object:  Table [dbo].[contact_log]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contact_log](
	[PMI_ID] [varchar](25) NULL,
	[Action] [varchar](max) NULL,
	[Success] [bigint] NULL,
	[Error] [varchar](max) NULL,
	[Last_Modified_Time] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contact_pmi]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contact_pmi](
	[Contact_Id] [varchar](max) NULL,
	[PMI_Id] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[contact]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[contact] as 
select hashbytes('SHA1', (select a.* for xml raw)) as rowsha1
,*
from(
select cp.Contact_Id as Id
	,HP_PMI_ID__c
      ,[Last Name_HP] as LastName
      ,[First Name_HP] as FirstName
      ,[Date of Birth_HP] as Birthdate
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
	,[Email_HP] as Email
	,[Phone_HP] as Phone
      ,[Sex_HP] as HP_Sex__c
      ,[Gender Identity_HP] as HP_Gender_Identity__c
      ,[Race/Ethnicity_HP] as HP_Race_Ethnicity__c
      ,case when [aou_enroller_RC] is null then ''
      else [aou_enroller_RC]
      end as CH_All_of_Us_Enroller_UNI__c
	,convert(varchar, [record_id_RC]) as CH_REDCap_Record_ID__c
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
      ,[Participant Status_HP] as NYC_AoU_Status__c
      ,[Language_HP] as HP_Language__c
	,[General Consent Date_HP] as Consent_Date
from [dm_aou].[dbo].[vw_reporting_base] vw(nolock)
left outer join [aou_sf].[dbo].[Contact_PMI] cp
on HP_PMI_ID__c = cp.PMI_Id
where org_RC = 'Columbia' and [PMI ID_HP] is not null and [Paired Site_HP] is not null ) a
GO
/****** Object:  View [dbo].[contact_status]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[contact_status]
AS
with TABLE1 as (
SELECT   
dbo.contact.*, 
dbo.contact_log.*, 
RANK() OVER (PARTITION BY dbo.contact.HP_PMI_ID__c ORDER BY dbo.contact_log.Last_Modified_Time DESC) AS xrank
FROM  
dbo.contact INNER JOIN
dbo.contact_log ON dbo.contact.HP_PMI_ID__c = dbo.contact_log.PMI_ID)
SELECT  TABLE1.*
FROM    TABLE1
WHERE   TABLE1.xrank = 1
GO
/****** Object:  View [dbo].[contact_status_error]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[contact_status_error]
AS
SELECT        HP_PMI_ID__c, LastName, FirstName, Birthdate, MailingStreet, MailingCity, AccountId, MailingState, MailingPostalCode, Email, Phone, HP_Sex__c, HP_Gender_Identity__c, HP_Race_Ethnicity__c, 
                         CH_All_of_Us_Enroller_UNI__c, CH_REDCap_Record_ID__c, CH_Specify_Health_Care_Provider__c, CH_Other_details__c, CH_Technical_Assistance_Required__c, CH_How_did_contact_learn_about_AoU__c, 
                         CH_Other_technical_assistance_details__c, CH_Specify_clinical_outreach__c, NYC_AoU_Status__c, HP_Language__c, PMI_ID, Action, Success, Error, Last_Modified_Time
FROM            dbo.contact_status
WHERE        (Success = 0) AND (Error NOT LIKE '%duplicate record.%')
GO
/****** Object:  Table [dbo].[contact_journey]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contact_journey](
	[Journey_Id] [varchar](max) NULL,
	[Contact_Id] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[relationship_view]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[relationship_view]
AS
SELECT        dbo.Contact_PMI.Contact_Id, dbo.Contact_PMI.PMI_Id, dbo.Contact_Journey.Journey_Id
FROM            dbo.Contact_Journey LEFT OUTER JOIN
                         dbo.Contact_PMI ON dbo.Contact_Journey.Contact_Id = dbo.Contact_PMI.Contact_Id
GO
/****** Object:  Table [dbo].[contact_sf_export]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contact_sf_export](
	[Id] [varchar](max) NULL,
	[HP_PMI_ID__c] [varchar](max) NULL,
	[LastName] [varchar](max) NULL,
	[FirstName] [varchar](max) NULL,
	[Birthdate] [varchar](max) NULL,
	[MailingStreet] [varchar](max) NULL,
	[MailingCity] [varchar](max) NULL,
	[AccountId] [varchar](max) NULL,
	[MailingState] [varchar](max) NULL,
	[MailingPostalCode] [varchar](max) NULL,
	[Email] [varchar](max) NULL,
	[Phone] [varchar](max) NULL,
	[HP_Sex__c] [varchar](max) NULL,
	[HP_Gender_Identity__c] [varchar](max) NULL,
	[HP_Race_Ethnicity__c] [varchar](max) NULL,
	[CH_All_of_Us_Enroller_UNI__c] [varchar](max) NULL,
	[CH_REDCap_Record_ID__c] [varchar](max) NULL,
	[CH_Specify_Health_Care_Provider__c] [varchar](max) NULL,
	[CH_Other_details__c] [varchar](max) NULL,
	[CH_Technical_Assistance_Required__c] [varchar](max) NULL,
	[CH_How_did_contact_learn_about_AoU__c] [varchar](max) NULL,
	[CH_Other_technical_assistance_details__c] [varchar](max) NULL,
	[CH_Specify_clinical_outreach__c] [varchar](max) NULL,
	[NYC_AoU_Status__c] [varchar](max) NULL,
	[HP_Language__c] [varchar](max) NULL,
	[CreatedDate] [varchar](max) NULL,
	[LastModifiedDate] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[contact_t-1]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[contact_t-1] as 
select 
hashbytes('SHA1', (
select [Id]
,[HP_PMI_ID__c]
,[LastName]
,[FirstName]
,[Birthdate]
,[MailingStreet]
,[MailingCity]
,[AccountId]
,[MailingState]
,[MailingPostalCode]
,[Email]
,[Phone]
,[HP_Sex__c]
,[HP_Gender_Identity__c]
,[HP_Race_Ethnicity__c]
,[CH_All_of_Us_Enroller_UNI__c]
,[CH_REDCap_Record_ID__c]
,[CH_Specify_Health_Care_Provider__c]
,[CH_Other_details__c]
,ltrim(rtrim([CH_Technical_Assistance_Required__c])) as CH_Technical_Assistance_Required__c
,ltrim(rtrim([CH_How_did_contact_learn_about_AoU__c])) as CH_How_did_contact_learn_about_AoU__c
,[CH_Other_technical_assistance_details__c]
,ltrim(rtrim([CH_Specify_clinical_outreach__c])) as CH_Specify_clinical_outreach__c
,[NYC_AoU_Status__c]
,[HP_Language__c]
for xml raw)) as rowsha1
,*
from [dbo].[contact_sf_export]
GO
/****** Object:  Table [dbo].[journey_sf_export]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[journey_sf_export](
	[Id] [varchar](max) NULL,
	[Contact__c] [varchar](max) NULL,
	[AccountId] [varchar](max) NULL,
	[HP_Participant_Status__c] [varchar](max) NULL,
	[HP_General_Consent_Status__c] [bit] NULL,
	[HP_General_Consent_Date__c] [varchar](max) NULL,
	[HP_EHR_Consent_Status__c] [bit] NULL,
	[HP_EHR_Consent_Date__c] [varchar](max) NULL,
	[HP_Withdrawal_Date__c] [varchar](max) NULL,
	[HP_Withdrawal_Status__c] [bit] NULL,
	[HP_Basics_PPI_Survey_Completion_Date__c] [varchar](max) NULL,
	[HP_Health_PPI_Survey_Completion_Date__c] [varchar](max) NULL,
	[HP_Lifestyle_PPI_Survey_Completion_Date__c] [varchar](max) NULL,
	[HP_Hist_PPI_Survey_Completion_Date__c] [varchar](max) NULL,
	[HP_Meds_PPI_Survey_Completion_Date__c] [varchar](max) NULL,
	[HP_Family_PPI_Survey_Completion_Date__c] [varchar](max) NULL,
	[HP_Access_PPI_Survey_Completion_Date__c] [varchar](max) NULL,
	[HP_Physical_Measurements_Completion_Date__c] [varchar](max) NULL,
	[HP_Samples_for_DNA_Received__c] [bit] NULL,
	[HP_8_mL_SST_Collection_Date__c] [varchar](max) NULL,
	[HP_8_mL_PST_Collection_Date__c] [varchar](max) NULL,
	[HP_4_mL_Na_Hep_Collection_Date__c] [varchar](max) NULL,
	[HP_4_mL_EDTA_Collection_Date__c] [varchar](max) NULL,
	[HP_1st_10_mL_EDTA_Collection_Date__c] [varchar](max) NULL,
	[HP_2nd_10_mL_EDTA_Collection_Date__c] [varchar](max) NULL,
	[HP_Saliva_Collection_Date__c] [varchar](max) NULL,
	[HP_Urine_10_ml_Collection_Date__c] [varchar](max) NULL,
	[HP_2_mL_EDTA_Collection_Date__c] [varchar](max) NULL,
	[HP_Cell_Free_DNA_Collection_Date__c] [varchar](max) NULL,
	[HP_Paxgene_RNA_Collection_Date__c] [varchar](max) NULL,
	[HP_Urine_90_ml_Collection_Date__c] [varchar](max) NULL,
	[CreatedDate] [varchar](max) NULL,
	[LastModifiedDate] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[journey_t-1]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[journey_t-1] as 
select 
hashbytes('SHA1', (
SELECT [Id]
      ,[Contact__c]
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
FROM [dbo].[journey_sf_export]
GO
/****** Object:  Table [dbo].[journey_log]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[journey_log](
	[Journey_Id] [varchar](50) NOT NULL,
	[Action] [varchar](25) NULL,
	[Success] [int] NULL,
	[Error] [varchar](max) NULL,
	[Last_Modified_Time] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[journey]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[journey] as 
select
	[PMI ID] as HP_PMI_ID__c,
	'0010a00001Qa6gPAAR' as AccountId, ---Primary Organization Columbia,
	[Participant Status] as HP_Participant_Status__c,
	c.Contact_Id as Contact__c,
	c.Journey_Id as Id,
	case [General Consent Status]
	when 1 then 1 
	when 0 then 0
	end as HP_General_Consent_Status__c,
	replace(convert(varchar(10), [General Consent Date], 102), '.', '-') as HP_General_Consent_Date__c,
	case [EHR Consent Status]
	when 1 then 1 
	when 0 then 0
	end as HP_EHR_Consent_Status__c,
	replace(convert(varchar(10), [EHR Consent Date], 102), '.', '-') as HP_EHR_Consent_Date__c,
	case 
		when [Withdrawal Date] = '1900-01-01' 
		then null
		else [Withdrawal Date]
	end as HP_Withdrawal_Date__c,
    case [Withdrawal Status]
	when 1 then 1
	when 0 then 0
	end as HP_Withdrawal_Status__c,

	case 
		when [Basics PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Basics PPI Survey Completion Date], 102), '.', '-') 
		end as HP_Basics_PPI_Survey_Completion_Date__c,

	case 
		when [Health PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Health PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Health_PPI_Survey_Completion_Date__c,

	case 
		when [Lifestyle PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Lifestyle PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Lifestyle_PPI_Survey_Completion_Date__c,

	case 
		when [Hist PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Hist PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Hist_PPI_Survey_Completion_Date__c,

	case 
		when [Meds PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Meds PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Meds_PPI_Survey_Completion_Date__c,

	case 
		when [Family PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Family PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Family_PPI_Survey_Completion_Date__c,

	case 
		when [Access PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Access PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Access_PPI_Survey_Completion_Date__c,

	case 
		when [Physical Measurements Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Physical Measurements Completion Date], 102), '.', '-') 
	end as HP_Physical_Measurements_Completion_Date__c,

	case [Samples for DNA Received]
		when 1 then 1
		when 0 then 0
	end as HP_Samples_for_DNA_Received__c,

	case 
		when [8 mL SST Collection Date] = '1900-01-01' 
		then null
		else [8 mL SST Collection Date]
	end as HP_8_mL_SST_Collection_Date__c,

	case 
		when [8 mL PST Collection Date] = '1900-01-01' 
		then null
		else [8 mL PST Collection Date]
	end as HP_8_mL_PST_Collection_Date__c,

	case 
		when [4 mL Na-Hep Collection Date] = '1900-01-01' 
		then null
		else [4 mL Na-Hep Collection Date]
	end as HP_4_mL_Na_Hep_Collection_Date__c,

	case 
		when [4 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [4 mL EDTA Collection Date]
	end as HP_4_mL_EDTA_Collection_Date__c,

	case 
		when [1st 10 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [1st 10 mL EDTA Collection Date]
	end as HP_1st_10_mL_EDTA_Collection_Date__c,

	case 
		when [2nd 10 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [2nd 10 mL EDTA Collection Date]
	end as HP_2nd_10_mL_EDTA_Collection_Date__c,

	case 
		when [Saliva Collection Date] = '1900-01-01' 
		then null
		else [Saliva Collection Date]
	end as HP_Saliva_Collection_Date__c,

	case 
		when [Urine 10 mL Collection Date] = '1900-01-01' 
		then null
		else [Urine 10 mL Collection Date]
	end as HP_Urine_10_ml_Collection_Date__c,

	case 
		when [2 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [2 mL EDTA Collection Date]
	end as HP_2_mL_EDTA_Collection_Date__c,

	case 
		when [Cell-Free DNA Collection Date] = '1900-01-01' 
		then null
		else [Cell-Free DNA Collection Date]
	end as HP_Cell_Free_DNA_Collection_Date__c,

	case 
		when [Paxgene RNA Collection Date] = '1900-01-01' 
		then null
		else [Paxgene RNA Collection Date]
	end as HP_Paxgene_RNA_Collection_Date__c,

	case 
		when [Urine 90 mL Collection Date] = '1900-01-01' 
		then null
		else [Urine 90 mL Collection Date]
	end as HP_Urine_90_ml_Collection_Date__c

	from [dm_aou].[dbo].[healthpro](nolock) a
	
	left outer join(
	select [PMI ID_HP],
	from [dm_aou].[dbo].[vw_reporting_base] (nolock))b on a.[PMI ID] = b.[PMI ID_HP]

	left outer join(
	select r.PMI_ID, r.Contact_Id, r.Journey_Id
	from [aou_sf].[dbo].[relationship_view] (nolock) r) c on b.[PMI ID_HP] = c.PMI_Id

	where c.Journey_Id is not null 
GO

/****** Object:  View [dbo].[journey_status]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[journey_status]
AS
with TABLE1 as (
SELECT        dbo.journey.*, dbo.journey_log.*, RANK() OVER (PARTITION BY dbo.journey.HP_PMI_ID__c
ORDER BY dbo.journey_log.Last_Modified_Time DESC) AS xrank
FROM            dbo.journey INNER JOIN
                         dbo.journey_log ON dbo.journey.Id = dbo.journey_log.Journey_Id)
    SELECT        TABLE1.*
     FROM            TABLE1
     WHERE        TABLE1.xrank = 1
GO
/****** Object:  View [dbo].[journey_status_error]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[journey_status_error]
AS
SELECT        AccountId, HP_Participant_Status__c, Contact__c, Id, HP_General_Consent_Status__c, HP_General_Consent_Date__c, HP_EHR_Consent_Status__c, HP_EHR_Consent_Date__c, HP_Withdrawal_Date__c, 
                         HP_Withdrawal_Status__c, HP_Basics_PPI_Survey_Completion_Date__c, HP_Health_PPI_Survey_Completion_Date__c, HP_Lifestyle_PPI_Survey_Completion_Date__c, HP_Hist_PPI_Survey_Completion_Date__c, 
                         HP_Meds_PPI_Survey_Completion_Date__c, HP_Family_PPI_Survey_Completion_Date__c, HP_Access_PPI_Survey_Completion_Date__c, HP_Physical_Measurements_Completion_Date__c, 
                         HP_Samples_for_DNA_Received__c, HP_8_mL_SST_Collection_Date__c, HP_8_mL_PST_Collection_Date__c, HP_4_mL_Na_Hep_Collection_Date__c, HP_4_mL_EDTA_Collection_Date__c, 
                         HP_1st_10_mL_EDTA_Collection_Date__c, HP_2nd_10_mL_EDTA_Collection_Date__c, HP_Saliva_Collection_Date__c, HP_Urine_10_ml_Collection_Date__c, HP_2_mL_EDTA_Collection_Date__c, 
                         HP_Cell_Free_DNA_Collection_Date__c, HP_Paxgene_RNA_Collection_Date__c, HP_Urine_90_ml_Collection_Date__c, Journey_Id, Success, Action, Error, Last_Modified_Time
FROM            dbo.journey_status
WHERE        (Success = 0)

/****** Object:  View [dbo].[contact_new]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[contact_new]
AS
select contact.* from contact
where (contact.Id is null or contact.Id not in 
(select ct.Id from [contact_t-1] ct)
or contact.rowsha1 not in 
(select ct.rowsha1 from [contact_t-1] ct))
GO
/****** Object:  View [dbo].[journey_t]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[journey_t] as 
select hashbytes('SHA1', (select d.* for xml raw)) as rowsha1, * from(select
	c.Journey_Id as Id,
	c.Contact_Id as Contact__c,
	'0010a00001Qa6gPAAR' as AccountId, ---Primary Organization Columbia,
	[Participant Status] as HP_Participant_Status__c,
	[General Consent Status] as HP_General_Consent_Status__c,
	replace(convert(varchar(10), [General Consent Date], 102), '.', '-') as HP_General_Consent_Date__c,
	[EHR Consent Status] as HP_EHR_Consent_Status__c,
	replace(convert(varchar(10), [EHR Consent Date], 102), '.', '-') as HP_EHR_Consent_Date__c,
	case 
		when [Withdrawal Date] = '1900-01-01' 
		then null
		else [Withdrawal Date]
	end as HP_Withdrawal_Date__c,
    [Withdrawal Status] as HP_Withdrawal_Status__c,

	case 
		when [Basics PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Basics PPI Survey Completion Date], 102), '.', '-') 
		end as HP_Basics_PPI_Survey_Completion_Date__c,

	case 
		when [Health PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Health PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Health_PPI_Survey_Completion_Date__c,

	case 
		when [Lifestyle PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Lifestyle PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Lifestyle_PPI_Survey_Completion_Date__c,

	case 
		when [Hist PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Hist PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Hist_PPI_Survey_Completion_Date__c,

	case 
		when [Meds PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Meds PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Meds_PPI_Survey_Completion_Date__c,

	case 
		when [Family PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Family PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Family_PPI_Survey_Completion_Date__c,

	case 
		when [Access PPI Survey Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Access PPI Survey Completion Date], 102), '.', '-') 
	end as HP_Access_PPI_Survey_Completion_Date__c,

	case 
		when [Physical Measurements Completion Date] = '1900-01-01' 
		then null
		else replace(convert(varchar(10), [Physical Measurements Completion Date], 102), '.', '-') 
	end as HP_Physical_Measurements_Completion_Date__c,

	case [Samples for DNA Received]
		when 1 then 1
		when 0 then 0
	end as HP_Samples_for_DNA_Received__c,

	case 
		when [8 mL SST Collection Date] = '1900-01-01' 
		then null
		else [8 mL SST Collection Date]
	end as HP_8_mL_SST_Collection_Date__c,

	case 
		when [8 mL PST Collection Date] = '1900-01-01' 
		then null
		else [8 mL PST Collection Date]
	end as HP_8_mL_PST_Collection_Date__c,

	case 
		when [4 mL Na-Hep Collection Date] = '1900-01-01' 
		then null
		else [4 mL Na-Hep Collection Date]
	end as HP_4_mL_Na_Hep_Collection_Date__c,

	case 
		when [4 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [4 mL EDTA Collection Date]
	end as HP_4_mL_EDTA_Collection_Date__c,

	case 
		when [1st 10 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [1st 10 mL EDTA Collection Date]
	end as HP_1st_10_mL_EDTA_Collection_Date__c,

	case 
		when [2nd 10 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [2nd 10 mL EDTA Collection Date]
	end as HP_2nd_10_mL_EDTA_Collection_Date__c,

	case 
		when [Saliva Collection Date] = '1900-01-01' 
		then null
		else [Saliva Collection Date]
	end as HP_Saliva_Collection_Date__c,

	case 
		when [Urine 10 mL Collection Date] = '1900-01-01' 
		then null
		else [Urine 10 mL Collection Date]
	end as HP_Urine_10_ml_Collection_Date__c,

	case 
		when [2 mL EDTA Collection Date] = '1900-01-01' 
		then null
		else [2 mL EDTA Collection Date]
	end as HP_2_mL_EDTA_Collection_Date__c,

	case 
		when [Cell-Free DNA Collection Date] = '1900-01-01' 
		then null
		else [Cell-Free DNA Collection Date]
	end as HP_Cell_Free_DNA_Collection_Date__c,

	case 
		when [Paxgene RNA Collection Date] = '1900-01-01' 
		then null
		else [Paxgene RNA Collection Date]
	end as HP_Paxgene_RNA_Collection_Date__c,

	case 
		when [Urine 90 mL Collection Date] = '1900-01-01' 
		then null
		else [Urine 90 mL Collection Date]
	end as HP_Urine_90_ml_Collection_Date__c

	from [dm_aou].[dbo].[healthpro](nolock) a
	
	left outer join(
	select 
	[PMI ID_HP] 
	from [dm_aou].[dbo].[vw_reporting_base] (nolock))b on a.[PMI ID] = b.[PMI ID_HP]

	left outer join(
	select r.PMI_ID, r.Contact_Id, r.Journey_Id
	from [aou_sf].[dbo].[relationship_view] (nolock) r) c on b.[PMI ID_HP] = c.PMI_Id
	where c.Journey_Id is not null) d
	
GO
/****** Object:  View [dbo].[journey_new]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[journey_new]
AS
select jt.* from journey_t jt
where (jt.Id is null or jt.Id not in 
(select jt1.Id from [journey_t-1] jt1)
or jt.rowsha1 not in 
(select jt1.rowsha1 from [journey_t-1] jt1))
GO
/****** Object:  Table [dbo].[concept_ancestor]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[concept_ancestor](
	[ancestor_concept_id] [bigint] NULL,
	[descendant_concept_id] [bigint] NULL,
	[min_levels_of_separation] [bigint] NULL,
	[max_levels_of_separation] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contact_error]    Script Date: 5/29/2019 3:27:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contact_error](
	[HP_PMI_ID__c] [varchar](max) NULL,
	[LastName] [varchar](max) NULL,
	[FirstName] [varchar](max) NULL,
	[Birthdate] [varchar](max) NULL,
	[MailingStreet] [varchar](max) NULL,
	[MailingCity] [varchar](max) NULL,
	[AccountId] [varchar](max) NULL,
	[MailingState] [varchar](max) NULL,
	[MailingPostalCode] [varchar](max) NULL,
	[Email] [varchar](max) NULL,
	[Phone] [varchar](max) NULL,
	[HP_Sex__c] [varchar](max) NULL,
	[HP_Gender_Identity__c] [varchar](max) NULL,
	[HP_Race_Ethnicity__c] [varchar](max) NULL,
	[CH_All_of_Us_Enroller_UNI__c] [varchar](max) NULL,
	[CH_REDCap_Record_ID__c] [varchar](max) NULL,
	[CH_Specify_Health_Care_Provider__c] [varchar](max) NULL,
	[CH_Other_details__c] [varchar](max) NULL,
	[CH_Technical_Assistance_Required__c] [varchar](max) NULL,
	[CH_How_did_contact_learn_about_AoU__c] [varchar](max) NULL,
	[CH_Other_technical_assistance_details__c] [varchar](max) NULL,
	[CH_Specify_clinical_outreach__c] [varchar](max) NULL,
	[NYC_AoU_Status__c] [varchar](max) NULL,
	[HP_Language__c] [varchar](max) NULL,
	[PMI_ID] [varchar](max) NULL,
	[Action] [varchar](max) NULL,
	[Success] [bigint] NULL,
	[Error] [varchar](max) NULL,
	[Last_Modified_Time] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO