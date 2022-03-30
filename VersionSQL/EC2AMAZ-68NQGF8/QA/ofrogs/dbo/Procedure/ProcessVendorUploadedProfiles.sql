/****** Object:  Procedure [dbo].[ProcessVendorUploadedProfiles]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 28 Jul, 2020
-- Description:	Gets the vendor uploaded profile summary
-- =============================================
CREATE PROCEDURE [dbo].[ProcessVendorUploadedProfiles]
	@SnapshotId int
AS
/*
exec dbo.ProcessVendorUploadedProfiles 2008071039
*/
BEGIN
    select *, isnull(FirstName, '') + ' ' + isnull(LastName, '') as [Name]
	into #Profiles
	from 
		VendorUploadedProfile
	where
		SnapshotId = @SnapshotId
        and IsProcessed = 0

	insert [SFROGS.OCEANFROGS.COM].sfrogs.dbo.LinkedInDataTemp(UserId, [Name], FirstName, EmailId, PhoneNumber, Source,
		MiddleName, LastName, Organization, Designation, SeniorityLevel, Country, LinkedIn_Country, Keyword,
		Summary, [Url], ResultantCountry, OrganizationAccuracy,City)
	select 
		UserId, [Name], isnull(FirstName, ''), isnull(Email, ''), Phone, 'Vendor',
		'', isnull(LastName, ''), OrganizationName, Designation, 'Others', isnull(Country, ''), isnull(Country, ''), Designation,
		Designation, LinkedInUrl, isnull(Country, ''), 100,City
	from
		#Profiles

    declare @UserId INT
    select @UserId = max(UserId) from #Profiles

    exec('disable trigger SurgeContactDetail_Prevent_delete on SurgeContactDetail')
    delete from SurgeContactDetail where UserId = @UserId and [Url] in (select LinkedInUrl from #Profiles)
    exec('enable trigger SurgeContactDetail_Prevent_delete on SurgeContactDetail')

	insert SurgeContactDetail(UserId, [Name], Designation, EmailId, Phone, GeneratedBy, EmailGeneratedDate, [Url], Organization, [Location], 
		[Source], [SeniorityLevel], IsNew)
	select 
		UserId, [Name], Designation, Email, Phone, 'VerifyEmailAPI', GetUtcDate(), LinkedInUrl, OrganizationName, Country, 
		'Vendor', 'Others', 1
	from
		#Profiles
	where 
        (VerificationStatus = 'Verified' or VerificationStatus is NULL)
        --and EmailVerificationStatus not in ('MailboxDoesNotExist', 'DomainNotFound', 'Domain does not exist. MX record about this domain does not exist. ','Domain does not exist. MX record about this domain does not exist.','Domain does not exist.  MX record about this domain does not exist. ','Failed syntax check')
		and (EmailVerificationStatus not in ('MailboxDoesNotExist', 'DomainNotFound','Failed syntax check','ServerIsCatchAll')
		and EmailVerificationStatus not like '%Domain does not exist%')

	update VendorUploadedProfile
	set
		IsProcessed = 1
	where
		SnapshotId = @SnapshotId
END
