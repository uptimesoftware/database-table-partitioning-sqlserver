IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_aggregate_new' AND type = 'U') DROP TABLE performance_aggregate_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_cpu_new' AND type = 'U') DROP TABLE performance_cpu_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_disk_new' AND type = 'U') DROP TABLE performance_disk_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_disk_total_new' AND type = 'U') DROP TABLE performance_disk_total_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_esx3_workload_new' AND type = 'U') DROP TABLE performance_esx3_workload_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_fscap_new' AND type = 'U') DROP TABLE performance_fscap_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_lpar_workload_new' AND type = 'U') DROP TABLE performance_lpar_workload_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_network_new' AND type = 'U') DROP TABLE performance_network_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_nrm_new' AND type = 'U') DROP TABLE performance_nrm_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_psinfo_new' AND type = 'U') DROP TABLE performance_psinfo_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_vxvol_new' AND type = 'U') DROP TABLE performance_vxvol_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_who_new' AND type = 'U') DROP TABLE performance_who_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_sample_new' AND type = 'U') DROP TABLE performance_sample_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'erdc_int_data_new' AND type = 'U') DROP TABLE erdc_int_data_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'erdc_decimal_data_new' AND type = 'U') DROP TABLE erdc_decimal_data_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'erdc_string_data_new' AND type = 'U') DROP TABLE erdc_string_data_new
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'ranged_object_value_new' AND type = 'U') DROP TABLE ranged_object_value_new
GO

