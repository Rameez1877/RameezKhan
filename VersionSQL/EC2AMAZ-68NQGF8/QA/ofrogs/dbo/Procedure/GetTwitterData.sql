/****** Object:  Procedure [dbo].[GetTwitterData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTwitterData] 
	-- Add the parameters for the stored procedure here
	@MagazineId int,
	@Offset int = 0,
	@Limit int = 10000
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select rfi.Id, rfi.Link, rfi.PubDate, rfi.Title, rfi.[Description],rs.Name as [SourceName] 
	from magazine m join magazinetag mt on m.Id = mt.MagazineId join Tag T on mt.TagId = T.Id
	join rssfeeditemtag rfit on rfit.tagid = t.Id join rssfeeditem rfi on rfit.rssfeeditemid = rfi.Id
	join rssfeed rf on rfi.rssfeedid = rf.id join rsssource rs on rf.rsssourceid = rs.id
	where t.tagtypeid in (9,10) and m.Id = @magazineid
	order by rfi.id
	OFFSET @Offset ROWS
	FETCH NEXT @Limit ROWS ONLY
END
