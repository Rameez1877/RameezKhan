/****** Object:  Procedure [dbo].[GetVendorUploadedProfileSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 28 Jul, 2020
-- Description:	Gets the vendor uploaded profile summary
-- =============================================
CREATE PROCEDURE [dbo].[GetVendorUploadedProfileSummary]
	
AS
/*
exec dbo.GetVendorUploadedProfileSummary
*/
BEGIN
    select u.[Name], CreatedDate, SnapshotId, count(1) as ProfileCount
	from 
		VendorUploadedProfile p
		inner join AppUser u on (p.CreatedBy = u.Id)
	where
		IsProcessed = 0
	group by
		u.[Name], CreatedDate, SnapshotId
	order by
		p.CreatedDate DESC
END
