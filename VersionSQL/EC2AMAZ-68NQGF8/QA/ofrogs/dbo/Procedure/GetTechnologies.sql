/****** Object:  Procedure [dbo].[GetTechnologies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,asef>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechnologies] 

AS
BEGIN
	
	SET NOCOUNT ON;
	
	select * from Persona where name in ('Azure',
		'Salesforce','SAP','AWS','Google Cloud Platform(GCP)')
END
