/****** Object:  Procedure [dbo].[sp_get_graymatter_ml_data_aa_plus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_graymatter_ml_data_aa_plus]
-- Add the parameters for the stored procedure here

AS
--drop table  GrayMatterMLAAPlus
--create table GrayMatterMLAAPlus
--(id int,
--keyword varchar(100),
--MarketingListName varchar(100))
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @id int,
            @Title varchar(100)

    DELETE GrayMatterMLAAPlus

    DECLARE db_cursor CURSOR FOR
    SELECT
        id,
        title
    FROM GrayMatterCRMDataAAPlus gm
    WHERE EXISTS (SELECT
        *
    FROM decisionmakerlist dm
	where isactive=1 and ( keyword= title
	or
	(
	charindex(' ' + keyword + ' ',  title) > 0  
	or charindex(' ' + keyword + ' ',  ' ' + title + ' ') > 0 
	))
)


    OPEN db_cursor
    FETCH NEXT FROM db_cursor INTO  @id,@Title

    WHILE @@FETCH_STATUS = 0
    BEGIN
        --
        SET @Title = REPLACE(@Title, ',', ' ')
        SET @Title = REPLACE(@Title, '.', ' ')
       SET @Title = REPLACE(@Title, '/', ' ')
	    SET @Title =@Title + ' ' 
        INSERT INTO GrayMatterMLAAPlus
            SELECT
                @id,
                keyword,
                MarketingListName
            FROM MarketingListKeyword
            WHERE (
keyword= @Title
	or
	(
	charindex(' ' + keyword + ' ',  @Title) > 0  
	or charindex(' ' + keyword + ' ',  ' ' + @Title + ' ') > 0 
	)
)  and MainMarketingListName ='Airport'


        --
        FETCH NEXT FROM db_cursor INTO @id, @Title
    END
    CLOSE db_cursor
    DEALLOCATE db_cursor
end
	
/*	
-- AA Plus -- 631
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
,gm.id  from GrayMatterMLAAPlus GMML, MarketingListKeyword ML, GrayMatterCRMDataAAPlus Gm
WHERE GMML.keyword = ML.keyword
and GMML.MarketingListName = ML.MarketingListName
and GMML.ID= GM.id
--and ML.MainMarketingListName ='AA+'

--2. Others 1032

select * from GrayMatterCRMDataAAPlus
where id not in (select id from GrayMatterMLAAPlus)
and EXISTS (SELECT
        *
    FROM decisionmakerlist dm
    WHERE CHARINDEX(keyword + ' ', title) > 0
            OR CHARINDEX(' ' + keyword + ' ', title) > 0
            OR CHARINDEX(' ' + keyword, title) > 0)

3-- Not decision makers (3415)

SELECT
       * 
    FROM GrayMatterCRMDataAAPlus gm
    WHERE not EXISTS (SELECT
        *
    FROM decisionmakerlist dm
    WHERE CHARINDEX(keyword + ' ', gm.title) > 0
            OR CHARINDEX(' ' + keyword + ' ', gm.title) > 0
            OR CHARINDEX(' ' + keyword, gm.title) > 0)


*/
