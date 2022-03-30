/****** Object:  Procedure [dbo].[PopulateOracleData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<ASEF DAQIQ>
-- Create date: <25 Jul 2021>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateOracleData]
@TargetPersonaId int = 29638
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  SELECT
    Id,
    Name,
    Revenue,
    EmployeeCount,
    WebsiteUrl,
    IndustryId,
    CountryId INTO #Organization
  FROM Organization
  WHERE CountryId = 13
  AND IndustryId NOT IN (38, 69, 85, 105, 106, 151)
  AND Revenue IN ('>1B', '100M-250M', '10M-50M', '250M-500M', '500M-1B', '50M-100M', 'Unknown')

  SELECT
    OrganizationId,
    TeamName INTO #teams
  FROM cache.OrganizationTeams
  WHERE TeamName IN ('AWS Certified', 'Information Security', 'Digital Transformation', 'Intelligent Automation')
 
 SELECT DISTINCT
    o.id as OrganizationId,
    o.name AS OrganizationName,
    --Tech.Keyword as Technology,
    --tssc.StackType as TechnologyCategory,
    --c.name as CountryName,
    --i.name as IndustryName,
    --o.Revenue as Revenue,
    --o.EmployeeCount as EmployeeCount,
    O.WebsiteUrl,
    --t.teamName,
    CASE WHEN tech.Keyword LIKE '%Azure%' THEN 1  ELSE 0
	END Azure,
    CASE
      WHEN tech.Keyword LIKE '%AWS%' THEN 1
      ELSE 0
    END AWS,
    CASE
      WHEN tech.Keyword LIKE '%Google Cloud Platform(GCP)%' THEN 1
      ELSE 0
    END GCP,
    CASE
      WHEN tech.Keyword LIKE '%Oracle Cloud%' THEN 1
      ELSE 0
    END OracleCloud,
    CASE
      WHEN tssc.StackType = 'Cloud Platform' THEN 1
      ELSE 0
    END CloudPlatform,
    CASE
      WHEN tssc.StackType = 'Cloud Services' THEN 1
      ELSE 0
    END CloudServices,
    CASE
      WHEN tssc.StackType = 'Cloud Management' THEN 1
      ELSE 0
    END CloudManagement,
    CASE
      WHEN tssc.StackType = 'Cloud Security' THEN 1
      ELSE 0
    END CloudSecurity,
    CASE
      WHEN tssc.StackType = 'Cloud Native' THEN 1
      ELSE 0
    END CloudNative,
    CASE
      WHEN tssc.StackType = 'Endpoint Security' THEN 1
      ELSE 0
    END EndpointSecurity,
    CASE
      WHEN tssc.StackType = 'Big Data' THEN 1
      ELSE 0
    END BigData,
    CASE
      WHEN tssc.StackType = 'Predictive Analytics' THEN 1
      ELSE 0
    END PredictiveAnalytics,
    CASE
      WHEN t.TeamName = 'Information Security' THEN 1
      ELSE 0
    END InformationSecurity,
    CASE
      WHEN t.TeamName = 'Intelligent Automation' THEN 1
      ELSE 0
    END IntelligentAutomation,
    CASE
      WHEN t.TeamName = 'Digital Transformation' THEN 1
      ELSE 0
    END DigitalTransformation,
    CASE
      WHEN t.TeamName = 'AWS Certified' THEN 1
      ELSE 0
    END AWSCertified INTO #oracle
  FROM Technographics Tech WITH (NOLOCK)
  INNER JOIN TechStackTechnology tst
    ON (tech.keyword = tst.stacktechnologyname)
  INNER JOIN TechStackSubCategory tssc
    ON (tst.StackSubCategoryId = tssc.Id)
  INNER JOIN #Organization o WITH (NOLOCK)
    ON (tech.OrganizationId = o.id)
  INNER JOIN #teams t
    ON (o.Id = t.organizationId)
  LEFT JOIN Industry i
    ON (o.industryid = i.id)
  LEFT JOIN Country c
    ON (o.countryid = c.id)
  GROUP BY o.Name,
			o.Id,
           o.WebsiteUrl,
           tech.Keyword,
           tssc.StackType,
           t.TeamName
  SELECT DISTINCT
	OrganizationId,
    OrganizationName,
    websiteurl,
    MAX(azure) AS Azure,
    MAX(aws) AS AWS,
    MAX(GCP) AS GCP,
    MAX(OracleCloud) AS OracleCloud,
    MAX(CloudPlatform) CloudPlatform,
    MAX(CloudServices) CloudServices,
    MAX(CloudManagement) CloudManagement,
    MAX(CloudSecurity) CloudSecurity,
    MAX(CloudNative) CloudNative,
    MAX(EndpointSecurity) EndpointSecurity,
    MAX(BigData) BigData,
    MAX(PredictiveAnalytics) PredictiveAnalytics,
    MAX(InformationSecurity) InformationSecurity,
    MAX(IntelligentAutomation) IntelligentAutomation,
    MAX(DigitalTransformation) DigitalTransformation,
    MAX(AWSCertified) AWSCertified
	into #score
  FROM #oracle
  GROUP BY 
			OrganizationId,
			OrganizationName,
           WebsiteUrl

		   alter table #score add 	AzureWeight int,
									AWSWeight int,
									GCPWeight int,
									OracleCloudWeight int,
									CloudPlatformWeight int,
									CloudServicesWeight int,
									CloudManagementWeight int,
									CloudSecurityWeight int,
									CloudNativeWeight int, 
									EndpointSecurityWeight int, 
									BigDataWeight int,
									PredictiveAnalyticsWeight int,
									InformationSecurityWeight int,
									IntelligentAutomationWeight int,
									DigitalTransformationWeight int,
									AWSCertifiedWeight int

		update #score set 
						AzureWeight = (Azure * 1),
						AWSWeight = (AWS * 10),
						GCPWeight = (GCP * 1),
						OracleCloudWeight = (OracleCloud * 10),
						CloudPlatformWeight = (CloudPlatform * 5),
						CloudServicesWeight = (CloudServices * 5),
						CloudManagementWeight = (CloudManagement * 5),
						CloudSecurityWeight = (CloudSecurity * 10),
						CloudNativeWeight = (CloudNative * 5),
						EndpointSecurityWeight = (EndpointSecurity * 10),
						BigDataWeight = (BigData * 10),
						PredictiveAnalyticsWeight = (PredictiveAnalytics * 10) ,
						InformationSecurityWeight = (InformationSecurity * 10),
						IntelligentAutomationWeight = (IntelligentAutomation * 10),
						DigitalTransformationWeight = (DigitalTransformation * 10),
						AWSCertifiedWeight = (AWSCertified * 10)

				alter table #score add score int
				update #score set Score = (azureweight + awsWeight + GCPWeight +
												OracleCloudWeight +
												CloudPlatformWeight +
												CloudServicesWeight +
												CloudManagementWeight +
												CloudSecurityWeight +
												CloudNativeWeight +
												EndpointSecurityWeight +
												BigDataWeight +
												PredictiveAnalyticsWeight +
												InformationSecurityWeight +
												IntelligentAutomationWeight +
												DigitalTransformationWeight +
												AWSCertifiedWeight)
select top 30 OrganizationId, OrganizationName,
WebsiteUrl,
		   Azure,
           AWS,
           GCP,
           OracleCloud,
           CloudPlatform,
           CloudServices,
           CloudManagement,
           CloudSecurity,
           CloudNative,
           EndpointSecurity,
           BigData,
           PredictiveAnalytics,
           InformationSecurity,
           IntelligentAutomation,
           DigitalTransformation,
           AWSCertified,
		   Score
From #score


END
