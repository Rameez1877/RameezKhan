/****** Object:  Procedure [dbo].[GetTechs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetTechs
	-- Add the parameters for the stored procedure here
	@techids varchar(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SELECT * FROM dbo.split(@techids, ',')
	select t2.TagID, T2.StackTechnology from  TechStackTechnology t2
    where t2.stacksubcategoryid in (SELECT Data FROM dbo.split(@techids, ','))
	 
  
END
