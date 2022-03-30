/****** Object:  Procedure [dbo].[GetTechnologyInvestmentData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTechnologyInvestmentData] 
	@OrganizationName varchar(100),
	@TechnologyKeyword varchar(100),
	@UserID INT
AS
BEGIN

 SET NOCOUNT ON;
   DELETE FROM CompanySearchResult WHERE USERID = @USERID
   DELETE FROM TechnographicsSearchResult WHERE USERID = @USERID
 set @OrganizationName = REPLACE(@OrganizationName, '-', ' ')

  IF @OrganizationName <> ''
  BEGIN
  DELETE FROM CompanySearchResult WHERE USERID = @USERID
  DELETE FROM TechnographicsSearchResult WHERE USERID = @USERID
 
  INSERT INTO TechnographicsSearchResult (DataString,IsTechnology,UserID)
  VALUES (@OrganizationName,0,@USERID)
    
	EXEC [QA_GetTechnographicResult] @UserId,0,10, '','','','',''

END
  else IF @TechnologyKeyword <> ''
    BEGIN
	DELETE FROM CompanySearchResult WHERE USERID = @USERID
	DELETE FROM TechnographicsSearchResult WHERE USERID = @USERID
	INSERT INTO TechnographicsSearchResult (DataString,IsTechnology,UserID)
	VALUES (@TechnologyKeyword,1,@USERID)

	EXEC [QA_GetTechnographicResult] @UserId,0,10, '','','','',''
END
  END
