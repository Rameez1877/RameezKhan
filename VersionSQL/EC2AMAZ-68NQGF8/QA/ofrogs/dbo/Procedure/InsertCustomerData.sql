/****** Object:  Procedure [dbo].[InsertCustomerData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <05th Feb 2021>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[InsertCustomerData]
@UserId int,
@Organization varchar(100),
@WebsiteUrl varchar(500),
@CategoryName varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CustomerName varchar(100),@CategoryId int
	DECLARE @Rows int

	SELECT	@CustomerName = OrganizationName
	FROM	AppUser
	WHERE	Id = @UserId

	SELECT	@CategoryId = Id
	FROM	CustomersUploadedDataCategory
	WHERE	Category = @CategoryName
	
	INSERT INTO CustomersUploadedData(CustomerName,UserId,Organization,WebsiteUrl,CategoryId)
	SELECT @CustomerName,@UserId,@Organization,@WebsiteUrl,@CategoryId
	
	SELECT @Rows = @@ROWCOUNT

	PRINT 'Total number of records inserted for client ' + @CustomerName + ' = ' + TRIM(STR(@Rows))
    
END
