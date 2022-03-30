/****** Object:  Function [dbo].[GetDerivedIndustryId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- @Description:	<@Description, ,>
-- =============================================
CREATE FUNCTION dbo.GetDerivedIndustryId
(
	@Description nvarchar(4000)
)
RETURNS int
AS
BEGIN
	declare @result int

	set @result = case
		when (@Description like '%airline%' or @Description like '%airway%'
		or @Description like '%aircraft%' or @Description like '%aviation%' or @Description like '%airport%'  
		or @Description like '%aerospace%' or @Description like '%airliner%') then 23 
		when (@Description like '%rail%' or @Description like '%yard%' 
		or @Description like '%hump%' or @Description like '%flat switching%' or @Description like '%track%' ) 
		then 32 
		when (@Description like '%energy%' or @Description like '%coal%' 
		or @Description like '%crude oil%' or @Description like '%natural gas%' or @Description like '%power%' or @Description like '%electricity%' 
		or @Description like '%biofuel%'  or @Description like '%nuclear%' or @Description like '%oil%') 
		then 17 
		when (@Description like '%metal%' or @Description like '%mining%' 
		or @Description like '%mine%' or @Description like '%steel%' or @Description like '%ore%' or @Description like '%smelt%' 
		or @Description like '%concentrate%'  or @Description like '%pit%' or @Description like '%mill%') 
		then 16 
		else  0 
	end

	return @result
END
