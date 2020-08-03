SELECT c.*
FROM [aou_sf].[dbo].[sf_contact_export_update] c,
     [aou_sf].[dbo].[sf_journey_export_view] j
WHERE c.Id = j.Contact__c
AND j.HP_Withdrawal_Status__c = 0