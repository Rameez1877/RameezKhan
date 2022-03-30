/****** Object:  Function [dbo].[SplitToRows]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[SplitToRows] (@column varchar(1000), @separator varchar(10))
RETURNS @rtnTable TABLE
  (
  ID int identity(1,1),
  ColumnA varchar(max)
  )
 AS
BEGIN
    DECLARE @position int = 0
    DECLARE @endAt int = 0
    DECLARE @tempString varchar(1000)

    set @column = ltrim(rtrim(@column))

    WHILE @position<=len(@column)
    BEGIN       
        set @endAt = CHARINDEX(@separator,@column,@position)
            if(@endAt=0)
            begin
            Insert into @rtnTable(ColumnA) Select substring(@column,@position,len(@column)-@position+1)
            break;
            end
        set @tempString = substring(ltrim(rtrim(@column)),@position,@endAt-@position)

        Insert into @rtnTable(ColumnA) select @tempString
        set @position=@endAt+1;
    END
    return
END
