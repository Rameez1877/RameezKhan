/****** Object:  Procedure [dbo].[sp_MSdel_dboAppUser_msrepl_ccs]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[sp_MSdel_dboAppUser_msrepl_ccs]
		@pkc1 int
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[AppUser] 
	where [Id] = @pkc1
end  