CREATE TABLE [dbo].[performance_sample_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_id] [numeric](19, 0) NULL,
	[uptimehost_id] [numeric](19, 0) NULL,
	[sample_time] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_aggregate_new](
	[sample_id] [numeric](19, 0) NOT NULL,
	[cpu_usr] [float] NULL,
	[cpu_sys] [float] NULL,
	[cpu_wio] [float] NULL,
	[free_mem] [float] NULL,
	[free_swap] [float] NULL,
	[run_queue] [float] NULL,
	[run_occ] [float] NULL,
	[read_cache] [float] NULL,
	[write_cache] [float] NULL,
	[pg_out_sec] [float] NULL,
	[ppg_out_sec] [float] NULL,
	[pg_free_sec] [float] NULL,
	[pg_scan_sec] [float] NULL,
	[atch_sec] [float] NULL,
	[pg_in_sec] [float] NULL,
	[ppg_in_sec] [float] NULL,
	[pflt_sec] [float] NULL,
	[vflt_sec] [float] NULL,
	[slock_sec] [float] NULL,
	[num_procs] [numeric](19, 0) NULL,
	[proc_read] [float] NULL,
	[proc_write] [float] NULL,
	[proc_block] [float] NULL,
	[dnlc] [float] NULL,
	[fork_sec] [float] NULL,
	[exec_sec] [float] NULL,
	[tcp_retrans] [numeric](19, 0) NULL,
	[worst_disk_usage] [numeric](19, 0) NULL,
	[worst_disk_busy] [numeric](19, 0) NULL,
	[used_swap_percent] [numeric](19, 0) NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sample_id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



CREATE TABLE [dbo].[performance_cpu_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[cpu_id] [numeric](19, 0) NULL,
	[cpu_usr] [numeric](19, 0) NULL,
	[cpu_sys] [numeric](19, 0) NULL,
	[cpu_wio] [numeric](19, 0) NULL,
	[xcal] [numeric](19, 0) NULL,
	[intr] [numeric](19, 0) NULL,
	[smtx] [numeric](19, 0) NULL,
	[minf] [float] NULL,
	[mjf] [float] NULL,
	[ithr] [float] NULL,
	[csw] [float] NULL,
	[icsw] [float] NULL,
	[migr] [float] NULL,
	[srw] [float] NULL,
	[syscl] [float] NULL,
	[idle] [float] NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_disk_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[disk_name] [varchar](255) NULL,
	[pct_time_busy] [numeric](19, 0) NULL,
	[avg_queue_req] [numeric](19, 0) NULL,
	[rw_sec] [numeric](19, 0) NULL,
	[blocks_sec] [numeric](19, 0) NULL,
	[avg_wait_time] [numeric](19, 0) NULL,
	[avg_serv_time] [numeric](19, 0) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_disk_total_new](
	[sample_id] [numeric](19, 0) NOT NULL,
	[pct_time_busy] [numeric](19, 0) NULL,
	[avg_queue_req] [numeric](19, 0) NULL,
	[rw_sec] [numeric](19, 0) NULL,
	[blocks_sec] [numeric](19, 0) NULL,
	[avg_wait_time] [numeric](19, 0) NULL,
	[avg_serv_time] [numeric](19, 0) NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sample_id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_esx3_workload_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[uuid] [varchar](255) NULL,
	[instance_name] [varchar](255) NULL,
	[cpu_usage_mhz] [numeric](19, 0) NULL,
	[memory] [numeric](19, 0) NULL,
	[disk_io_rate] [numeric](19, 0) NULL,
	[network_io_rate] [numeric](19, 0) NULL,
	[percent_ready] [float] NULL,
	[percent_used] [float] NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_fscap_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[filesystem] [varchar](255) NULL,
	[total_size] [numeric](19, 0) NULL,
	[space_used] [numeric](19, 0) NULL,
	[space_avail] [numeric](19, 0) NULL,
	[percent_used] [numeric](19, 0) NULL,
	[mount_point] [varchar](255) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_lpar_workload_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[lpar_id] [numeric](19, 0) NULL,
	[instance_name] [varchar](255) NULL,
	[entitlement] [float] NULL,
	[cpu_usage] [float] NULL,
	[used_memory] [numeric](19, 0) NULL,
	[network_io_rate] [numeric](19, 0) NULL,
	[disk_io_rate] [numeric](19, 0) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_network_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[iface_name] [varchar](255) NULL,
	[in_bytes] [numeric](19, 0) NULL,
	[out_bytes] [numeric](19, 0) NULL,
	[collisions] [numeric](19, 0) NULL,
	[in_errors] [numeric](19, 0) NULL,
	[out_errors] [numeric](19, 0) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_nrm_new](
	[sample_id] [numeric](19, 0) NOT NULL,
	[work_to_do] [numeric](19, 0) NULL,
	[available_disk] [numeric](19, 0) NULL,
	[ds_thread_usage] [numeric](19, 0) NULL,
	[allocated_server_procs] [numeric](19, 0) NULL,
	[available_server_procs] [numeric](19, 0) NULL,
	[packet_receive_buffers] [numeric](19, 0) NULL,
	[available_ecbs] [numeric](19, 0) NULL,
	[lan_traffic] [numeric](19, 0) NULL,
	[connection_usage] [numeric](19, 0) NULL,
	[disk_throughput] [numeric](19, 0) NULL,
	[abended_thread_count] [numeric](19, 0) NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sample_id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_psinfo_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[pid] [numeric](19, 0) NULL,
	[ppid] [numeric](19, 0) NULL,
	[ps_uid] [varchar](255) NULL,
	[gid] [varchar](255) NULL,
	[mem_used] [numeric](19, 0) NULL,
	[rss] [numeric](19, 0) NULL,
	[cpu_usage] [float] NULL,
	[memory_usage] [float] NULL,
	[user_cpu_time] [numeric](19, 0) NULL,
	[sys_cpu_time] [numeric](19, 0) NULL,
	[start_time] [datetime] NULL,
	[proc_name] [varchar](255) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_vxvol_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[dg] [varchar](255) NULL,
	[vol] [varchar](255) NULL,
	[rd_ops] [numeric](19, 0) NULL,
	[wr_ops] [numeric](19, 0) NULL,
	[rd_blks] [numeric](19, 0) NULL,
	[wr_blks] [numeric](19, 0) NULL,
	[avg_rd] [numeric](19, 0) NULL,
	[avg_wr] [numeric](19, 0) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[performance_who_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[username] [varchar](255) NULL,
	[session_count] [numeric](19, 0) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]




CREATE TABLE [dbo].[erdc_int_data_new](
	[erdc_int_data_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_instance_id] [numeric](19, 0) NULL,
	[erdc_parameter_id] [numeric](19, 0) NULL,
	[value] [numeric](19, 0) NULL,
	[sampletime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[erdc_int_data_id],
	[sampletime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[erdc_decimal_data_new](
	[erdc_int_data_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_instance_id] [numeric](19, 0) NULL,
	[erdc_parameter_id] [numeric](19, 0) NULL,
	[value] [float] NULL,
	[sampletime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[erdc_int_data_id],
	[sampletime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[erdc_string_data_new](
	[erdc_int_data_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_instance_id] [numeric](19, 0) NULL,
	[erdc_parameter_id] [numeric](19, 0) NULL,
	[value] [text] NULL,
	[sampletime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[erdc_int_data_id],
	[sampletime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]



CREATE TABLE [dbo].[ranged_object_value_new](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[ranged_object_id] [numeric](19, 0) NULL,
	[name] [varchar](255) NULL,
	[value] [float] NULL,
	[sample_time] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



/* now we need to create indexes as well so these tables are identical to the originals */

CREATE INDEX LATEST_PERF_SAMPLE ON performance_sample_new
(
erdc_id,
sample_time
)

CREATE INDEX LATEST_SAMPLE_BY_HOST ON performance_sample_new
(
uptimehost_id,
sample_time
)


CREATE INDEX CPU_SAMPLE_ID ON performance_cpu_new
(
sample_id
)

CREATE INDEX DISK_SAMPLE_ID ON performance_disk_new
(
sample_id
)

CREATE INDEX DISK_TOTAL_SAMPLE_ID ON performance_disk_total_new
(
sample_id
)

CREATE INDEX ESX3_WORKLOAD_SAMPLE_ID ON performance_esx3_workload_new
(
sample_id
)

CREATE INDEX FSCAP_SAMPLE_ID ON performance_fscap_new
(
sample_id
)

CREATE INDEX LPAR_WORKLOAD_SAMPLE_ID ON performance_lpar_workload_new
(
sample_id
)

CREATE INDEX NETWORK_SAMPLE_ID ON performance_network_new
(
sample_id
)

CREATE INDEX PSINFO_SAMPLE_ID ON performance_psinfo_new
(
sample_id
)

CREATE INDEX VXVOL_SAMPLE_ID ON performance_vxvol_new
(
sample_id
)

CREATE INDEX WHO_SAMPLE_ID ON performance_who_new
(
sample_id
)

CREATE INDEX IDX_SVC_METRICS_INT ON erdc_int_data_new
(
erdc_parameter_id,
erdc_instance_id,
sampletime
)

CREATE INDEX IDX_SVC_METRICS_DEC ON erdc_decimal_data_new
(
erdc_parameter_id,
erdc_instance_id,
sampletime
)

CREATE INDEX IDX_SVC_METRICS_STR ON erdc_string_data_new
(
erdc_parameter_id,
erdc_instance_id,
sampletime
)
