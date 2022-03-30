/****** Object:  View [dbo].[SuperStoreView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.SuperStoreView
AS
SELECT        TABLE_NAME, COLUMN_NAME, DATA_TYPE, MeasureDimension
FROM            (SELECT        TABLE_NAME, COLUMN_NAME, DATA_TYPE, 
                                                    CASE WHEN DATA_TYPE = 'nvarchar' THEN 'dimension' WHEN DATA_TYPE = 'varchar' THEN 'dimension' WHEN DATA_TYPE = 'datetime' THEN 'Both' WHEN
                                                     DATA_TYPE = 'float' THEN 'measure' WHEN DATA_TYPE = 'Integer' THEN 'measure' WHEN DATA_TYPE = 'numeric' THEN 'measure' ELSE NULL 
                                                    END AS MeasureDimension
                          FROM            INFORMATION_SCHEMA.COLUMNS
                          WHERE        (TABLE_NAME = 'SuperStore')) AS A
