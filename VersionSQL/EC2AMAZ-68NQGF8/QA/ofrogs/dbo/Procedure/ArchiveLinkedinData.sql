/****** Object:  Procedure [dbo].[ArchiveLinkedinData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <16-09-2019>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArchiveLinkedinData]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @MaxId INT

	--1) find the maxId and store it in @MaxId variable. we keep maxid as fixed so that we can use it every where
	SELECT @MaxId = MAX(id)
	FROM linkedindata
	where IsArchive = 0

    -- 2) copy all the newly inserted records from linkedindata table to linkedinData_archive.
	--    records whose isArchive = 0 and id < @MaxId, will be copied to linkedindata_archive.

	INSERT INTO linkedindataArchive (id,name,url,organization,designation,yearofjoining,currentposition,city,state,country,summary,
		 currentrole,previousrole,targetcustomer,decisionmaker,Functionality,userid,lastupdateddate,keyword,
		 FirstName,MiddleName,LastName,education,domainname,emailid,TagId,phonenumber,score,twitter,linkedin_country,suggested_domainname,
		 GoldCustomer,datarating,fcount,accuracy,tagidold,IsActive,OrganizationAccuracy,keywordType,firstsuggested_domainname,lastupdatedon,
		 gender,AggressionLevel,CountryOfOrigin,EmailVerificationStatus,IndustryID,emailgeneratedby,source,datadotcomid,
		 SeniorityLevel,ResultantCountry,EducationLevel,Motivation,Ethnicity,ArchiveDate)

		 SELECT id,name,url,organization,designation,yearofjoining,currentposition,city,state,country,summary,
		 currentrole,previousrole,targetcustomer,decisionmaker,Functionality,userid,lastupdateddate,keyword,
		 FirstName,MiddleName,LastName,education,domainname,emailid,TagId,phonenumber,score,twitter,linkedin_country,suggested_domainname,
		 GoldCustomer,datarating,fcount,accuracy,tagidold,IsActive,OrganizationAccuracy,keywordType,firstsuggested_domainname,lastupdatedon,
		 gender,AggressionLevel,CountryOfOrigin,EmailVerificationStatus,IndustryID,emailgeneratedby,source,datadotcomid,
		 SeniorityLevel,ResultantCountry,EducationLevel,Motivation,Ethnicity,GETDATE()
		 
		  FROM linkedindata 
			WHERE IsArchive = 0 and id <= @MaxId;
			
			-- update the new UniqueId column with the existing UniqueId based on the url

				UPDATE t2 
				SET UniqueId = t1.UniqueId
				FROM LinkedInData t1
				JOIN LinkedInData t2 ON t2.url = t1.url
				WHERE t2.UniqueId = 0
				and t1.UniqueId <> 0
				AND LEFT(t2.url, 1) = LEFT(t1.url, 1)
				and t2.Id <= @MaxId

			--3( disable trigger on delete 
			
				declare @q1 nvarchar(500) 
				set @q1 = 'disable trigger LinkedInData_Prevent_delete on linkedindata'
				EXECUTE sp_executesql @q1

			-- 4 after the copy, remove the duplicate records
			
				;WITH cte AS (
					SELECT 
					  id,
						ROW_NUMBER() OVER (
							PARTITION BY 
								 url
							ORDER BY 
								id desc
                
						) row_num
					 FROM 
						LinkedInData
						where id <= @MaxId
						)
						delete  FROM cte
						WHERE row_num > 1;

				--5) enable trigger on delete
				declare @q2 nvarchar(500)
				set @q2 = 'enable trigger LinkedInData_Prevent_delete on linkedindata'
				EXECUTE sp_executesql @q2
				
	
	-- 6) after removing the duplicate, set isArchive value to 1
	UPDATE linkedindata
		 SET isArchive = 1 where isarchive = 0 and id <= @MaxId; 

END
