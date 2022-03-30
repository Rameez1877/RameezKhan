/****** Object:  Function [dbo].[f_get_min_of_7_nos]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[f_get_min_of_7_nos]
(
	-- Add the parameters for the function here
	@date1 int, @date2 int, @date3 int, @date4 int, @date5 int, @date6 int, @date7 int, @date8 int
)
RETURNS int
AS
BEGIN
declare @op int

select @op = (case when @date1 <= @date2 and @date1 <= @date3 and @date1 <= @date4 and @date1 <= @date5 and @date1 <= @date6  and @date1 <= @date7 and @date1 <= @date8
             then @date1
             when @date2 <= @date3 and @date2 <= @date4 and @date2 <= @date5 and @date2 <= @date6 and @date2 <= @date7 and @date2 <= @date8
             then @date2
             when @date3 <= @date4 and @date3 <= @date5 and @date3 <= @date6 and @date3 <= @date7 and @date3 <= @date8
             then @date3 
             when @date4 <= @date5 and @date4 <= @date6 and @date4 <= @date7 and @date4 <= @date8
             then @date4
			 when @date5 <= @date6 and @date5 <= @date7 and @date5 <= @date8
			 then @date5
			 when @date6 <= @date7 and @date6 <= @date8
             then  @date6
			 when @date7 <= @date8
			 then @date7
			 else
			  @date8
         end)
		 return @op
END
