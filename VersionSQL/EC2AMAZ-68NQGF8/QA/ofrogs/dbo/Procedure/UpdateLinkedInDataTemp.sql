/****** Object:  Procedure [dbo].[UpdateLinkedInDataTemp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateLinkedInDataTemp]
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE L
    SET	
        gender = isnull(Right(p.gender, 1), 'U'),
        CountryOfOrigin = isnull(p.CountryOfOrigin, '')
    FROM
        LinkedInDataTemp L 
        inner join person_gender P on p.person_name = L.firstname

    UPDATE L
        SET	TagId = isnull(T.Id, 0)
    FROM
        LinkedInDataTemp L 
        inner join Tag T on (T.Name = L.organization collate SQL_Latin1_General_CP1_CI_AS and T.TagTypeId = 1)

    UPDATE L
        SET	IndustryID = isnull(O.IndustryId, 0)
    FROM
        LinkedInDataTemp L 
        inner join Organization O on (O.Name = L.organization collate SQL_Latin1_General_CP1_CI_AS)
END
