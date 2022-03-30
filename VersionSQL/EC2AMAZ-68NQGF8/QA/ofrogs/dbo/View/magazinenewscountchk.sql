/****** Object:  View [dbo].[magazinenewscountchk]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[magazinenewscountchk]
AS
select  tag.name as tagname ,organization.name as organizationname,rssfeeditem.title as title,rssfeeditem.link as link,organization.industryid
 from  rssfeeditem inner join rssfeeditemtag on rssfeeditem.id=rssfeeditemtag.rssfeeditemid
                    inner join tag on tag.id=rssfeeditemtag.tagid
					 inner join magazinetag on rssfeeditemtag.tagid=magazinetag.tagid
					 inner join magazine on magazinetag.magazineid=magazine.id
					 inner join organization on magazine.organizationid=organization.id
