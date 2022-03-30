/****** Object:  Procedure [dbo].[GetSurgeDataPagination]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSurgeDataPagination] 
	@UserId Int =1,
	@Page Int =1,
    @Size Int =100000
	
AS
BEGIN

declare @AppRoleId INT, @TopCount INT ,@TechnologyCount INT

Select @TechnologyCount = count(*) from UserTargetTechnology WHERE UserId = @UserId


select @AppRoleId = AppRoleId from appuser
where id=@UserId

if @AppRoleId = 3 
SET @TopCount = 50
else
SET @TopCount = 9999999

SET NOCOUNT ON;
--
-- Insert statements for procedure here
--

If @TechnologyCount > 0 
begin
if @AppRoleId <> 4 
SELECT 
  Organization ,
  OrganizationId,
  Industry,
  Functionality,
  Technology,
  TechnologyCategory,
  investmentType,
  CountryName,
  duration,
  Surge,
  Revenue,
  NOOFdecisionmaker
FROM SurgeSummary with (nolock)
WHERE CountryName IN (Select Name from UserTargetCountry U, Country C WHERE UserId = @UserId and u.countryid=c.id )
AND Functionality IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )
AND Technology IN (Select technology from UserTargetTechnology WHERE UserId = @UserId union select 'NA' )
ORDER BY NOOFdecisionmaker DESC,Surge DESC
OFFSET (@Page -1) * @Size ROWS
FETCH NEXT @Size ROWS ONLY
else
SELECT 
  Organization ,
  OrganizationId,
  Industry,
  Functionality,
  Technology,
  TechnologyCategory,
  investmentType,
  CountryName,
  duration,
  Surge,
  Revenue,
  NOOFdecisionmaker
FROM SurgeSummary with (nolock)
WHERE CountryName IN (Select Name from UserTargetCountry U, Country C WHERE UserId = @UserId and u.countryid=c.id )
AND Functionality IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )
AND Technology IN (Select technology from UserTargetTechnology WHERE UserId = @UserId union select 'NA' )
and InvestmentType in ('Champion','Investment Made')
ORDER BY NOOFdecisionmaker DESC,Surge DESC
OFFSET (@Page -1) * @Size ROWS
FETCH NEXT @Size ROWS ONLY
end 
else

begin
if @AppRoleId <> 4 
SELECT 
  Organization ,
  OrganizationId,
  Industry,
  Functionality,
  TechnologyCategory,
  Technology,
  investmentType,
  CountryName,
  duration,
  Surge,
  Revenue,
  NOOFdecisionmaker
FROM SurgeSummary with (nolock)
WHERE CountryName IN (Select Name from UserTargetCountry U, Country C WHERE UserId = @UserId and u.countryid=c.id )
AND Functionality IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )
ORDER BY NOOFdecisionmaker DESC,Surge DESC
OFFSET (@Page -1) * @Size ROWS
FETCH NEXT @Size ROWS ONLY
else
SELECT 
  Organization ,
  OrganizationId,
  Industry,
  Functionality,
  TechnologyCategory,
  Technology,
  investmentType,
  CountryName,
  duration,
  Surge,
  Revenue,
  NOOFdecisionmaker 
FROM SurgeSummary with (nolock)
WHERE CountryName IN (Select Name from UserTargetCountry U, Country C WHERE UserId = @UserId and u.countryid=c.id )
AND Functionality IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )
and InvestmentType in ('Champion','Investment Made')
ORDER BY NOOFdecisionmaker DESC,Surge DESC
OFFSET (@Page -1) * @Size ROWS
FETCH NEXT @Size ROWS ONLY
end 
END
