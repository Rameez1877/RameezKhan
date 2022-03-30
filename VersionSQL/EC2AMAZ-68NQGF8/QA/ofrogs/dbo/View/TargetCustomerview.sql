/****** Object:  View [dbo].[TargetCustomerview]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[TargetCustomerview]
AS

SELECT
  i.id,i.Name,a.AppUserId,
  sum(CASE
    WHEN a.ExistingCustomer = 'Yes' THEN 1
    ELSE 0
  END) yes_count,
  sum(CASE
    WHEN a.ExistingCustomer = 'No' THEN 1
    ELSE 0
  END) no_count
FROM ofuser.CustomerTargetList a

LEFT JOIN Organization b
  ON a.OrganizationId = b.Id
LEFT JOIN Industry i
  ON b.IndustryId = i.Id
  where (a.isactive=1)
GROUP BY i.id,i.Name,a.AppUserId
