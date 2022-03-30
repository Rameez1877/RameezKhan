/****** Object:  View [dbo].[OutputIndustryTagSignal]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.OutputIndustryTagSignal
AS
SELECT        dbo.Tag.TagTypeId, dbo.OutputIndustrySignalAnalysis.IndustryId, dbo.OutputIndustrySignalAnalysis.tagName, dbo.OutputIndustrySignalAnalysis.SignalId, dbo.OutputIndustrySignalAnalysis.DisplayName, 
                         dbo.OutputIndustrySignalAnalysis.newsQuarter, dbo.OutputIndustrySignalAnalysis.PubDate, dbo.OutputIndustrySignalAnalysis.SignalType, dbo.Signal.SignalWeight
FROM            dbo.Tag INNER JOIN
                         dbo.OutputIndustrySignalAnalysis ON dbo.Tag.Id = dbo.OutputIndustrySignalAnalysis.tagId INNER JOIN
                         dbo.Signal ON dbo.OutputIndustrySignalAnalysis.SignalId = dbo.Signal.Id
