BEGIN TRANSACTION

INSERT INTO dbo.performance_aggregate_new
SELECT p.*, ps.sample_time
FROM performance_aggregate p, performance_sample ps
WHERE p.sample_id = ps.id
GO
DROP TABLE performance_aggregate
GO
EXEC sp_rename 'dbo.performance_aggregate_new', 'performance_aggregate'
GO


SET IDENTITY_INSERT performance_cpu_new ON
INSERT INTO dbo.performance_cpu_new
(id
,cpu_id
,cpu_usr
,cpu_sys
,cpu_wio
,xcal
,intr
,smtx
,minf
,mjf
,ithr
,csw
,icsw
,migr
,srw
,syscl
,idle
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_cpu p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_cpu_new OFF
DROP TABLE performance_cpu
GO
EXEC sp_rename 'dbo.performance_cpu_new', 'performance_cpu'
GO


SET IDENTITY_INSERT performance_disk_new ON
INSERT INTO dbo.performance_disk_new
(id
,disk_name
,pct_time_busy
,avg_queue_req
,rw_sec
,blocks_sec
,avg_wait_time
,avg_serv_time
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_disk p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_disk_new OFF
DROP TABLE performance_disk
GO
EXEC sp_rename 'dbo.performance_disk_new', 'performance_disk'
GO


SET IDENTITY_INSERT performance_disk_total_new ON
INSERT INTO dbo.performance_disk_total_new
(sample_id
,pct_time_busy
,avg_queue_req
,rw_sec
,blocks_sec
,avg_wait_time
,avg_serv_time
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_disk_total p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_disk_total_new OFF
DROP TABLE performance_disk_total
GO
EXEC sp_rename 'dbo.performance_disk_total_new', 'performance_disk_total'
GO


SET IDENTITY_INSERT performance_esx3_workload_new ON
INSERT INTO dbo.performance_esx3_workload_new
(id
,uuid
,instance_name
,cpu_usage_mhz
,memory
,disk_io_rate
,network_io_rate
,percent_ready
,percent_used
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_esx3_workload p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_esx3_workload_new OFF
DROP TABLE performance_esx3_workload
GO
EXEC sp_rename 'dbo.performance_esx3_workload_new', 'performance_esx3_workload'
GO


SET IDENTITY_INSERT performance_fscap_new ON
INSERT INTO dbo.performance_fscap_new
(id
,filesystem
,total_size
,space_used
,space_avail
,percent_used
,mount_point
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_fscap p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_fscap_new OFF
DROP TABLE performance_fscap
GO
EXEC sp_rename 'dbo.performance_fscap_new', 'performance_fscap'
GO


SET IDENTITY_INSERT performance_lpar_workload_new ON
INSERT INTO dbo.performance_lpar_workload_new
(id
,lpar_id
,instance_name
,entitlement
,cpu_usage
,used_memory
,network_io_rate
,disk_io_rate
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_lpar_workload p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_lpar_workload_new OFF
DROP TABLE performance_lpar_workload
GO
EXEC sp_rename 'dbo.performance_lpar_workload_new', 'performance_lpar_workload'
GO


SET IDENTITY_INSERT performance_network_new ON
INSERT INTO dbo.performance_network_new
(id
,iface_name
,in_bytes
,out_bytes
,collisions
,in_errors
,out_errors
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_network p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_network_new OFF
DROP TABLE performance_network
GO
EXEC sp_rename 'dbo.performance_network_new', 'performance_network'
GO


INSERT INTO dbo.performance_nrm_new
SELECT p.*, ps.sample_time
FROM performance_nrm p, performance_sample ps
WHERE p.sample_id = ps.id
GO
DROP TABLE performance_nrm
GO
EXEC sp_rename 'dbo.performance_nrm_new', 'performance_nrm'
GO


SET IDENTITY_INSERT performance_psinfo_new ON
INSERT INTO dbo.performance_psinfo_new
(id
,pid
,ppid
,ps_uid
,gid
,mem_used
,rss
,cpu_usage
,memory_usage
,user_cpu_time
,sys_cpu_time
,start_time
,proc_name
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_psinfo p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_psinfo_new OFF
DROP TABLE performance_psinfo
GO
EXEC sp_rename 'dbo.performance_psinfo_new', 'performance_psinfo'
GO


SET IDENTITY_INSERT performance_vxvol_new ON
INSERT INTO dbo.performance_vxvol_new
(id
,dg
,vol
,rd_ops
,wr_ops
,rd_blks
,wr_blks
,avg_rd
,avg_wr
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_vxvol p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_vxvol_new OFF
DROP TABLE performance_vxvol
GO
EXEC sp_rename 'dbo.performance_vxvol_new', 'performance_vxvol'
GO


SET IDENTITY_INSERT performance_who_new ON
INSERT INTO dbo.performance_who_new
(id
,username
,session_count
,sample_id
,sample_date
)
SELECT p.*, ps.sample_time
FROM performance_who p, performance_sample ps
WHERE p.sample_id = ps.id
GO
SET IDENTITY_INSERT performance_who_new OFF
DROP TABLE performance_who
GO
EXEC sp_rename 'dbo.performance_who_new', 'performance_who'
GO


SET IDENTITY_INSERT performance_sample_new ON
INSERT INTO dbo.performance_sample_new
(id
,erdc_id
,uptimehost_id
,sample_time
)
SELECT p.*
FROM performance_sample p
GO
SET IDENTITY_INSERT performance_sample_new OFF
DROP TABLE performance_sample
GO
EXEC sp_rename 'dbo.performance_sample_new', 'performance_sample'
GO


SET IDENTITY_INSERT erdc_int_data_new ON
INSERT INTO dbo.erdc_int_data_new
(erdc_int_data_id,
erdc_instance_id,
erdc_parameter_id,
value,
sampletime
)
SELECT p.*
FROM erdc_int_data p
GO
SET IDENTITY_INSERT erdc_int_data_new OFF
DROP TABLE erdc_int_data
GO
EXEC sp_rename 'dbo.erdc_int_data_new', 'erdc_int_data'
GO


SET IDENTITY_INSERT erdc_decimal_data_new ON
INSERT INTO dbo.erdc_decimal_data_new
(erdc_int_data_id,
erdc_instance_id,
erdc_parameter_id,
value,
sampletime
)
SELECT p.*
FROM erdc_decimal_data p
GO
SET IDENTITY_INSERT erdc_decimal_data_new OFF
DROP TABLE erdc_decimal_data
GO
EXEC sp_rename 'dbo.erdc_decimal_data_new', 'erdc_decimal_data'
GO


SET IDENTITY_INSERT erdc_string_data_new ON
INSERT INTO dbo.erdc_string_data_new
(erdc_int_data_id,
erdc_instance_id,
erdc_parameter_id,
value,
sampletime
)
SELECT p.*
FROM erdc_string_data p
GO
SET IDENTITY_INSERT erdc_string_data_new OFF
DROP TABLE erdc_string_data
GO
EXEC sp_rename 'dbo.erdc_string_data_new', 'erdc_string_data'
GO


SET IDENTITY_INSERT ranged_object_value_new ON
INSERT INTO dbo.ranged_object_value_new
(id,
ranged_object_id,
name,
value,
sample_time
)
SELECT p.*
FROM ranged_object_value p
GO
SET IDENTITY_INSERT ranged_object_value_new OFF
DROP TABLE ranged_object_value
GO
EXEC sp_rename 'dbo.ranged_object_value_new', 'ranged_object_value'
GO

COMMIT TRANSACTION
