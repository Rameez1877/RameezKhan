/****** Object:  Procedure [dbo].[ConfigureNewUserAccount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <19th Feb 2021>
-- Description:	<Configure new users account>
-- =============================================
CREATE PROCEDURE ConfigureNewUserAccount
@UserId int,
@CountryId int = 0,
@Functionality varchar(100) = '',
@Technology varchar(100) = '',
@ApplyScore varchar(100) = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF @CountryId <> 0
		BEGIN
		
			INSERT INTO UserTargetCountry(UserId,CountryId) VALUES
			(@UserId,@CountryId)

		END

	IF @Functionality <> ''
		BEGIN

			INSERT INTO UserTargetFunctionality(UserId,Functionality,ApplyScore) VALUES
			(@UserId,@Functionality,@ApplyScore)

		END

	IF @Technology <> ''
		BEGIN

			INSERT INTO UserTargetTechnology(UserId,Technology,ApplyScore) VALUES
			(@UserId,@Technology,@ApplyScore)

		END
    
END
