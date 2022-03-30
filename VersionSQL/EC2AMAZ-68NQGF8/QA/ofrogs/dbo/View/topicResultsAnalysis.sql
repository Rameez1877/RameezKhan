/****** Object:  View [dbo].[topicResultsAnalysis]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.topicResultsAnalysis
AS
SELECT        RFIT.TagId, T.Label, RFI.Link, RFI.Id, T.Score
FROM            dbo.Topic AS T INNER JOIN
                         dbo.RssFeedItem AS RFI RIGHT OUTER JOIN
                         dbo.RssFeedItemTag AS RFIT ON RFIT.RssFeedItemId = RFI.Id ON T.RssFeedItemId = RFI.Id
WHERE        (T.RssFeedItemId > 3952298) AND (T.Score > 0.4) AND (T.Label IN ('Happiness at work', 'Learning management system', 'Talent management system', 'Employee value proposition', 'Leadership development', 
                         'Succession planning', 'onboarding', 'Educational assessment', 'Workforce management', 'Human resource management system', 'Employment', 'Leadership', 'Behavioural sciences', 'Psychological concepts', 
                         'Applied psychology', 'Organizational behavior', 'Human resource management', 'Industrial and organizational psychology', 'Employee engagement', 'Interpersonal relationships', 
                         'Competence (human resources)', 'performance management', 'Working conditions', 'Employee benefits', 'Performance appraisal', 'Unemployment', 'Talent management', 'Employee retention', 
                         'Performance management', 'Working conditions', 'Employee benefits'))
