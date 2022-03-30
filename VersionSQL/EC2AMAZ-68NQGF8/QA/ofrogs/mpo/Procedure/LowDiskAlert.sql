/****** Object:  Procedure [mpo].[LowDiskAlert]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Low Disk Alert
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [mpo].[LowDiskAlert]
AS
BEGIN
	DECLARE @size int = 0
	DECLARE @DBSizes TABLE
	(
		DBName VARCHAR(50),
		Total_Space INT
	)



	SELECT @size = SUM(size)*8/(1024*1024) FROM sys.master_files
	--SELECT @Size
	if @size > 150
	Begin
		
		INSERT INTO @DBSizes(DBName, Total_Space)
		SELECT      sys.databases.[name] as [Name],  
					CONVERT(VARCHAR,SUM(size)*8/1024) AS [Total disk space (MB)]  
		FROM        sys.databases   
		JOIN        sys.master_files  
		ON          sys.databases.database_id=sys.master_files.database_id  
		GROUP BY    sys.databases.[name] 
		union 
		select 'Total Space', @size * 1024
		order by 2

		--Mail Set up and Notification mmailer--
		DECLARE @xml NVARCHAR(MAX)
		DECLARE @body NVARCHAR(MAX)
		DECLARE @servername NVARCHAR(30)

		SET @servername = @@ServerName + ' - Database Size Alert!!'

		SET @xml = CAST(( SELECT DBName AS 'td','',Total_Space AS 'td'
		FROM @DBSizes 
		ORDER BY 2 
		FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

		SET @body ='<html><body>Hi Team, <br><br> Below is the list of DBs and their size.<br>
		<table border = 1> 
		<tr>
		<th> DB Name </th> <th> Total disk space (MB) </th></tr>'    

		SET @body = @body + @xml +'</table></body></html>'

		-- Send notification mails--
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'DBAlertEmail', 
			@body = @body,
			@importance='High',
			@body_format ='HTML',
			@recipients = 'vinay@oceanfrogs.com;deepak.krishnan@oceanfrogs.com;nkjauthentic@gmail.com;soft.gandhi@gmail.com;gautamvijay88@gmail.com', 
			@subject = @servername  ;
		-- Ends here-- 
	End

END
