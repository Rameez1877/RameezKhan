/****** Object:  Procedure [dbo].[SearchContactList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SearchContactList]
    @UserID INT,
    @TargetPersonaId int,
	@ResultantCountry varchar(500) = '',
	@Functionality varchar(max) = '',
	@Seniority varchar(500) 
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM ContactSearchFunctionalityResult WHERE UserID = @UserID
DELETE FROM ContactListSearchResult WHERE UserID = @UserID

IF @Seniority = ''
BEGIN
SET @Seniority = 'C-Level,Director,Influencer,Affiliates/Consultants'
END

    DECLARE @AppRoleID int,
			 
			  @TargetPersonaType VARCHAR(20),
			  @TargetPersonaCreateDate DateTime,
			  @COUNT INT
			 
    SELECT
        @UserId = CreatedBy,
        @TargetPersonaType = [Type],
        @TargetPersonaCreateDate = CreateDate
    FROM TargetPersona
    WHERE ID = @TargetPersonaId

  SELECT value as Functionality into #TempFunc FROM STRING_SPLIT(@Functionality, ',')

	INSERT INTO ContactSearchFunctionalityResult (Functionality,USERID)
  SELECT DISTINCT 
  Functionality,@UserID
  FROM #TempFunc
 

  INSERT INTO ContactListSearchResult(ID,UserID)
    SELECT Distinct
	C.LinkedInID,@UserID

    FROM 
	MASTER.ContactListSummary C

        INNER JOIN TargetPersonaOrganization T with (nolock)
        ON (T.OrganizationId = C.OrganizationID )
		where 
		 SeniorityLevel IN (SELECT value FROM STRING_SPLIT(@Seniority, ','))
		 and ResultantCountryId IN (SELECT value FROM STRING_SPLIT(@ResultantCountry, ',')) and t.TargetPersonaId = @TargetPersonaId
		AND T.TargetPersonaId = @TargetPersonaId
		
       
		EXEC [GetContactSearchResult] @UserID,@TargetPersonaID,0,10,'',''
END
