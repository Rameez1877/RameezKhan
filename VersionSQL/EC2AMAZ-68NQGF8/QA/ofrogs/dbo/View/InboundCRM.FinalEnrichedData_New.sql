/****** Object:  View [dbo].[InboundCRM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.FinalEnrichedData_New
AS
SELECT        II.ID, II.FirstName, II.LastName, II.PhoneNumber, II.Email, II.CreatedDate, II.Country, II.CompanyName,II.InsertedDate, IE.FirstName AS EnrichedFirstName, IE.LastName AS EnrichedLastName, II.Gender, IE.Designation, 
                         IE.EmployerName, II.EmailVerificationStatus, IE.LinkedinURL, II.IsPersonalEmail, IE.Country AS EnrichedCountry, I.Name AS IndustryName, O.Revenue, CASE WHEN ROW_NUMBER() OVER (PARTITION BY 
                         IE.FirstName, IE.LastName, IE.EmployerName
ORDER BY II.CreatedDate) = 1 THEN 'N' ELSE 'Y' END AS Revisit_Person, CASE WHEN ROW_NUMBER() OVER (PARTITION BY IE.EmployerName
ORDER BY II.CreatedDate) = 1 THEN 'N' ELSE 'Y' END AS Revisit_Company
FROM            ofrogs.InboundCRM.InboundInput II JOIN
                         ofrogs.InboundCRM.EnrichedProfile IE ON II.id = IE.InboundInputId LEFT OUTER JOIN
                         Organization O ON IE.EmployerName COLLATE Latin1_General_CI_AI = o.Name LEFT OUTER JOIN
                         Industry I ON O.IndustryId = I.id         
