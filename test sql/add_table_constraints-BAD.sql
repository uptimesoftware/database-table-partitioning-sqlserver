USE [uptime]
GO


BEGIN TRANSACTION

ALTER TABLE [dbo].[performance_aggregate]  WITH CHECK ADD  CONSTRAINT [FKF7C28C7060A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_aggregate] CHECK CONSTRAINT [FKF7C28C7060A224C3]
GO



ALTER TABLE [dbo].[performance_cpu]  WITH CHECK ADD  CONSTRAINT [FKF28C291960A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_cpu] CHECK CONSTRAINT [FKF28C291960A224C3]
GO



ALTER TABLE [dbo].[performance_disk]  WITH CHECK ADD  CONSTRAINT [FK5EF9544C60A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_disk] CHECK CONSTRAINT [FK5EF9544C60A224C3]
GO



ALTER TABLE [dbo].[performance_esx3_workload]  WITH CHECK ADD  CONSTRAINT [FKC370C93E60A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_esx3_workload] CHECK CONSTRAINT [FKC370C93E60A224C3]
GO



ALTER TABLE [dbo].[performance_fscap]  WITH CHECK ADD  CONSTRAINT [FK8051B31660A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_fscap] CHECK CONSTRAINT [FK8051B31660A224C3]
GO



ALTER TABLE [dbo].[performance_lpar_workload]  WITH CHECK ADD  CONSTRAINT [FKEF77CDF260A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_lpar_workload] CHECK CONSTRAINT [FKEF77CDF260A224C3]
GO



ALTER TABLE [dbo].[performance_network]  WITH CHECK ADD  CONSTRAINT [FK42F8E11F60A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_network] CHECK CONSTRAINT [FK42F8E11F60A224C3]
GO



ALTER TABLE [dbo].[performance_nrm]  WITH CHECK ADD  CONSTRAINT [FKF28C529A60A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_nrm] CHECK CONSTRAINT [FKF28C529A60A224C3]
GO



ALTER TABLE [dbo].[performance_psinfo]  WITH CHECK ADD  CONSTRAINT [FK9AF8102060A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_psinfo] CHECK CONSTRAINT [FK9AF8102060A224C3]
GO



ALTER TABLE [dbo].[performance_vxvol]  WITH CHECK ADD  CONSTRAINT [FK8135BA0260A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_vxvol] CHECK CONSTRAINT [FK8135BA0260A224C3]
GO


ALTER TABLE [dbo].[performance_who]  WITH CHECK ADD  CONSTRAINT [FKF28C732F60A224C3] FOREIGN KEY([sample_id])
REFERENCES [dbo].[performance_sample] ([id])
GO

ALTER TABLE [dbo].[performance_who] CHECK CONSTRAINT [FKF28C732F60A224C3]
GO





ALTER TABLE [dbo].[ranged_object_value]  WITH CHECK ADD  CONSTRAINT [FK74D2E2E92362BFC] FOREIGN KEY([ranged_object_id])
REFERENCES [dbo].[ranged_object] ([id])
GO

ALTER TABLE [dbo].[ranged_object_value] CHECK CONSTRAINT [FK74D2E2E92362BFC]
GO

COMMIT TRANSACTION
