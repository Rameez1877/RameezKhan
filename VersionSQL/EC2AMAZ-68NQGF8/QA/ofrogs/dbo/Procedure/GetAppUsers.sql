/****** Object:  Procedure [dbo].[GetAppUsers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	Asef Daqiq
-- Create date: <19 June 2019>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAppUsers]

AS
BEGIN
  SET NOCOUNT ON;
  SELECT
    a.Id,
    a.Name,
	a.FirstName,
	a.LastName,
    a.Email,
    a.Phone,
    a.OrganizationName,
    a.InsertedDate,
    a.IsActive,
	c.Id as ClientContactDetailId,
    c.ContactedDate,
    c.Remarks
  FROM AppUser a
  LEFT JOIN ClientsContactDetail c
    ON (a.Id = c.clientId)

  ORDER BY a.Id DESC

END
