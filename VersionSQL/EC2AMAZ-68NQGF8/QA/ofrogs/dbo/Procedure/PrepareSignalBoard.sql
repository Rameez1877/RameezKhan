/****** Object:  Procedure [dbo].[PrepareSignalBoard]    Committed by VersionSQL https://www.versionsql.com ******/

--SET IDENTITY_INSERT dbo.OutputIndustrySignalAnalysis OFF

CREATE PROCEDURE [dbo].[PrepareSignalBoard]
	@IndustryId int
AS
BEGIN
/*
	This stored procedure does the following:
	1. matches with signal ID 
*/
	SET NOCOUNT ON;
	--delete from OutputIndustrySignalAnalysis where industryid = @IndustryId
insert into OutputIndustrySignalAnalysis
	select  distinct Region.Name AS RegionName, Continent.Name As ContinentName, Cntry.Name As CountryName, 
	RFII.IndustryId, RF.id, T.Id as tagId, T.name as tagName, 	
	S.DisplayName, --RF.pubdate,
	Null,
	Case when Year(RF.PubDate) = 2017 and month(RF.pubdate) > 6 then '2017' + '-Q3'
		 when Year(RF.PubDate) = 2017 and month(RF.pubdate) > 3 and month(RF.pubdate) < 7 then '2017' + '-Q2' 
		 when Year(RF.PubDate) = 2017 and month(RF.pubdate) > 0 and month(RF.pubdate) < 4 then '2017' + '-Q1' 
		 when Year(RF.PubDate) = 2016 and month(RF.pubdate) > 9 and month(RF.pubdate) < 13 then  '2016' +'-Q4'
	--	when Year(RF.PubDate) = 2016 and month(RF.pubdate) > 6 and month(RF.pubdate) < 10 then 'Q3-2016' 
		else '2016-Q3 or Before' 
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
--	and RFS.signalid in (3,7)
	and year(RF.pubdate) in (2016,2017)
--	and RFT.tagid in (268, 3263 ,266, 398)
	and t.tagtypeid = 1
	and Org.isactive = 1 
	and RFII.IndustryId =  @IndustryId
--	and Isi.IndustryId = @SignalIndustry
	---and S.id = @SignalId
	and RFT.Confidencescore > 0.5
	--and RFS.rssfeeditemid in (select rssfeeditemid from rssfeeditemsignal where signalid = 11)
	order by T.name, S.DisplayName, (RF.PubDate) desc

	---SELECT * FROM OutputIndustrySignalAnalysis

	END
	
