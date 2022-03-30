/****** Object:  Procedure [dbo].[GetVendorUploadedProfiles]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 28 Jul, 2020
-- Description:	Gets the vendor uploaded profile summary
-- =============================================
CREATE PROCEDURE dbo.GetVendorUploadedProfiles
	@SnapshotId int
AS
/*
exec dbo.GetVendorUploadedProfiles 2007282304
*/
BEGIN
    select *
	from 
		VendorUploadedProfile
	where
		SnapshotId = @SnapshotId
END
