/****** Object:  Procedure [dbo].[ProcessLeadScore_original]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      Anurag Gandhi
-- Create date: 16 Jul, 2020
-- Description:	Stored Procedure to Process LeadScore
-- =============================================
Create PROCEDURE [dbo].[ProcessLeadScore_original]
	@TargetPersonaId int =20978,  -- 20976,
    @ShowDetail bit = 1 --- 0
AS
/*
[dbo].[ProcessLeadScore] 20978, 1
*/
BEGIN
  SET NOCOUNT ON;
  Declare @UserId int
  DECLARE @Query nvarchar(4000)
  
  select @UserId = CreatedBy from TargetPersona where Id = @TargetPersonaId
  --set @UserId = 146

	CREATE TABLE #Score (
		Id int primary key not null,
		EmployeeCountScore int default(0),
		RevenueScore int default(0),
		FundingScore int default(0),
		BScore int default(0),
		AScore int default(0),
		IndustryScore int default(0),
		TechnologyScore int default(0),
		TeamScore int default(0),
		NScore int default(0),
		IntentScore int default(0),
		TimingScore int default(0),
		TechnologySpendScore int default(0),
		TScore int default(0),
		TotalScore int default(0)
	)

	select utc.CountryId AS Id into #Countries from UserTargetCountry utc where utc.UserId = @UserId

	select * into #Org from Organization 
	where Id in (select OrganizationID from TargetPersonaOrganization where TargetPersonaId = @TargetPersonaId)

	insert #Score (Id)
	select Id from #Org

	select distinct Id, OrganizationId, Functionality, Technology, SpendEstimate, InvestmentType, Duration
	into #Surge 
	from SurgeSummary 
	where 
		OrganizationId in (select Id from #Org)
		and CountryId in (select Id from #Countries)
	
	;with FundingData as 
	(
		select o.Id, f.TotalFunding/(1 + datepart(year, getdate()) - datepart(year, f.LastFundingDate)) as FundingPerYear
		from 
			#Org o
			inner join StartUpsFundingData f on (o.Id = f.OrganizationId)
	)
	select Id, 
		case when FundingPerYear < 17 then 0
		when FundingPerYear between 17 and 26 then 3
		when FundingPerYear between 27 and 32 then 6
		when FundingPerYear between 33 and 44 then 9
		when FundingPerYear between 45 and 61 then 12
		when FundingPerYear between 62 and 85 then 15
		when FundingPerYear between 86 and 150 then 17
		when FundingPerYear between 151 and 1400 then 19
		else 20 end as FundingScore
	into #FundingData
	from FundingData

	update s
	set
		s.FundingScore = f.FundingScore
	from
		#Score s
		inner join #FundingData f on (s.Id = f.Id)

	-- Budget Score
    select * into #LeadScoreUserEmpCount from LeadScoreUserEmpCount where UserId = 0 and [Type] = 'NON App'
    select * into #LeadScoreUserRevenue from LeadScoreUserRevenue where UserId = 0 and [Type] = 'NON App'

	select o.Id, o.EmployeeCount, o.Revenue, 
		isnull(ec.Score, 0) as EmployeeCountScore, 
		isnull(ur.Score, 0) as RevenueScore
		-- isnull(f.FundingScore, 0) as FundingScore
		-- dbo.MaxOf(ec.Score, ur.Score, f.FundingScore) as BScore -- ec.Score, ur.Score
	into #BScore
	from 
		#Org o
		inner join TargetPersonaOrganization tpo on (o.Id = tpo.OrganizationId)
		left join #LeadScoreUserEmpCount ec on (o.EmployeeCount = ec.EmpCount)
		left join #LeadScoreUserRevenue ur on (ur.Revenue = o.Revenue)
		-- left join #FundingData f on (f.Id = o.Id)
	where
		tpo.TargetPersonaId = @TargetPersonaId

	update s
	set
		s.EmployeeCountScore = b.EmployeeCountScore,
		s.RevenueScore = b.RevenueScore
	from
		#Score s
		inner join #BScore b on (s.Id = b.Id)

	-- Budget Score Ends.---------------------

	-- Authority Score ------------------
	select l.OrganizationId, mc.[Name] as Functionality, utf.ApplyScore, count(1) as DMCount
	into #DMCount
	from 
		LinkedInData l
		inner join #Countries c on (c.Id = l.ResultantCountryId)
		inner join mcdecisionmakerlist mc on mc.DecisionmakerId = l.id
		inner join UserTargetFunctionality utf on (mc.[Name] = utf.Functionality and utf.UserID = @UserId)
	where
		l.OrganizationId in (select Id from #Org)
		--and l.DecisionMaker = 'DecisionMaker'
		and l.SeniorityLevel in ('C-level', 'Director')
	group by
		l.OrganizationId, mc.[Name], utf.ApplyScore

    if EXISTS(select 1 from #DMCount where ApplyScore = 1)
    BEGIN
        select o.Id, -- dm.Functionality, dm.ApplyScore, dm.DMCount, 
            max(case when ApplyScore = 1 and DMCount is not null then 25 when DMCount > 0 then 15 else 0 end) as AScore
        into #AScore
        from
            #Org o
            inner join #DMCount dm on (o.Id = dm.OrganizationId)
        group by o.Id

        update s
            set AScore = a.AScore
        from
            #Score s 
            inner join #AScore a on (s.Id = a.Id)
    END
    ELSE
    BEGIN
        select o.Id, -- dm.Functionality, dm.ApplyScore, dm.DMCount, 
            max(case when DMCount > 0 then 25 else 0 end) as AScore
        into #AScore2
        from
            #Org o
            inner join #DMCount dm on (o.Id = dm.OrganizationId)
        group by o.Id

        update s
            set AScore = a.AScore
        from
            #Score s 
            inner join #AScore2 a on (s.Id = a.Id)
    END


	-- Needs Calculation Starts --------------------
	If exists (select 1 from UserTargetIndustry where UserId = @UserId and ApplyScore = 1)
	Begin
		select o.Id, o.IndustryId, -- uti.IndustryId, 
			case when uti.IndustryId is not null and uti.ApplyScore = 1 then 5 else 0 end as IndustryScore
		into #IndustryScore
		from
			#Org o
			left join UserTargetIndustry uti on (o.IndustryId = uti.IndustryId and uti.UserId = @UserId)

		update s
			set IndustryScore = a.IndustryScore
		from
			#Score s 
			inner join #IndustryScore a on (s.Id = a.Id)
	End
	Else
	Begin
		update #Score set IndustryScore = 5
	End

	
	If exists (select 1 from UserTargetTechnology where UserId = @UserId and ApplyScore = 1)
    Begin
		;with cte as
		(select distinct o.Id, 
			max(case when utt.ApplyScore = 1 then 7 else 4 end) as TechnologyScore
		from
			#Org o
			inner join Tag t on (o.Id = t.OrganizationId)
			inner join Technographics s on (t.Id = s.TagIdOrganization) -- Technographics
			inner join #Countries c on (c.Id = s.CountryId)
			inner join UserTargetTechnology utt on (utt.UserId = @UserId and s.Keyword = utt.Technology)
        group by o.Id
        )
        
		update s
			set TechnologyScore = a.TechnologyScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
    End
	ELSE
    Begin 
        ;with cte as
		(select distinct o.Id, 7 as TechnologyScore
		from
			#Org o
			inner join Tag t on (o.Id = t.OrganizationId)
			inner join Technographics s on (t.Id = s.TagIdOrganization) -- Technographics
			inner join #Countries c on (c.Id = s.CountryId)
			inner join UserTargetTechnology utt on (utt.UserId = @UserId and s.Keyword = utt.Technology)
        group by o.Id
        )
        
		update s
			set TechnologyScore = a.TechnologyScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
    End

	If exists (select 1 from UserTargetTechnology where UserId = @UserId and ApplyScore = 1)
	Begin
		select distinct o.Id, s.SpendEstimate,
			case when utf.ApplyScore = 1 then 1.0 else 0.7 end as TechnologySpendWeight,
			case s.SpendEstimate when 'Very Low' then 1.5
				when 'Low' then 3
				when 'Average' then 5
				when 'High' then 6.5
				when 'Very High' then 7
				when 'Extreme High' then 8 end as TechnologySpend
		into #TechSpend
		from
			#Org o
			inner join #Surge s on (o.Id = s.OrganizationId)
			inner join UserTargetTechnology utf on (utf.UserId = @UserId and s.Technology = utf.Technology)
		where
			s.SpendEstimate is not null
		order by o.Id

		;with cte as 
		(
			select Id, max(TechnologySpendWeight*TechnologySpend) as TechnologySpendScore
			from #TechSpend
			group by Id
		)
		update s
			set TechnologySpendScore = a.TechnologySpendScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
	End
	Else
	Begin
		select distinct o.Id, s.SpendEstimate,
			1 as TechnologySpendWeight,
			case s.SpendEstimate when 'Very Low' then 1.5
				when 'Low' then 3
				when 'Average' then 5
				when 'High' then 6.5
				when 'Very High' then 7
				when 'Extreme High' then 8 end as TechnologySpend
		into #TechSpend2
		from
			#Org o
			inner join #Surge s on (o.Id = s.OrganizationId)
			inner join UserTargetTechnology utf on (utf.UserId = @UserId and s.Technology = utf.Technology)
		where
			s.SpendEstimate is not null
		order by o.Id

		;with cte as 
		(
			select Id, max(TechnologySpendWeight*TechnologySpend) as TechnologySpendScore
			from #TechSpend2
			group by Id
		)
		update s
			set TechnologySpendScore = a.TechnologySpendScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
	End

	-- Calculating TeamsScore

    If exists (select 1 from UserTargetFunctionality where UserId = @UserId and ApplyScore = 1)
    BEGIN
        select distinct o.Id, ot.TeamName,
            case when utf.ApplyScore = 1 then 15 else 10 end as TeamScore
        into #OrgTeam
        from
            #Org o
            inner join cache.OrganizationTeams ot on (o.Id = ot.OrganizationId)
            inner join #Countries c on (c.Id = ot.CountryId)
            inner join UserTargetFunctionality utf on (utf.UserId = @UserId and utf.Functionality = ot.TeamName)

        ;with cte as 
        (select Id, max(TeamScore) as TeamScore from #OrgTeam group by Id)
        update s
            set TeamScore = a.TeamScore
        from
            #Score s inner join cte a on (s.Id = a.Id)
    END
    ELSE
    BEGIN
        select distinct o.Id, ot.TeamName, 15 as TeamScore
        into #OrgTeam2
        from
            #Org o
            inner join cache.OrganizationTeams ot on (o.Id = ot.OrganizationId)
            inner join #Countries c on (c.Id = ot.CountryId)
            inner join UserTargetFunctionality utf on (utf.UserId = @UserId and utf.Functionality = ot.TeamName)

        ;with cte as 
        (select Id, max(TeamScore) as TeamScore from #OrgTeam2 group by Id)
        update s
            set TeamScore = a.TeamScore
        from
            #Score s inner join cte a on (s.Id = a.Id)
    END

	-- Calculating IntentStrength
	If exists (select 1 from UserTargetFunctionality where UserId = @UserId and ApplyScore = 1)
    BEGIN
		select distinct o.Id, s.Functionality, s.InvestmentType,
			case when utf.ApplyScore = 1 then 1.0 else 0.7 end as IntentStrength,
			case s.InvestmentType 
				when 'Strategic Investment' then 10
				when 'Building Managerial Strength' then 8
				when 'Building Team' then 6
				else 0 end as MF
		into #IntentStrength
		from 
			#Org o 
			inner join #Surge s on (o.Id = s.OrganizationId)
			inner join UserTargetFunctionality utf on (utf.UserId = @UserId and s.Functionality = utf.Functionality)

		;with cte as 
		(select Id, max(IntentStrength * MF) as IntentScore 
		from #IntentStrength group by Id)
		-- select * from cte
		update s
			set s.IntentScore = a.IntentScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
	END
	ELSE
	BEGIN
		select distinct o.Id, s.Functionality, s.InvestmentType,1 AS IntentStrength,
			case s.InvestmentType 
				when 'Strategic Investment' then 10
				when 'Building Managerial Strength' then 8
				when 'Building Team' then 6
				else 0 end as MF
		into #IntentStrength2
		from 
			#Org o 
			inner join #Surge s on (o.Id = s.OrganizationId)
			inner join UserTargetFunctionality utf on (utf.UserId = @UserId and s.Functionality = utf.Functionality)

		;with cte as 
		(select Id, max(IntentStrength * MF) as IntentScore 
		from #IntentStrength2 group by Id)
		-- select * from cte
		update s
			set s.IntentScore = a.IntentScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
	END
	

	---- Calculating Intent Timimg Score
	If exists (select 1 from UserTargetFunctionality where UserId = @UserId and ApplyScore = 1)
    BEGIN
		select distinct o.Id, s.Duration,
			case when utf.ApplyScore = 1 then 1.0 else 0.7 end as IntentTiming,
			case when s.Duration <= 1 then 10
				when s.Duration between 2 and 4 then 8
				when s.Duration between 5 and 6 then 6
				else 0 end as MF
		into #Timing
		from
			#Org o
			inner join #Surge s on (o.Id = s.OrganizationId)
			inner join UserTargetFunctionality utf on (utf.UserId = @UserId and utf.Functionality = s.Functionality)

		;with cte as 
		(select Id, max(IntentTiming * MF) as TimingScore 
		from #Timing group by Id)
		-- select * from cte
		update s
			set s.TimingScore = a.TimingScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
	END
	ELSE
	BEGIN
		select distinct o.Id, s.Duration,
			1 as IntentTiming,
			case when s.Duration <= 1 then 10
				when s.Duration between 2 and 4 then 8
				when s.Duration between 5 and 6 then 6
				else 0 end as MF
		into #Timing2
		from
			#Org o
			inner join #Surge s on (o.Id = s.OrganizationId)
			inner join UserTargetFunctionality utf on (utf.UserId = @UserId and utf.Functionality = s.Functionality)

		;with cte as 
		(select Id, max(IntentTiming * MF) as TimingScore 
		from #Timing2 group by Id)
		-- select * from cte
		update s
			set s.TimingScore = a.TimingScore
		from
			#Score s inner join cte a on (s.Id = a.Id)
	END
	-----------------------------------------------------
	-- Aggreagate all Scores
	update #Score
	set
		BScore = case when dbo.MaxOf(EmployeeCountScore, RevenueScore, FundingScore) = 0 then 10 else dbo.MaxOf(EmployeeCountScore, RevenueScore, FundingScore) end,
		NScore = IndustryScore + TechnologyScore + TeamScore,
		TScore = IntentScore + TimingScore + TechnologySpendScore

	update #Score
	set
		TotalScore = BScore + AScore + NScore + TScore

	update tpo
	set
		tpo.LeadScore = TotalScore
	from
		TargetPersonaOrganization tpo
		inner join #Score s on (tpo.OrganizationId = s.Id)
	where
		tpo.TargetPersonaId = @TargetPersonaId

    If @ShowDetail = 1
	    select * from #Score order by Id
END
-- consider Technographics table for Need Technology Score
-- consider functionality from surgeSummary table
-- [ProcessLeadScore]
