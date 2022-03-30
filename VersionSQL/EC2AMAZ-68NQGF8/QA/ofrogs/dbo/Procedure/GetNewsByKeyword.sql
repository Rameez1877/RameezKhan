/****** Object:  Procedure [dbo].[GetNewsByKeyword]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[GetNewsByKeyword]
@RssFeedItemId int
As
Begin
	--declare @Keyword varchar(50);
	--declare @id int;
	--declare @mydate date;

		SET NOCOUNT ON;
			DECLARE @LabelNews TABLE 
	(
		rssfeedItemID int,
		LabelId int
	)

	insert into @LabelNews (rssfeedItemID, LabelId)
	select id,
	-- TITLE, PUBDATE, description, 
	case
	when title like '%SDG%' then 143
	/*clean water and sanitation*/ 
		when title like '%malnutrition%' or
title like '%latrine%' or
title like '%sanitation%' or
title like '%hygiene%' or
title like '%diarrhoeal%' or
title like '%recycling%' or
title like '%toilet%' or
title like '%drinking water%' or
title like '%clean water%' or
title like '%defecate%' or
title like '%water contamination%' or
title like '%water scarcity%' or
title like '%waste water%' or
title like '%water source%' or
title like '%toilet day%' or
title like '%water resource%' or
title like '%water stress%' or
title like '%water supply%' or
title like '%handwash%' or
title like '%wastewater%' or
title like '%water cycle%' or
title like '%groundwater%' or
title like '%water table%' or
title like '%water management%' or
title like '%wastewater management%' or
title like '%wastewater%' or
title like '%water cycle%' or
title like '%groundwater%' or
title like '%water table%' or
title like '%water management%' or
title like '%wastewater management%'  then 103
-- 'SDG6 Clean Water and Sanitation'
/*climate action*/ 
		when title like '%climate change%' or title like '%green house%' or title like '%biodiversity%'	or title like '%afforestation%'	or
			   title like '%carbon emission%' or title like '%Chlorofluorocarbon%' or title like '%Clean Energy%' or title like '%Climate Control%'	or
			   title like '%desertification%'	or
title like '%GHG%'	or
title like '%Global Warming%'	or
title like '%Green Cover%'	or
title like '%greenhouse emission%'	or
title like '%greenhouse gas%'	or
title like '%greenpeace%'	or
title like '%PARIS AGREEMENT%'	or
title like '%flood%' or
title like '%ozone layer%'	or
title like '%polluted Environment%'	or
title like '%tsunami%' then 135
--'SDG13 Climate Action'
	 /*no poverty*/
	 when title like '%poverty%' or title like'%basic amenities	%' or
title like'%below poverty%' or
title like'%cash transfer%' or
title like'%child labour%' or
title like'%child mortality%'or
title like'%developing country%'or
title like'%end poverty%'or
title like'%eradicate%'or
title like'%extreme poverty%'or
title like'%farmer suicide%'or
title like'%no poverty%'or
title like'%Poverty alleviation%'or
title like'%poverty eradication%'or
title like'%poverty line%'or
title like'%poverty reduction%'or
title like'%poverty score%'or
title like'%rural development%'or
title like'%SDG 1%'or
title like'%social discrimination%'or
title like'%social injustice%'or
title like'%third world%'or
title like'%uneven progress%'or
title like'%urban poverty%'or
title like'%Youth Employment%'
 then 1
 --'SDG 1 No Poverty'
 /*Education*/
