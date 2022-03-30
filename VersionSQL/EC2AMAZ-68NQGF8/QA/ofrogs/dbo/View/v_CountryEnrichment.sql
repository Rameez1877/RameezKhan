/****** Object:  View [dbo].[v_CountryEnrichment]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.v_CountryEnrichment
AS
SELECT        Country, COUNT(*) AS cnt
FROM            InboundCRM.EnrichedProfile
GROUP BY Country
