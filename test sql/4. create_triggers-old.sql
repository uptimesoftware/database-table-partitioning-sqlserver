USE uptime
GO
BEGIN TRANSACTION

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_aggregate' AND type = 'TR')
   DROP TRIGGER trig_insert_aggregate
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_cpu' AND type = 'TR')
   DROP TRIGGER trig_insert_cpu
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_disk' AND type = 'TR')
   DROP TRIGGER trig_insert_disk
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_esx3_workoad' AND type = 'TR')
   DROP TRIGGER trig_insert_esx3_workload
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_fscap' AND type = 'TR')
   DROP TRIGGER trig_insert_fscap
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_lpar_workload' AND type = 'TR')
   DROP TRIGGER trig_insert_lpar_workload
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_network' AND type = 'TR')
   DROP TRIGGER trig_insert_network
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_nrm' AND type = 'TR')
   DROP TRIGGER trig_insert_nrm
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_psinfo' AND type = 'TR')
   DROP TRIGGER trig_insert_psinfo
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_vxvol' AND type = 'TR')
   DROP TRIGGER trig_insert_vxvol
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_who' AND type = 'TR')
   DROP TRIGGER trig_insert_who
GO




CREATE TRIGGER trig_insert_aggregate
ON performance_aggregate
INSTEAD OF INSERT
AS

INSERT INTO performance_aggregate
(
sample_id,
cpu_usr,
cpu_sys,
cpu_wio,
free_mem,
free_swap,
run_queue,
run_occ,
read_cache,
write_cache,
pg_out_sec,
ppg_out_sec,
pg_free_sec,
pg_scan_sec,
pflt_sec,
vflt_sec,
slock_sec,
num_procs,
proc_read,
proc_write,
proc_block,
dnlc,
fork_sec,
exec_sec,
tcp_retrans,
worst_disk_usage,
worst_disk_busy,
used_swap_percent,
sample_date
)
SELECT p.sample_id,p.cpu_usr,p.cpu_sys,p.cpu_wio,p.free_mem,p.free_swap,p.
run_queue,p.run_occ,p.read_cache,p.write_cache,p.pg_out_sec,p.ppg_out_sec,p.
pg_free_sec,p.pg_scan_sec,p.pflt_sec,p.vflt_sec,p.slock_sec,p.num_procs,p.
proc_read,p.proc_write,p.proc_block,p.dnlc,p.fork_sec,p.exec_sec,p.tcp_retrans,p.
worst_disk_usage,p.worst_disk_busy,p.used_swap_percent, GETDATE()
FROM inserted p
GO


CREATE TRIGGER trig_insert_cpu
ON performance_cpu
INSTEAD OF INSERT
AS

INSERT INTO performance_cpu
           ([cpu_id]
           ,[cpu_usr]
           ,[cpu_sys]
           ,[cpu_wio]
           ,[xcal]
           ,[intr]
           ,[smtx]
           ,[minf]
           ,[mjf]
           ,[ithr]
           ,[csw]
           ,[icsw]
           ,[migr]
           ,[srw]
           ,[syscl]
           ,[idle]
           ,[sample_id]
           ,[sample_date]
)
SELECT [cpu_id]
           ,[cpu_usr]
           ,[cpu_sys]
           ,[cpu_wio]
           ,[xcal]
           ,[intr]
           ,[smtx]
           ,[minf]
           ,[mjf]
           ,[ithr]
           ,[csw]
           ,[icsw]
           ,[migr]
           ,[srw]
           ,[syscl]
           ,[idle]
           ,[sample_id]
           ,GETDATE()
FROM inserted
GO


CREATE TRIGGER trig_insert_disk
ON performance_disk
INSTEAD OF INSERT
AS

INSERT INTO performance_disk
           ([disk_name]
           ,[pct_time_busy]
           ,[avg_queue_req]
           ,[rw_sec]
           ,[blocks_sec]
           ,[avg_wait_time]
           ,[avg_serv_time]
           ,[sample_id]
           ,[sample_date]
)
SELECT [disk_name]
      ,[pct_time_busy]
      ,[avg_queue_req]
      ,[rw_sec]
      ,[blocks_sec]
      ,[avg_wait_time]
      ,[avg_serv_time]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO


CREATE TRIGGER trig_insert_esx3_workload
ON performance_esx3_workload
INSTEAD OF INSERT
AS

INSERT INTO performance_esx3_workload
           ([uuid]
           ,[instance_name]
           ,[cpu_usage_mhz]
           ,[memory]
           ,[disk_io_rate]
           ,[network_io_rate]
           ,[percent_ready]
           ,[percent_used]
           ,[sample_id]
           ,[sample_date]
)
SELECT [uuid]
      ,[instance_name]
      ,[cpu_usage_mhz]
      ,[memory]
      ,[disk_io_rate]
      ,[network_io_rate]
      ,[percent_ready]
      ,[percent_used]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO


