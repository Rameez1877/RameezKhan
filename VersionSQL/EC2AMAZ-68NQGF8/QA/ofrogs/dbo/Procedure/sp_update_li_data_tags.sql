/****** Object:  Procedure [dbo].[sp_update_li_data_tags]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- Used in front end for approve / reject suggested tags
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_li_data_tags]
-- Add the parameters for the stored procedure here
@action varchar(15),-- mandatory
@linkedindataid int,-- mandatory
@TagID int -- -- mandatory when alias is selected
--@SuccessFail varchar(200) OUTPUT
AS
BEGIN

    DECLARE @SuccessFail varchar(200)
    DECLARE @oranizationName varchar(200)
    SELECT
        @oranizationName = organization
    FROM linkedindata
    WHERE id = @linkedindataid
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @oranizationIDLocal int,
            @TagIDLocal int

    IF @action = 'Alias'
    BEGIN
        IF @TagID = 0
            OR @TagID IS NULL
            OR @linkedindataid IS NULL
            OR @linkedindataid = 0
            SET @SuccessFail = 'Option Chosen Was Alias And Tag ID, Linkedin Data Information is not supplied'
        ELSE
        BEGIN
            --
            -- Create New Tag
            --
			SELECT @oranizationIDLocal = OrganizationId from tag
			where id = @TagID

			SELECT
            @TagidLocal = id
        FROM tag
        WHERE name = @oranizationName
        AND tagtypeid = 1

        IF @TagidLocal IS NULL
        BEGIN
            INSERT INTO TAG (name,
                             tagtypeid,
                             organizationid
            )
                VALUES ( @oranizationName,
                         1,
                         @oranizationIDLocal )
            SELECT top 1
                @TagidLocal = ID
            FROM tag
			where name =@oranizationName
        END
            -- Use this new tag in linkedindata
            UPDATE linkedindata
            SET tagid = @TagidLocal
            WHERE id = @linkedindataid
            DELETE FROM lidata_no_tag
            WHERE id = @linkedindataid
            SET @SuccessFail = 'Success'
        END
    END
    ELSE
    IF @action = 'No'
    BEGIN

        IF  @linkedindataid IS NULL
            OR @linkedindataid = 0
            SET @SuccessFail = 'Option Chosen Was No LinkedinData Information is not supplied'
        ELSE
        BEGIN
            --
            -- Create organization
            -- 
            SELECT
                @oranizationIDLocal = id
            FROM organization
            WHERE name = @oranizationName
            IF @oranizationIDLocal IS NULL
            BEGIN
                INSERT INTO organization (name,
                                          fullname,
                                          name2,
                                          websiteurl,
                                          description,
                                          createdbyid,
                                          createddate,
                                          updatedbyid,
                                          updateddate,
                                          isactive,
                                          region,
                                          category,
                                          industryid,
                                          regionid,
                                          wikiname,
                                          sectorid,
                                          countryid
                )
                    VALUES ( @oranizationName,
                             @oranizationName,
                             @oranizationName,
                             NULL,
                             @oranizationName,
                             1,
                             GETDATE(),
                             1,
                             GETDATE(),
                             1,
                             NULL,
                             NULL,
                             0,
                             NULL,
                             NULL,
                             NULL,
                             0 )
                SELECT top 1
                    @oranizationIDLocal = id
                FROM organization
			where name =@oranizationName
            END
        END
        --
        -- Create New Tag
        --
        SELECT
            @TagidLocal = id
        FROM tag
        WHERE name = @oranizationName
        AND tagtypeid = 1

        IF @TagidLocal IS NULL
        BEGIN
            INSERT INTO TAG (name,
                             tagtypeid,
                             organizationid
            )
                VALUES ( @oranizationName,
                         1,
                         @oranizationIDLocal )
            SELECT top 1
                @TagidLocal = ID
            FROM tag
			where name =@oranizationName
        END
        -- Use this new tag in linkedindata
        UPDATE linkedindata
        SET tagid = @TagidLocal
        WHERE id = @linkedindataid
        DELETE FROM lidata_no_tag
        WHERE id = @linkedindataid
        SET @SuccessFail = 'Success'
    END
    ELSE
    IF @action = 'Ignore'
    BEGIN
        DELETE FROM lidata_no_tag
        WHERE id = @linkedindataid
        SET @SuccessFail = 'Success'
    END
END
