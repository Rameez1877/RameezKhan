/****** Object:  Procedure [dbo].[sp_MSins_dboAppUser_msrepl_ccs]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[sp_MSins_dboAppUser_msrepl_ccs]
		@c1 int,
		@c2 nvarchar(500),
		@c3 varchar(50),
		@c4 nvarchar(500),
		@c5 varchar(150),
		@c6 int,
		@c7 bit,
		@c8 nvarchar(50),
		@c9 nvarchar(50),
		@c10 datetime,
		@c11 char(1),
		@c12 nvarchar(max),
		@c13 varchar(max),
		@c14 varchar(max),
		@c15 varchar(max),
		@c16 varchar(50)
as
begin
if exists (select * 
             from [dbo].[AppUser]
            where [Id] = @c1)
begin
update [dbo].[AppUser] set
		[Name] = @c2,
		[Username] = @c3,
		[Password] = @c4,
		[Email] = @c5,
		[AppRoleId] = @c6,
		[IsActive] = @c7,
		[FirstName] = @c8,
		[LastName] = @c9,
		[BirthDate] = @c10,
		[Gender] = @c11,
		[Image] = @c12,
		[zerobounce_apikey] = @c13,
		[hunter_apikey] = @c14,
		[hunterapikey] = @c15,
		[ActivationCode] = @c16
	where [Id] = @c1
end
else
begin
	insert into [dbo].[AppUser] (
		[Id],
		[Name],
		[Username],
		[Password],
		[Email],
		[AppRoleId],
		[IsActive],
		[FirstName],
		[LastName],
		[BirthDate],
		[Gender],
		[Image],
		[zerobounce_apikey],
		[hunter_apikey],
		[hunterapikey],
		[ActivationCode]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16	) 
end
end