CREATE TRIGGER trig_insert_fscap
ON performance_fscap
INSTEAD OF INSERT
AS

INSERT INTO performance_fscap
           ([filesystem]
           ,[total_size]
           ,[space_used]
           ,[space_avail]
           ,[percent_used]
           ,[mount_point]
           ,[sample_id]
           ,[sample_date]
)
SELECT [filesystem]
      ,[total_size]
      ,[space_used]
      ,[space_avail]
      ,[percent_used]
      ,[mount_point]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO



CREATE TRIGGER trig_insert_lpar_workoad
ON performance_lpar_workload
INSTEAD OF INSERT
AS

INSERT INTO performance_lpar_workload
           ([lpar_id]
           ,[instance_name]
           ,[entitlement]
           ,[cpu_usage]
           ,[used_memory]
           ,[network_io_rate]
           ,[disk_io_rate]
           ,[sample_id]
           ,[sample_date]
)
SELECT [lpar_id]
      ,[instance_name]
      ,[entitlement]
      ,[cpu_usage]
      ,[used_memory]
      ,[network_io_rate]
      ,[disk_io_rate]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO



CREATE TRIGGER trig_insert_network
ON performance_network
INSTEAD OF INSERT
AS

INSERT INTO performance_network
           ([iface_name]
           ,[in_bytes]
           ,[out_bytes]
           ,[collisions]
           ,[in_errors]
           ,[out_errors]
           ,[sample_id]
           ,[sample_date]
)
SELECT [iface_name]
      ,[in_bytes]
      ,[out_bytes]
      ,[collisions]
      ,[in_errors]
      ,[out_errors]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO



CREATE TRIGGER trig_insert_nrm
ON performance_nrm
INSTEAD OF INSERT
AS

INSERT INTO performance_nrm
           ([sample_id]
           ,[work_to_do]
           ,[available_disk]
           ,[ds_thread_usage]
           ,[allocated_server_procs]
           ,[available_server_procs]
           ,[packet_receive_buffers]
           ,[available_ecbs]
           ,[lan_traffic]
           ,[connection_usage]
           ,[disk_throughput]
           ,[abended_thread_count]
           ,[sample_date]
)
SELECT [sample_id]
      ,[work_to_do]
      ,[available_disk]
      ,[ds_thread_usage]
      ,[allocated_server_procs]
      ,[available_server_procs]
      ,[packet_receive_buffers]
      ,[available_ecbs]
      ,[lan_traffic]
      ,[connection_usage]
      ,[disk_throughput]
      ,[abended_thread_count]
      ,GETDATE()
  FROM inserted
GO



CREATE TRIGGER trig_insert_psinfo
ON performance_psinfo
INSTEAD OF INSERT
AS

INSERT INTO performance_psinfo
           ([pid]
           ,[ppid]
           ,[ps_uid]
           ,[gid]
           ,[mem_used]
           ,[rss]
           ,[cpu_usage]
           ,[memory_usage]
           ,[user_cpu_time]
           ,[sys_cpu_time]
           ,[start_time]
           ,[proc_name]
           ,[sample_id]
           ,[sample_date]
)
SELECT [pid]
      ,[ppid]
      ,[ps_uid]
      ,[gid]
      ,[mem_used]
      ,[rss]
      ,[cpu_usage]
      ,[memory_usage]
      ,[user_cpu_time]
      ,[sys_cpu_time]
      ,[start_time]
      ,[proc_name]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO



CREATE TRIGGER trig_insert_vxvol
ON performance_vxvol
INSTEAD OF INSERT
AS

INSERT INTO performance_vxvol
           ([dg]
           ,[vol]
           ,[rd_ops]
           ,[wr_ops]
           ,[rd_blks]
           ,[wr_blks]
           ,[avg_rd]
           ,[avg_wr]
           ,[sample_id]
           ,[sample_date]
)
SELECT [dg]
      ,[vol]
      ,[rd_ops]
      ,[wr_ops]
      ,[rd_blks]
      ,[wr_blks]
      ,[avg_rd]
      ,[avg_wr]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO



CREATE TRIGGER trig_insert_who
ON performance_who
INSTEAD OF INSERT
AS

INSERT INTO performance_who
           ([username]
           ,[session_count]
           ,[sample_id]
           ,[sample_date]
)
SELECT [username]
      ,[session_count]
      ,[sample_id]
      ,GETDATE()
  FROM inserted
GO

COMMIT TRANSACTION
