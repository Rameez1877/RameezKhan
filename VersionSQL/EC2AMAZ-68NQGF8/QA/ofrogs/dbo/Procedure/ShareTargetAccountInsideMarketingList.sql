/****** Object:  Procedure [dbo].[ShareTargetAccountInsideMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <25 June 2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ShareTargetAccountInsideMarketingList]
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int,    --- Sharing User TargetPersonaId
	@UserIds int,   --- Recepient UserId
	@cloneTargetPersonaId int OUTPUT
AS
BEGIN

	DECLARE
	@Name varchar(200),
	@newTargetPersonaId int

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select @Name = Name from TargetPersona
	Where id = @TargetPersonaId

INSERT INTO targetpersona (Name, CreatedBy, CreateDate,EmployeeCounts,Revenues, IsActive, Type, 
AppCategories,NoOfDownloads,Locations, Industries, Technologies, Gics, Segment, Products, Solutions,SequenceNumber)
SELECT Name, @UserIds as CreatedBy, GETDATE() as CreateDate, EmployeeCounts,Revenues, IsActive, Type, 
AppCategories,NoOfDownloads,Locations, Industries, Technologies, Gics, Segment, Products, Solutions,SequenceNumber
FROM  targetpersona where id = @TargetPersonaId

SELECT  @newTargetPersonaId = id 
FROM TargetPersona
WHERE CreatedBy = @UserIds 
AND Name = @Name

INSERT INTO TargetPersonaOrganization (TargetPersonaId, OrganizationId, SortOrder, AccountStatus)
SELECT  @newTargetPersonaId TargetPersonaId, OrganizationId, SortOrder, AccountStatus
FROM  TargetPersonaOrganization
WHERE TargetPersonaId = @TargetPersonaId

--- Saving TargetPersona Configuration

insert into ConfiguredCountry (UserId,TargetPersonaId,CountryId)
select Distinct @userIds,@newTargetPersonaId,u.CountryID from ConfiguredCountry u
where u.TargetPersonaId = @TargetPersonaId

insert into ConfiguredTechnology (UserId,TargetPersonaId,Technology)
select Distinct @userIds,@newTargetPersonaId,u.Technology from ConfiguredTechnology u
where u.TargetPersonaId = @TargetPersonaId

insert into ConfiguredFunctionality (UserId,TargetPersonaId,Functionality)
select Distinct  @userIds,@newTargetPersonaId,u.Functionality from ConfiguredFunctionality u
where u.TargetPersonaId = @TargetPersonaId

SET @cloneTargetPersonaId =  @newTargetPersonaId

END
