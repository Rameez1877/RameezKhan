/****** Object:  Procedure [dbo].[GetSeniorityLevelCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSeniorityLevelCount]
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	CREATE TABLE #TempSeniority
	(ID INT,
	SeniorityLevel VARCHAR(50))

	
INSERT INTO #TempSeniority VALUES (1,'C-Level')
INSERT INTO #TempSeniority VALUES (2,'Director')
INSERT INTO #TempSeniority VALUES (3,'Influencer')
INSERT INTO #TempSeniority VALUES (4,'Strength')
INSERT INTO #TempSeniority VALUES (5,'Affiliates/Consultants')
INSERT INTO #TempSeniority VALUES (6,'Others')



    -- Insert statements for procedure here
	select ts.id, ld.SeniorityLevel, count(*) as Sl_Count from Linkedindata ld
INNER JOIN Tag t ON t.id = ld.TagId
INNER JOIN Organization o ON t.OrganizationId = o.Id
INNER JOIN TargetPersonaOrganization tpo ON tpo.OrganizationId = o.id
INNER JOIN #TempSeniority ts on ts.SeniorityLevel=ld.SeniorityLevel 
where tpo.targetpersonaid = @TargetPersonaId 
and ld.SeniorityLevel in ('C-Level','Director','Influencer','Strength','Others','Affiliates/Consultants')
group by ld.SeniorityLevel , ts.id
order by ts.id

drop table #TempSeniority

END
