/****** Object:  View [dbo].[Dashbaord_linkedin_firstname]    Committed by VersionSQL https://www.versionsql.com ******/

 CREATE view [dbo].[Dashbaord_linkedin_firstname] 
 as
 select distinct firstname,CAST(LEN(firstname) AS int) 'firstnamecount' from linkedindata where firstname!='' and  LEN(firstname)<=3 
          
