/****** Object:  Procedure [dbo].[ProcessLabelAndConceptWord]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProcessLabelAndConceptWord] 
	-- Add the parameters for the stored procedure here
	@LabelName VARCHAR(100),@ConceptWordName VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @labelid INT
	declare @conceptwordid INT
	declare @count INT

	select @labelid = Id from Label where Name = @LabelName
	select @conceptwordid = Id from ConceptWord where Name = @ConceptWordName

	If @labelid is null
	Begin
		Insert into Label(Name) Values(@LabelName)
		set @labelid=@@identity	
	End

	If @conceptwordid is null
	Begin
		Insert into ConceptWord(Name) Values(@ConceptWordName)
		set @conceptwordid=@@identity
	END

	select @count = count(*) from LabelConceptWord where LabelId = @labelid and ConceptWordId = @conceptwordid

	if @count <> 0
	Begin
		Print('Record already present in LabelConceptWord')
	End
	Else
	Begin
		Insert into LabelConceptWord Values(@labelid,@conceptwordid)
		print('Success')
	End
End
