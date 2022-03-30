/****** Object:  Procedure [dbo].[testwhileloop]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE testwhileloop 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @i INT = 0;
DECLARE @id INT = 2423;
WHILE @i < 5
BEGIN
   declare @key Varchar(100);

   select @key = keyword, @id = id from McDecisionmaker where isactive = 1 and id = @id;

   declare @j int = 0;
   declare @id2 int = 1;
   while @j < 4
   
	begin
	
	declare @key2 varchar(100);
	declare @concatkey varchar(500);
	

	select @key2 = keyword from decisionmakerlist where id = @id2;
	select @concatkey = concat(@key,',',@key2);
    PRINT @concatkey;
	 set @id2 = @id2 + 1;
	 set @j = @j + 1;
	end;


   PRINT 'this is outside first loop and i = ' + cast(@i as varchar)+ ' here.';
   SET @id = @id + 1;
   SET @i = @i + 1;
END

PRINT 'Done simulated FOR LOOP on TechOnTheNet.com';

END
