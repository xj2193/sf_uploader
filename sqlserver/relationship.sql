TRUNCATE TABLE [dbo].[Relationship];

INSERT INTO [dbo].[Relationship]
           ([Contact_Id]
           ,[PMI_Id]
           ,[Journey_Id])

SELECT CP.[Contact_Id]
      ,CP.[PMI_Id]
      ,CJ.[Journey_Id]
FROM [aou_sf].[dbo].[Contact_PMI](nolock) CP
LEFT OUTER JOIN [aou_sf].[dbo].[Contact_Journey](nolock) CJ ON CP.Contact_Id = CJ.Contact_Id;