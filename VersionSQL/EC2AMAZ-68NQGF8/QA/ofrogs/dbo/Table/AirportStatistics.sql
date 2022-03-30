/****** Object:  Table [dbo].[AirportStatistics]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AirportStatistics](
	[TagId] [int] NULL,
	[NumberOfPassengers] [int] NULL,
	[AircraftMovement] [int] NULL,
	[Year] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[AirportStatistics] ADD  DEFAULT ((0)) FOR [NumberOfPassengers]
ALTER TABLE [dbo].[AirportStatistics] ADD  DEFAULT ((0)) FOR [Year]
ALTER TABLE [dbo].[AirportStatistics]  WITH NOCHECK ADD  CONSTRAINT [FK__AirportSt__TagId__68536ACF] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tag] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[AirportStatistics] CHECK CONSTRAINT [FK__AirportSt__TagId__68536ACF]
