select top(50)
	---[PMI ID] as HP_PMI_ID__c,
	b.HP_PMI_ID__c,
	b.HP_PMI_ID__c as Name,
	 ---'0010a00001Qa6gPAAR' as AccountId ---Primary Organization Columbia,
	[Participant Status] as HP_Participant_Status__c,
	'NEW' as StageName,
	[General Consent Date] as CloseDate,

	case [General Consent Status]
		when 1 then 1
		when 0 then 0
	end as HP_General_Consent_Status__c,
	
	[General Consent Date] as HP_General_Consent_Date__c,
	
	case [EHR Consent Status]
		when 1 then 1
		when 0 then 0
	end as HP_EHR_Consent_Status__c,
	
	[EHR Consent Date] as HP_EHR_Consent_Date__c,
	
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
		else [Basics PPI Survey Completion Date]
	end as HP_Basics_PPI_Survey_Completion_Date__c,

	case 
		when [Health PPI Survey Completion Date] = '1900-01-01' 
		then null
		else [Health PPI Survey Completion Date]
	end as HP_Health_PPI_Survey_Completion_Date__c,

	case 
		when [Lifestyle PPI Survey Completion Date] = '1900-01-01' 
		then null
		else [Lifestyle PPI Survey Completion Date]
	end as HP_Lifestyle_PPI_Survey_Completion_Date__c,

	case 
		when [Hist PPI Survey Completion Date] = '1900-01-01' 
		then null
		else [Hist PPI Survey Completion Date]
	end as HP_Hist_PPI_Survey_Completion_Date__c,

	case 
		when [Meds PPI Survey Completion Date] = '1900-01-01' 
		then null
		else [Meds PPI Survey Completion Date]
	end as HP_Meds_PPI_Survey_Completion_Date__c,

	case 
		when [Family PPI Survey Completion Date] = '1900-01-01' 
		then null
		else [Family PPI Survey Completion Date]
	end as HP_Family_PPI_Survey_Completion_Date__c,

	case 
		when [Access PPI Survey Completion Date] = '1900-01-01' 
		then null
		else [Access PPI Survey Completion Date]
	end as HP_Access_PPI_Survey_Completion_Date__c,

	case 
		when [Physical Measurements Completion Date] = '1900-01-01' 
		then null
		else [Physical Measurements Completion Date]
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

	from [dm_aou].[dbo].[healthpro] a
	
	left outer join(
	select concat('P00000',[Row_Id]) as HP_PMI_ID__c,
	[PMI ID_HP] as PMI_ID_2
	from [dm_aou].[dbo].[vw_reporting_base])b on a.[PMI ID] = b.PMI_ID_2

	where [PMI ID] in
	('P100416414',
	 'P100428294',
	 'P100686729',
	 'P100751043',
	 'P100795163',
	 'P100859870')