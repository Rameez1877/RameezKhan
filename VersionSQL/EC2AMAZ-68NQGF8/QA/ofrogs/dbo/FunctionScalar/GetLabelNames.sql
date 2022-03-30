/****** Object:  Function [dbo].[GetLabelNames]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[GetLabelNames] (@RSSFEEDITEMID INT)
RETURNS int 
AS
BEGIN
	Declare @labelID int
	declare @tempTable TABLE([LabelID] int)

	insert into @tempTable ([LabelID]) (
	select
	case 

/*Operations*/ 
when  (  
title like '%operation%' or
title like '%delay%' or
title like '%congestion%' or
title like '%innovation%' or
title like '%maintenance%' or
title like '%retail%' or
title like '%maintenance%' or
title like '%energy%' or
title like '%ground%' or
title like '%employee%' or
title like '%leadership%' or
title like '%passenger%' or
title like '%survey%' or
title like '%Asset%' or
title like '%Energy%' or
---title like '%Energy Manag%' or
---title like '%Operations Analytic%' or
title like '%on-time%' or
title like '%on time%' or
title like '%Terminal%' or
title like '%Wait time%' or
title like '%Leaderboard%' or
title like '%Safety%' or
title like '%Fire Manag%' or
title like '%resource%' or
title like '%traffic volume%' or
--title like '%flight%' or
---title like '%flights handl%' or
title like '%aircraft%' or
title like '%check-in%' or
title like '%check in%' or
title like '%gate%' or
title like '%baggage%' or
title like '%Cargo%' or
title like '%service quality%' or
--title like '%growth%' or
title like '%new terminal%' or
title like '%passenger%') then 746

/*Finance*/
when  (
title like '%business%' or
title like '%airport business%' or
title like '%profit%' or
title like '%revenue%' or
title like '%Hedg%' or
title like '%gate cost%') then 747

/*Commercial*/
when  (
title like '%operating margin%' or
title like '%commerce%' or 
title like '%expan%'  or
title like '%revenue%' or 
title like '%optimiz%' or
title like '%Commercial%') then 748

/*Airline Marketing*/
when  (

title like '%airline market%' or
title like '%Advertise%' or
title like '%marketing%') then 749 

/*Infrastructure*/
when (
title like '%digital boardroom%' or
title like '%development%' or
title like '%capex%' or

title like '%benchmark%' or
title like '%capacity%') then 750

/*Car Parking Revenue Management*/
when (
title like '%Parking%' or
title like '%car park%') then 751

/*Airport Growth*/
when (title like '%growth%' or
title like '%intelligence%' or
title like '%data integration%' or
title like '%data governance%' or
title like '%concession%' or
title like '%problem%' or
title like '%human resource%' or
title like '%employee strike%' or
title like '%passenger experience%' or
title like '%Analytic%' or
title like '%Airside%' or
title like '%energy%' or
title like '%Contract%' or
title like '%Portfolio%' or
title like '%Procure %' or
title like '%retail%' or
title like '%IOT%' or
title like '%dip%' or
title like '%diligence%' or
title like '%enterprise data%' or
title like '%data%' or
title like '%speech analytic%' or
title like '%forecast%' or
title like '%pax%' or
title like '%economic value%' or
title like '%analysis%' or
title like '%projection%' or
title like '%demand%' or
title like '%price%' or
title like '%data quality%' or
title like '%customer%') then 753

/*Operations*/ 
when  (  
News like '%operation%' or
News like '%delay%' or
News like '%congestion%' or
News like '%maintenance%' or
News like '%retail%' or
News like '%energy%' or
News like '%groud handl%' or
News like '%employee%' or
News like '%leadership%' or
News like '%passenger%' or
News like '%Asset%' or
News like '%Energy%' or
News like '%Energy Manag%' or
News like '%Operation%' or
News like '%on-time%' or
News like '%on time%' or
News like '%Terminal%' or
News like '%Wait time%' or
News like '%Leaderboard%' or
News like '%Safety%' or
News like '%Fire Manage%' or
News like '%resource%' or
News like '%terminal%' or
News like '%traffic%' or
News like '%flight%' or
News like '%aircraft%' or
News like '%check-in%' or
News like '%check in%' or
News like '%gate%' or
News like '%baggage%' or
News like '%Cargo volume%' or
News like '%service quality%' or
--News like '%growth%' or
News like '%new terminal%' or
News like '%passenger%') then 746

/*Finance*/
when  (
News like '%business%' or
News like '%profit%' or
News like '%revenue%' or
News like '%Hedg%' or
News like '%gate cost%') then 747

/*Commercial*/
when  (
News like '%commerce%' or 
News like '%optimiz%' or
News like '%airport reail%'  or
News like '%expan%'  or
News like '%Commercial%') then 748

/*Airline Marketing*/
when  (
News like '%airline market%' or
News like '%Advertise%' or
News like '%marketing%') then 749 

/*Infrastructure*/
when (
News like '%digital boardroom%' or
News like '%development%' or
News like '%CAPEX%' or
News like '%benchmark%' or
News like '%capacity%') then 750

/*Car Parking Revenue Management*/
when (
News like '%Park%' or
News like '%car park%') then 751

/*Airport Growth*/
when (
News like '%Growth%'  or

News like '% IOT %'  or
News like '%innovation%' or
News like '%management%' or
News like '%intelligence%' or
News like '%business intelligence%' or
News like '%artificial intelligence%' or
News like '%data integration%' or
News like '%baggage handl%' or
News like '%data governance%' or
News like '%concession%' or
News like '%human resource%' or
News like '%employee strike%' or
News like '%passenger experience%' or
News like '%Analytic%' or
News like '%Airside%' or
News like '%energy%' or
News like '%Contract%' or
News like '%Portfolio%' or
News like '%Procure %' or
News like '%retail%' or
News like '%gate cost%' or
News like '%IOT%' or
News like '%dip%' or
News like '%due diligence%' or
News like '%operating margin%' or
News like '%enterprise data%' or
News like '%speech analytic%' or
News like '%forecast%' or
News like '%pax%' or
News like '%economi%' or
News like '%economic%' or
News like '%analysis%' or
News like '%projection%' or
News like '%demand%' or
News like '%price%' or
News like '%data quality%' or
News like '%customer%') then 752
	
	
	else 753
	end  labelID
	
	from rssfeeditem where ID = @RSSFEEDITEMID)


	select @labelID =   T.[LabelID] from (select [LabelID]  from @temptable) T
	return @labelID
END
