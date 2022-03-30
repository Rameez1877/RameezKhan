/****** Object:  View [dbo].[V_Education_Level]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[V_Education_Level] as
(
SELECT ' Phd ' EducationLevel, 'Phd' EducationLevelDisplay,1 As Sequence
UNION ALL
SELECT ' Phd.' EducationLevel, 'Phd' EducationLevelDisplay,  1 As Sequence
UNION ALL
SELECT ',Phd.' EducationLevel, 'Phd' EducationLevelDisplay ,  1 As Sequence
UNION ALL
SELECT ' MBA' EducationLevel, 'MBA' EducationLevelDisplay ,  2 As Sequence
UNION ALL
SELECT ' Phd.' EducationLevel, 'MBA' EducationLevelDisplay ,  2 As Sequence
UNION ALL
SELECT ',Phd.' EducationLevel, 'MBA' EducationLevelDisplay , 2 As Sequence
UNION ALL
SELECT ' PMP' EducationLevel, 'PMP' EducationLevelDisplay ,  3 As Sequence
UNION ALL
SELECT ' PMP.' EducationLevel, 'PMP' EducationLevelDisplay ,  3 As Sequence
UNION ALL
SELECT ',PMP.' EducationLevel, 'PMP' EducationLevelDisplay , 3 As Sequence)