when title like '%education%' or title like '%literacy%' or title like '%adult education%'	or
title like '%disadvantaged children%' or
title like '%basic amenities%' or
title like '%social discrimination%' or
title like '%secondary education%' or
title like '%primary education%' or
title like '%quality education%' or
title like '%child marriage%' or
title like '%Secondary School%' or
title like '%Primary School%' or
title like '%underpriviledged children%' or
title like '%socio economic change%' or
title like '%social impact%' or
title like '%adult education%' or
title like '%youth education%' or
title like '%nursery school%' or
title like '%kindergarten%' or
title like '%education policy%' or
title like '%education system%' or
title like '%education fund%' or
title like '%disadvantaged children%' or
title like '%vocational training%' or
title like '%skilled labour%' or
title like '%enrolment rate%' or
title like '%Rural Education%' or
title like '%SDG 4%' or
title like '%Childhood education%' or
title like '%underpriviledged children%' then 69
--'SDG4 Quality Education'
/*zero hunger*/
when title like '%food assistance%' or
title like '%food availability%' or
title like '%food production%' or
title like '%food program%' or
title like '%food security%' or
title like '%food supply%' or
title like '%famine%' or
title like '%FAO%' or
title like '%fight hunger%' or
title like '%end hunger%' or
title like '%eliminate hunger%' or
title like '%agriculture%' or
title like '%agriculture organization%' or
title like '%SDG 2%' or
title like '%malnutrition%' or
title like '%humanitarian%' or
title like '%zero hunger%' or
title like '%undernourish%' or
title like '%subsidy%' then 2
---'SDG 2 Zero Hunger'
/*SDG 10 Reduced Inequalities*/
when title like '%generate employment%' then 'SDG10 Reduce Inequality within and among countries'
/*Good Health and well being*/
when title like '%substance abuse%' or
title like '%substance use disorder%' or
title like '%Tobacco Control%' or
title like '%undernutrition%' or
title like '%tuberculosis%' or
title like '%universal access%' or
title like '%tropical disease%' or
title like '%vaccine%' or
title like '%water borne disease%' or
title like '%health care%' or
title like '%health hazard%' or
title like '%health risk%' or
title like '%Health service%' or
title like '%Immunization%' or
title like '%infant mortality%' or
title like '%malaria%' or
title like '%malnourish%' or
title like '%malnutrition%' or
title like '%Maternal Health%' or
title like '%maternal mortality%' or
title like '%Medical equipment%' or
title like '%Mental health%' or
title like '%mortality rate%' or
title like '%Neonatal Health%' or
title like '%SDG 3%' or
title like '%social discrimination%' or
title like '%premature death%' or
title like '%preventable death%' or
title like '%Primary care%' or
title like '%polio drops%' or
title like '%Public health%' or
title like '%respiratory disorder%' or
title like '%respiratory infection%' or
title like '%air pollution%' or
title like '%affordable medicine%' or
title like '%alcohol addiction%' or
title like '%child mortality%' or
title like '%cardiovascular disease%' or
title like '%Child care%' or
title like '%child death%' or
title like '%cancer%' or
title like '%drug abuse%' or
title like '%dengue%' or
title like '%contraceptive use%' or
title like '%fighting AIDS%' or
title like '%fighting HIV%' or
title like '%epedemic%' or
title like '%good health%' then 33
-- 'SDG 3 Good Health and well being'
/*ECONOMIC GROWTH*/
when title like '%gross domestic product%' or
title like '%financial exclusion%' or
title like '%financial inclusion%' or
title like '%entrepreneur%' or
title like '%economic activities%' or
title like '%job create%' or
title like '%labour rights%' or
title like '%inclusive growth%' or
title like '%human trafficking%' then 681
--'SDG 8 economic growth'
/*Industry Innovation and Infrastructure*/
when title like '%income inequality%' or
title like '%inclusion%' or
title like '%imbalance%' or
title like '%infrastructure	%' or
title like '%Investment%' or
title like '%small enterprise%' or
title like '%small scale%' or
title like '%SDG 10%' or
title like '%Rising inequality%' or
title like '%employment%' or
title like '%empower%' or
title like '%equal opportunity%' or
title like '%encourage innovation%' or
title like '%encourage research%' or
title like '%foster innovation%' or
title like '%economic development%' or
title like '%SDG 9%' or
title like '%industrial development%' or
title like '%industrialization%' or
title like '%upgrade infrastructure%' or
title like '%technology development%' or
title like '%sustainable development%' then 736
--'SDG 9 Industry Innovation and Infrastructure'
/*SDG10 Reduce Inequality within and among countries*/
when title like '%Reduce Inequality%' or
title like '%gender inequality%' then 682
--'SDG10 Reduce Inequality within and among countries'
/*Safe and Sustainable cities*/
when title like '%safety record%' or
title like '%sustainable city%' then 683
--'SDG11 Safe and Sustainable cities'
/*Sustainable production and consumption*/
when title like '%sustainable consumption%' or
title like '%sustainable production%' or
title like '%SDG 12%' or
title like '%reduce waste%' or
title like '%reduce food loss%' or
title like '%material footprint%' or
title like '%hazardous chemical%' or
title like '%hazardous waste%' or
title like '%food loss%' or
title like '%consumption%' then 684
--'SDG12 Sustainable production and consumption'
/*Conservation of Marine Resources*/
when title like '%unregulated fishing%' or
title like '%SDG 14%' or
title like '%regulated fishing%' or
title like '%marine acidity%' or
title like '%marine economy%' or
title like '%marine life%' or
title like '%marine pollution%' or
title like '%ocean acidification%' or
title like '%overfish%' or
title like '%overfishing%' or
title like '%ph level%' or
title like '%plastic debris%' or
title like '%hydrological systems%' or
title like '%illegal fishing%' or
title like '%fish stock%' or
title like '%fishery%' or
title like '%fishing practice%' or
title like '%aquatic animal%' or
title like '%aquatic plant%' or
title like '%desilt%' or
title like '%coastal communities%' or
title like '%coastal community%' or
title like '%coastal ecosystem%' then 662
--'SDG14 Conservation of Marine Resources'
/*Life On Land*/
when title like '%combat%' or
title like '%deforestation%' or
title like '%conservation%' or
title like '%desertification%' or
title like '%ecosystem%' or
title like '%alien species%' or
title like '%afforestation%' or
title like '%biodiversity%' or
title like '%ecosystem%' or
title like '%mountain%' or
title like '%terrestrial%' or
title like '%biodiversity%' or
title like '%extinct species%' or
title like '%extinction%' or
title like '%extinction risk%' or
title like '%Green Cover%' or
title like '%Forest Management%' or
title like '%freshwater%' or
title like '%Forest%' or
title like '%illicit wildlife%' or
title like '%poaching%' or
title like '%restoration%' or
title like '%restore%' or
title like '%protect species%' or
title like '%protected area%' or
title like '%Preserve diverse%' or
title like '%prevent extinction%' or
title like '%SDG 15%' or
title like '%trafficking%' or
title like '%sustainable use%' or
title like '%sustainable management%' or
title like '%threatened species%' or
title like '%wetland%' or
title like '%wildlife%' or
title like '%UNFF%' or
title like '%United Nations Forum on Forests%' or
title like '%Forest Management%'  then 656
--'SDG15Life On Land'
/*Conservation of ecosystem*/
when title like '%desertification%' or
title like '%wetland%' or
title like '%biodiversity%' or
title like '%Forest Management%' or
title like '%afforestation%' or
title like '%combat%' or
title like '%poaching%' or
title like '%ecosystem%' or
title like '%extinct species%' or
title like '%extinction risk%' or
title like '%extinction %' or
title like '%conservation%' or
title like '%restoration%' or
title like '%Green Cover%' or
title like '%illicit wildlife%' or
title like '%alien species%' or
title like '%Preserve diverse%' or
title like '%prevent extinction%' or
title like '%protect species%' or
title like '%protected area%' or
title like '%restore%' or
title like '%deforestation%' or
title like '%sustainable management%' or
title like '%sustainable use%' or
title like '%threatened species%' or
title like '%wildlife%' or
title like '%trafficking%' or
title like '%Forest%' or
title like '%biodiversity%' or
title like '%mountain%' or
title like '%freshwater%' or
title like '%terrestrial%' or
title like '%ecosystem%' or
title like '%SDG 15%' then 679 
/*SDG16Peace Justice and Strong Instituion*/
when title like '%exploit%' or
title like '%security%' or
title like '%human right%' or
title like '%justice%' or
title like '%ethnic group%' or
title like '%racial abuse%' or
title like '%information%' or
title like '%armed conflict%' or
title like '%violence%' or
title like '%combat crime%' or
title like '%combat terrorism%' or
title like '%constitutional guarantee%' or
title like '%constitutional right%' or
title like '%discriminated against%' or
title like '%fight against illegal%' or
title like '%freedom%' or
title like '%detention%' or
title like '%human rights%' or
title like '%human trafficking%' or
title like '%humanitarian need%' or
title like '%illicit arms%' or
title like '%illicit financial flow%' or
title like '%individual rights%' or
title like '%homicide%' or
title like '%bribery%' or
title like '%people struggle%' or
title like '%physical punishment%' or
title like '%policy guarantee%' or
title like '%population displacement%' or
title like '%prevent violence%' or
title like '%prohobit discrimination%' or
title like '%protect freedom%' or
title like '%protect fundamental%' or
title like '%psychological aggression%' or
title like '%reduce bribery%' or
title like '%reduce corruption%' or
title like '%resolution mechanism%' or
title like '%rule of law%' or
title like '%Sexual violence%' or
title like '%statutory right%' or
title like '%torture%' or
title like '%torture of children%' or
title like '%trafficking of%' or
title like '%undermine trust%' or
title like '%unsentenced %' or
title like '%victims of robbery%' or
title like '%violence against%' or
title like '%Voting right%' or
title like '%sentencing%' or
title like '%SDG 16%' then 651 
/*SDG17 Global Partnership*/
when title like '%takes responsibility%' or
title like '%social partner%' or
title like '%commit%' or
title like '%exchange%' or
title like '%collaborate%' or
title like '%partner%' or
title like '%cooperate%' or
title like '%agreement%' or
title like '%alliance%' or
title like '%strengthen%' or
title like '%contribute%' or
title like '%promote responsible%' or
title like '%promote sustainable%' then 685
/*SDG5 Gender Equality*/
when title like '%social discrimination%' or
title like '%Maternal Health%' or
title like '%child marriage%' or
title like '%gender gap%' or
title like '%inequality%' or
title like '%gender inequality%' or
title like '%gender equality%' or
title like '%girl child%' or
title like '%girl education%' or
title like '%poverty reduction%' or
title like '%exploit%' or
title like '%domestic work%' or
title like '%women empowerment%' or
title like '%gender disparity%' or
title like '%female infanticide%' or
title like '%female foecticide%' or
title like '%reproductive right%' or
title like '%statutory legal age%' or
title like '%domestic violence%' or
title like '%genital mutilation%' then 84
/*SDG7Affordable and Clean Energy*/
when title like '%Clean Energy%' or
title like '%affordable energy%' or
title like '%clean fuel%' or
title like '%energy access%' or
title like '%energy consumption%' or
title like '%renewable source%' or
title like '%sustainable energy%' or
title like '%energy demand%' or
title like '%SDG 7%' then 658
else 698 

end
label	 from rssfeeditem 
	 where id = @RssFeedItemId and PubDate>= dateadd(day,datediff(day,0,GETDATE()-1),0)


	 Insert into categoryScore (RssFeedItemID, CategoryID, Score)
	 select LN.RssFeedItemId, C.ID, 1 from @LabelNews LN, Category C 
	 where LN.labelid = C.labelid
End
