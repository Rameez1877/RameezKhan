/****** Object:  View [dbo].[Dashbaord_linkedin_lastname]    Committed by VersionSQL https://www.versionsql.com ******/

 CREATE view [dbo].[Dashbaord_linkedin_lastname] 
 as
 select  distinct lastname,CAST(LEN(lastname) AS int) 'lastnamecount' from linkedindata where lastname!='' and  LEN(lastname)<=3 
      
