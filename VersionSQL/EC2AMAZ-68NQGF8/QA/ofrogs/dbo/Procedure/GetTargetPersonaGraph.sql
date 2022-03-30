/****** Object:  Procedure [dbo].[GetTargetPersonaGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTargetPersonaGraph] @seqNumber int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   Select dataType, DataString, DataValue from StgGraphTargetPersona
   where sequenceNo = @seqNumber
   order by Datavalue desc;
	
END
