/****** Object:  View [dbo].[v_datacontentmeansdefinition]    Committed by VersionSQL https://www.versionsql.com ******/

create view v_datacontentmeansdefinition as SELECT
    id,
    section,
    means_text,
    SUBSTRING(means_text, 1, CHARINDEX('”', means_text)) AS term,
	ltrim(replace(replace(replace(means_text,SUBSTRING(means_text, 1, CHARINDEX('”', means_text)),''),'means ',''),'means, ','')) termdefinition
FROM datacontentmeansdefinition
