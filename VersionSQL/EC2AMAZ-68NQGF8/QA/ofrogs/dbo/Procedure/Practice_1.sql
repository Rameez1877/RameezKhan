/****** Object:  Procedure [dbo].[Practice_1]    Committed by VersionSQL https://www.versionsql.com ******/

Create procedure Practice_1
as
Select tag.*,industrytag.IndustryId from tag
inner join industrytag on tag.id=industrytag.tagid
where tagtypeid = 1
