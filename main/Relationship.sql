USE [aou_sf]
GO

DROP TABLE [dbo].[Relationship]
GO

INSERT INTO [dbo].[Relationship]
           ([Contact_Id]
           ,[PMI_Id]
           ,[Journey_Id])

SELECT CP.[Contact_Id]
      ,CP.[PMI_Id]
      ,CJ.[Journey_Id]
FROM [aou_sf].[dbo].[Contact_PMI] CP
LEFT OUTER JOIN [aou_sf].[dbo].[Contact_Journey] CJ ON CP.Contact_Id = CJ.Contact_Id 

GO