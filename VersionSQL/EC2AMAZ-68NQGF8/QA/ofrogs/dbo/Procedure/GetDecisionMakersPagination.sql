﻿/****** Object:  Procedure [dbo].[GetDecisionMakersPagination]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersPagination] @TargetPersonaId int,
@Page Int =1,
@Size Int =25
AS
-- ==========================================================================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page   
-- ==========================================================================================   
-- [GetDecisionMakersPagination] 1    
BEGIN
  DECLARE @AppRoleID int,
          @UserId int,
		  @TargetPersonaType VARCHAR(20),
		  @TargetPersonaCreateDate DateTime
  SELECT
    @UserId = CreatedBy,
	@TargetPersonaType = Type,
	@TargetPersonaCreateDate = CreateDate
  FROM TargetPersona
  WHERE ID = @TargetPersonaId


  CREATE TABLE #TempFinal
  (TotalRecords INT,
  Id INT,
		
      Gender VARCHAR(100),
      FirstName VARCHAR(1000),
      LastName VARCHAR(1000),
      Username VARCHAR(1000),
     Name VARCHAR(1000),
      Designation VARCHAR(1000),
      Organization VARCHAR(1000),
      EmailId VARCHAR(1000),
	  Phone VARCHAR(1000),
	  ContactsUrl VARCHAR(1000),
      Country VARCHAR(1000),
      Url VARCHAR(1000),
	  Functionality VARCHAR(1000),
      SeniorityLevel VARCHAR(1000),
	  isNew int,
	  EmailGeneratedDate varchar(100),
	  TargetPersonaCreateDate varchar(100),
	  SurgeContactId int)

  SELECT
    @AppRoleID = A.AppRoleID
  FROM AppUser A
  WHERE A.Id = @UserId
  begin
  IF @AppRoleID <> 3
  INSERT INTO #TempFinal
    SELECT 
	count(*) over() as TotalRecords,
      li.Id,
      li.Gender,
      li.FirstName,
      li.LastName,
      li.[Name] + ', ' + li.Designation AS [Username],
      li.[Name],
      li.Designation,
      o.name AS Organization,
      s.EmailId,
	  s.Phone,
	  s.Url,
      li.ResultantCountry AS Country,
      li.[Url],
	  ml.name AS [Functionality],
      li.SeniorityLevel,
	  s.isNew,
	  CONVERT(VARCHAR, s.EmailGeneratedDate, 106) as EmailGeneratedDate,
	  CONVERT(VARCHAR, @TargetPersonaCreateDate, 106) as TargetPersonaCreateDate,
	  s.id
  FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml with (nolock)
      ON (li.Id = ml.DecisionMakerId)
     INNER JOIN dbo.Tag T
      ON (T.Id = li.TagId
      AND T.TagTypeId = 1)
    INNER JOIN dbo.Organization o
      ON (o.id = t.organizationid)
	 LEFT OUTER JOIN Industry i
      ON (o.IndustryId = I.id)
	  left outer join SurgeContactDetail s
      --on (li.id = s.linkedinId
	  on (li.url = s.Url
      and s.UserId = @UserId
      and s.Source = 'Target Accounts'
	  )
    WHERE ml.mode = 'Keyword Based List'
    AND li.[Url] <> ''
    AND T.OrganizationId IN (SELECT
      OrganizationId
    FROM TargetPersonaOrganization
    WHERE TargetPersonaId = @TargetPersonaId)
 --  AND  li.SeniorityLevel IN ('C-Level','Director')
   AND  li.SeniorityLevel IN (select seniority from UserTargetSeniority where userid=@UserId)

	--
	-- 27 Jan 2020 Added Configuration For Filtering Country and Functionality 
	--
and (li.ResultantCountry)IN (Select Name from UserTargetCountry U, Country C WHERE UserId = @UserId and u.countryid=c.id )--rtrim removed
AND ml.name  IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )
order by EmailGeneratedDate 
OFFSET (@Page -1) * @Size ROWS
FETCH NEXT @Size ROWS ONLY


  ELSE
  INSERT into #TempFinal
    SELECT TOP 500
      li.Id,
      li.Gender,
      li.FirstName,
      li.LastName,
      li.[Name] + ', ' + li.Designation AS [Username],
      li.[Name],
      li.Designation,
      o.name AS Organization,
      '**********' EmailId,-- email id hidden for demo account janna changed on 17th Oct 2019
     (li.ResultantCountry) AS Country,
      li.[Url],
      v.FunctionalityDisplay AS [Functionality],
      li.SeniorityLevel,
	  null as  EmailId
     FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml with (nolock)
      ON (li.Id = ml.DecisionMakerId)
    INNER JOIN dbo.V_Functionality v
      ON (v.Functionality = ml.[Name])
    INNER JOIN dbo.Tag T
      ON (T.Id = li.TagId
      AND T.TagTypeId = 1)
    INNER JOIN dbo.Organization o
      ON (o.id = t.organizationid)
    LEFT OUTER JOIN Industry i
      ON (o.IndustryId = I.id)
     WHERE ml.mode = 'Keyword Based List'
    AND li.[Url] <> ''
    AND T.OrganizationId IN (SELECT
      OrganizationId
    FROM TargetPersonaOrganization
    WHERE TargetPersonaId = @TargetPersonaId)
     AND (li.ResultantCountry) <> ''
end 

--select Id,
--      Gender,
--      FirstName,
--      LastName,
--      Username,
--     Name,
--      Designation,
--      Organization ,
--      EmailId,
--      Country,
--      Url,
--      SeniorityLevel,
--	  STUFF((select ', ' + cast(t2.functionality as varchar)
--            from  #TempFinal t2
--            where t1.id=t2.id
--            for xml path(''))
--        , 1, 1, '') functionality
--	  from #TempFinal t1
--	  group by Id,
--      Gender,
--      FirstName,
--      LastName,
--      Username,
--     Name,
--      Designation,
--      Organization ,
--      EmailId,
--      Country,
--      Url,
--	  SeniorityLevel

select * from #TempFinal order by EmailGeneratedDate desc

END
