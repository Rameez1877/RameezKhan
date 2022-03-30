/****** Object:  Procedure [dbo].[usp_PopulateMarketingListFilterSummary]    Committed by VersionSQL https://www.versionsql.com ******/

--=========================================================
-- ==== Created on June 13 2020 ===========================
-- ==== Author :  Tulasi Godavarthi =======================
-- ############### ISSUE ##################################
-- Charts are not appearing as 
-- we are unable to run 
-- Exec PopulateMarketingListFilterSummary @TargetPersonaID 
-- from Front End whenever user creates a new TargetPersona

--######## Temporary Fix ##################################
-- Executing this stored procedure for each target persona 
-- id will populate charts data 
-- into MarketingListFilterCopy Table 
--## Permanent Fix ########################################
-- moved the PopulateMarketingListFilterSummary SP Code
-- inside [dbo].[SaveTargetPersonaConfiguration]", 
-- persona.Id, User.Id
--========================================================

CREATE PROC usp_PopulateMarketingListFilterSummary

AS
BEGIN

		IF OBJECT_ID('tempdb..#temp') is not null drop table #temp

		create table #temp(
			TargetPersonaID int, Row_Num int)

			insert into #temp
			select ID , ROW_NUMBER() Over (order by ID) as RN from TargetPersona

			--select * from #temp
		Declare @TargetPersonaID int 

		Declare @records int, @UserID int

		select @records = count(ID) from TargetPersona

		while @records > 0
		Begin
	
			select @TargetPersonaID = TargetPersonaID from #temp where Row_Num = @records
			--select @TargetPersonaID

			Exec PopulateMarketingListFilterSummary @TargetPersonaID

			set @records = @records - 1
		End

END
