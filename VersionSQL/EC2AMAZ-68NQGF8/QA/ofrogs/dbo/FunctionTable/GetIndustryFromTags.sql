/****** Object:  Function [dbo].[GetIndustryFromTags]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetIndustryFromTags]
(
	-- Add the parameters for the function here
	@tagnames varchar(200)
)
RETURNS Table
AS
RETURN
(Select t.id tagid,
t.name tagname,
t.organizationid,
i.industryid,
i.tagid industrytag_tagid, 
ind.name as industryname
from tag t left outer join industrytag i on t.id=i.tagid
left outer join industry ind on i.industryid= ind.id
where t.name like @tagnames+'%' 
and tagtypeid in( 1,27)
)
