/****** Object:  Function [dbo].[MaxOf]    Committed by VersionSQL https://www.versionsql.com ******/

create function dbo.MaxOf(@val1 int, @val2 int, @val3 int)
returns int
as
begin
  declare @max int
  SELECT @max = MAX(v) FROM (VALUES (@val1), (@val2), (@val3)) AS value(v)
  return @max
end
