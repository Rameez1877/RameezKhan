/****** Object:  Procedure [dbo].[sp_get_graymatter_ml_data]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_graymatter_ml_data]
-- Add the parameters for the stored procedure here

AS
--drop table  GrayMatterML
--create table GrayMatterML
--(id int,
--keyword varchar(100),
--MarketingListName varchar(100))
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @id int,
            @Title varchar(100)

    DELETE GrayMatterML

    DECLARE db_cursor CURSOR FOR
    SELECT
        id,
        title
    FROM GrayMatterCRMDataNonAAPlus gm
    WHERE EXISTS (SELECT
        *
    FROM decisionmakerlist dm
    WHERE CHARINDEX(keyword + ' ', gm.Title) > 0
            OR CHARINDEX(' ' + keyword + ' ', gm.Title) > 0
            OR CHARINDEX(' ' + keyword, gm.Title) > 0
			OR CHARINDEX(keyword +' ' , gm.Title + ' ') > 0)

    OPEN db_cursor
    FETCH NEXT FROM db_cursor INTO @id, @Title

    WHILE @@FETCH_STATUS = 0
    BEGIN
        --
        SET @Title = REPLACE(@Title, ',', ' ')
        SET @Title = REPLACE(@Title, '.', ' ')
        SET @Title = REPLACE(@Title, '/', ' ')
       
	    INSERT INTO GrayMatterML
            SELECT
                @id,
                keyword,
                MarketingListName
            FROM MarketingListKeyword
            WHERE CHARINDEX(keyword + ' ', @Title) > 0
            OR CHARINDEX(' ' + keyword + ' ', @Title) > 0
            OR CHARINDEX(' ' + keyword, @Title) > 0
			OR CHARINDEX(keyword +' ' , @Title + ' ') > 0


        --
        FETCH NEXT FROM db_cursor INTO @id, @Title
    END
	END 
    CLOSE db_cursor
    DEALLOCATE db_cursor

/*
-- Non AA PLus

Select ML.MainMarketingListName, ML.MarketingListName,GMML.Keyword
,gm.FirstName
,gm.LastName
,gm.Title
,gm.Email
,gm.Country
,gm.Phone
,gm.Company
,gm.Website
,gm.Industry
,gm.AllEmployees
,gm.Revenue
,gm.ITBudget
,gm.RainKingContactID
,gm.id  from GrayMatterML GMML, MarketingListKeyword ML, GrayMatterCRMDataNonAAPlus Gm
WHERE GMML.keyword = ML.keyword
and GMML.MarketingListName = ML.MarketingListName
and GMML.ID= GM.id


select count(*) from GrayMatterCRMDataNonAAPlus --278378


-- Non AA Plus Decision Makers Others 19873

select count(*) from GrayMatterCRMDataNonAAPlus
where id not in (select id from GrayMatterML)
and EXISTS (SELECT
        *
    FROM decisionmakerlist dm
    WHERE CHARINDEX(keyword + ' ', title) > 0
            OR CHARINDEX(
' ' + keyword + ' ', title) > 0
            OR CHARINDEX(' ' + keyword, title) > 0)
			

-- Non AA Plus Non Decision Makers 182644

SELECT
       count(*) 
    FROM GrayMatterCRMDataNonAAPlus gm
    WHERE not EXISTS (SELECT
        *
    FROM decisionmakerlist dm
    WHERE CHARINDEX(keyword + ' ', gm.title) > 0
            OR CHARINDEX(
' ' + keyword + ' ', gm.title) > 0
            OR CHARINDEX(
' ' + keyword, gm.title) > 0)

*/
