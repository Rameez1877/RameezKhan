/****** Object:  Procedure [dbo].[spGetAwardsByOrgnizationAndID]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure spGetAwardsByOrgnizationAndID
@Org nvarchar(20),
@Id int
as
Begin
	select * from Awards where Organization = @Org and ID = @Id
End
