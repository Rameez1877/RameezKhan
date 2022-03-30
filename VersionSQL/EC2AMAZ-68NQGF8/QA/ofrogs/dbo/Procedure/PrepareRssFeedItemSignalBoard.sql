/****** Object:  Procedure [dbo].[PrepareRssFeedItemSignalBoard]    Committed by VersionSQL https://www.versionsql.com ******/

--SET IDENTITY_INSERT dbo.OutputIndustrySignalAnalysis OFF

CREATE PROCEDURE [dbo].[PrepareRssFeedItemSignalBoard]
	@RssFeedItemId int
AS
BEGIN
/*
	This stored procedure does the following:
	1. matches with signal ID 
*/
	SET NOCOUNT ON;
	--delete from OutputIndustrySignalAnalysis
	insert into OutputIndustrySignalAnalysis
	select  distinct Region.Name AS RegionName, Continent.Name As ContinentName, Cntry.Name As CountryName, 
	RFII.IndustryId, RF.id, T.Id as tagId, T.name as tagName, 	
	S.DisplayName, --RF.pubdate,
	Null,
	Case when Year(RF.PubDate) = 2017 and month(RF.pubdate) > 6 then 'Q3' + '-2017'
		 when Year(RF.PubDate) = 2017 and month(RF.pubdate) > 3 and month(RF.pubdate) < 7 then 'Q2' + '-2017' 
		 when Year(RF.PubDate) = 2017 and month(RF.pubdate) > 0 and month(RF.pubdate) < 4 then 'Q1' + '-2017' 
		 when Year(RF.PubDate) = 2016 and month(RF.pubdate) > 9 and month(RF.pubdate) < 13 then  'Q4' +'-2016'
	--	when Year(RF.PubDate) = 2016 and month(RF.pubdate) > 6 and month(RF.pubdate) < 10 then 'Q3-2016' 
		else 'Previous Year' 
	end as Quarter, 
    RF.title, RF.link, RF.PubDate --, REPLACE(CONVERT(VARCHAR(11), RF.PubDate, 0),' ','')
	from rssfeeditemsignal RFS
	INNER JOIN Signal S ON RFS.signalId = S.id 
	INNER JOIN rssfeeditem RF ON RFS.RssFeedItemId = RF.Id
	INNER JOIN RssFeedItemIndustry RFII ON RFII.rssfeeditemid = RF.id 
	INNER JOIN rssfeeditemtag RFT ON RF.id = RFT.rssfeeditemid
	INNER JOIN tag T ON RFT.tagid= T.id
	INNER JOIN IndustryTag IT on IT.industryID = RFII.IndustryId and IT.TagId = T.id
	--INNER JOIN IndustrySignal Isi ON Isi.IndustryId = RFII.IndustryId AND Isi.signalId = RFS.SignalId
	LEFT OUTER JOIN Organization Org ON T.OrganizationId = Org.Id
	LEFT OUTER JOIN Country Cntry ON Org.CountryId = Cntry.ID
	LEFT OUTER JOIN Continent ON Continent.Id = Cntry.ContinentId
	LEFT OUTER JOIN Region ON Region.Id = Org.RegionId
	where RFS.rssfeeditemid = RFT.rssfeeditemid 
	and t.tagtypeid = 1
	and Org.isactive = 1 
	and RFII.RssFeedItemId =  @RssFeedItemId
--	and Isi.IndustryId = @SignalIndustry
	---and S.id = @SignalId
	and RFT.ConfidenceLevel = 1
	--and RFS.rssfeeditemid in (select rssfeeditemid from rssfeeditemsignal where signalid = 11)
	order by T.name, S.DisplayName, (RF.PubDate) desc

	---SELECT * FROM OutputIndustrySignalAnalysis

	END
	
