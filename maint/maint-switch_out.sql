/*
Name:  upt_SwitchOutPartition
Description: Switches out the last partition in the table (if it has data).
			It will only switch out one monthly partition (last one) and complain if you're
			trying to do more.
Author:  Joel Pereira
Modification Log: Change

Description							Date			Changed By
Created procedure					11/10/2003		Joel Pereira

Description							Date			Changed By
Created procedure					04/21/2010		Joel Pereira
-fixed issue with last partition not being removed properly when there is more than one month of data in it
--date calculation issue

Description							Date			Changed By
Created procedure					04/25/2011		Joel Pereira
-added support for performance_disk_total (uptime 5.3/5.4)
*/

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_SwitchOutPartition' AND type = 'P') DROP PROCEDURE upt_SwitchOutPartition;
GO
CREATE PROCEDURE upt_SwitchOutPartition
@COLUMN_NAME varchar(50),
@TABLE_NAME varchar(50),
@SCHEME_NAME varchar(50),
@PARTITION_FUNCTION_NAME varchar(50),
@MIN_SAMPLE_DATE_IN_TABLE datetime,
@OLDEST_PARTITION_NUM int,
@MAX_DATE_IN_LAST_PARTITION datetime
AS
BEGIN
DECLARE @MONTHS_TO_KEEP int;



/********* Number of Months of Data To Keep *************/
SET @MONTHS_TO_KEEP = 6
/********************************************************/



DECLARE @SQLString varchar(500)
DECLARE @S2 nvarchar(500)
DECLARE @MONTHS_DATE datetime

/* Calculate the oldest date that we should have in the db before archiving is necessary */
IF (SELECT DATENAME(d, (GETDATE()))) > 1
BEGIN
	/* Not the first day of the month */
	SELECT @MONTHS_DATE = ( CAST ( FLOOR ( CAST ( DATEADD ( month, ( @MONTHS_TO_KEEP * -1 ) , DATEADD ( day, DATENAME ( d, ( GETDATE() ) -1 ) *-1, ( GETDATE() ) ) ) AS FLOAT ) ) AS DATETIME ) )
END
ELSE BEGIN
	/* The first day of the month (less math is necessary) */
	SELECT @MONTHS_DATE = ( CAST ( FLOOR ( CAST ( DATEADD ( month, ( @MONTHS_TO_KEEP * -1 ) , GETDATE() ) AS FLOAT ) ) AS DATETIME ) )
END

/* Info */
PRINT '************************************************'
PRINT 'Current table:'
PRINT @TABLE_NAME
PRINT 'Lowest sample_date in last partition:'
PRINT @MIN_SAMPLE_DATE_IN_TABLE
PRINT 'Highest sample_date in last partition:'
PRINT @MAX_DATE_IN_LAST_PARTITION
PRINT 'Number of months to keep:'
PRINT @MONTHS_TO_KEEP
PRINT 'Dropping anything older than:'
PRINT @MONTHS_DATE
PRINT ''


DECLARE @MERGE_DATE datetime;
IF (SELECT DATENAME(d, (@MAX_DATE_IN_LAST_PARTITION))) > 1
BEGIN
SET @MERGE_DATE = (
SELECT 
( 
	CAST
	( 
		FLOOR
		( 
			CAST
			( 
				DATEADD
				(
					month, 
					1, 
					DATEADD
					(
						day, 
						DATENAME
						(
							d, 
							(@MAX_DATE_IN_LAST_PARTITION)
							-1
						)
						*-1, 
						(@MAX_DATE_IN_LAST_PARTITION)
					)
				)
				AS FLOAT 
			) 
		) 
		AS DATETIME 
	) 
) 
AS date_only
)

END
ELSE

BEGIN
SET @MERGE_DATE = (
SELECT 
( 
	CAST
	( 
		FLOOR
		( 
			CAST
			( 
				DATEADD
				(
					month, 
					1, 
					(@MAX_DATE_IN_LAST_PARTITION)
				)
				AS FLOAT 
			) 
		) 
		AS DATETIME 
	) 
) 
AS date_only
)
END


/* check if we have any data to archive */
IF (@MAX_DATE_IN_LAST_PARTITION) < (@MONTHS_DATE)
BEGIN
	/* make sure that we aren't trying to drop multiple partitions (only one at a time!) */
	IF (@MAX_DATE_IN_LAST_PARTITION) < (DATEADD(month, -1, @MONTHS_DATE))
	BEGIN
		PRINT 'Warning: Attempting to archive more than one partition!';
		PRINT 'Increase the MONTHS_TO_KEEP variable and try again.';
		PRINT 'Skipping current table.';
	END
	ELSE BEGIN
		PRINT 'Only one partition is being dropped (OK).';
		
		PRINT 'Last partition will hold anything older than: ';
		PRINT @MERGE_DATE;
		BEGIN TRANSACTION
			/* performance_data_old table has already been created before calling this stored procedure */
			IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U')
			BEGIN
				/* create the sql query */
				/* ALTER PARTITION SCHEME [scheme_aggregate] NEXT USED [PRIMARY] */
				SET @SQLString = 'ALTER PARTITION SCHEME [' + @SCHEME_NAME  + '] NEXT USED [PRIMARY]'
				/* execute the query */
				SELECT @S2 = CAST(@SQLString AS nvarchar(500))
				EXECUTE sp_executesql @S2


				/* create the sql query */
				/* ALTER TABLE performance_aggregate SWITCH PARTITION @OLDEST_PARTITION_NUM TO [performance_aggregate_old]PARTITION @OLDEST_PARTITION_NUM */
				SET @SQLString = 'ALTER TABLE ' + @TABLE_NAME + ' SWITCH PARTITION @OLDEST_PARTITION_NUM TO [performance_data_old]PARTITION @OLDEST_PARTITION_NUM'
				/* execute the query */
				SELECT @S2 = CAST(@SQLString AS nvarchar(500))
				EXECUTE sp_executesql @S2, N'@OLDEST_PARTITION_NUM int', @OLDEST_PARTITION_NUM


				/* create the sql query */
				/* ALTER PARTITION FUNCTION [function_aggregate]() MERGE RANGE (@MERGE_DATE) */
				SET @SQLString = 'ALTER PARTITION FUNCTION [' + @PARTITION_FUNCTION_NAME + ']() MERGE RANGE (@MERGE_DATE)'
				/* execute the query */
				SELECT @S2 = CAST(@SQLString AS nvarchar(500))
				EXECUTE sp_executesql @S2, N'@MERGE_DATE datetime', @MERGE_DATE

				PRINT 'Dropped oldest partition.'
			END
			ELSE BEGIN
				PRINT 'Error: "performance_data_old" table was not created or cannot find it'
			END
		COMMIT TRANSACTION
	END
END
ELSE BEGIN
	/* Catch if there is more than one month of data in oldest partition, and if the newest data in the oldest partition is
	above datetime threshold for removal */
	IF (@MIN_SAMPLE_DATE_IN_TABLE) < (@MONTHS_DATE)
	BEGIN
		PRINT 'Older data was found in the oldest partition, but there is also newer data in the same partition that is not scheduled to be removed yet.'
	END
	ELSE BEGIN
		PRINT 'No data to archive.'
	END
END

/* Cleanup dump tables */
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;

/* add a new line */
PRINT ''

END
GO



/**************************
** PERFORMANCE_AGGREGATE **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
	[sample_date] [datetime] NOT NULL
PRIMARY KEY CLUSTERED 
(
	[sample_id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_aggregate ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_aggregate)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_aggregate(sample_date)) FROM performance_aggregate
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_aggregate AS o WHERE $partition.function_aggregate(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_aggregate(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_aggregate', 'scheme_aggregate', 'function_aggregate', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_CPU       **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_cpu ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_cpu)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_cpu(sample_date)) FROM performance_cpu
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_cpu AS o WHERE $partition.function_cpu(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_cpu(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_cpu', 'scheme_cpu', 'function_cpu', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_DISK      **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_disk ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_disk)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_disk(sample_date)) FROM performance_disk
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_disk AS o WHERE $partition.function_disk(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_disk(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_disk', 'scheme_disk', 'function_disk', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/***************************
** PERFORMANCE_DISK_TOTAL **
****************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_total_old' AND type = 'U') DROP TABLE performance_data_total_old;
CREATE TABLE [dbo].performance_data_total_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_disk_total ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_disk_total)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_disk_total(sample_date)) FROM performance_disk_total
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_disk_total AS o WHERE $partition.function_disk_total(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_disk_total(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_disk_total', 'scheme_disk_total', 'function_disk_total', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/*****************************
** PERFORMANCE_ESX3_WORKLOAD **
*****************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_esx3_workload ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_esx3_workload)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_esx3_workload(sample_date)) FROM performance_esx3_workload
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_esx3_workload AS o WHERE $partition.function_esx3_workload(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_esx3_workload(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_esx3_workload', 'scheme_esx3_workload', 'function_esx3_workload', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_FSCAP     **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_fscap ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_fscap)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_fscap(sample_date)) FROM performance_fscap
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_fscap AS o WHERE $partition.function_fscap(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_fscap(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_fscap', 'scheme_fscap', 'function_fscap', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/******************************
** PERFORMANCE_LPAR_WORKLOAD **
******************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_lpar_workload ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_lpar_workload)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_lpar_workload(sample_date)) FROM performance_lpar_workload
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_lpar_workload AS o WHERE $partition.function_lpar_workload(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_lpar_workload(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_lpar_workload', 'scheme_lpar_workload', 'function_lpar_workload', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_NETWORK   **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_network ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_network)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_network(sample_date)) FROM performance_network
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_network AS o WHERE $partition.function_network(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_network(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_network', 'scheme_network', 'function_network', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_NRM       **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_nrm ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_nrm)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_nrm(sample_date)) FROM performance_nrm
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_nrm AS o WHERE $partition.function_nrm(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_nrm(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_nrm', 'scheme_nrm', 'function_nrm', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_PSINFO    **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_psinfo ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_psinfo)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_psinfo(sample_date)) FROM performance_psinfo
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_psinfo AS o WHERE $partition.function_psinfo(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_psinfo(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_psinfo', 'scheme_psinfo', 'function_psinfo', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_VXVOL     **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_vxvol ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_vxvol)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_vxvol(sample_date)) FROM performance_vxvol
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_vxvol AS o WHERE $partition.function_vxvol(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_vxvol(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_vxvol', 'scheme_vxvol', 'function_vxvol', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_WHO       **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[username] [varchar](255) NULL,
	[session_count] [numeric](19, 0) NULL,
	[sample_id] [numeric](19, 0) NOT NULL,
	[sample_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_who ([sample_date]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_date) from performance_who)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_who(sample_date)) FROM performance_who
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_date) FROM performance_who AS o WHERE $partition.function_who(o.sample_date) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_who(o.sample_date)
exec upt_SwitchOutPartition 'sample_date', 'performance_who', 'scheme_who', 'function_who', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** PERFORMANCE_SAMPLE    **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_id] [numeric](19, 0) NULL,
	[uptimehost_id] [numeric](19, 0) NULL,
	[sample_time] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_sample ([sample_time]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_time) from performance_sample)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_sample(sample_time)) FROM performance_sample
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_time) FROM performance_sample AS o WHERE $partition.function_sample(o.sample_time) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_sample(o.sample_time)
exec upt_SwitchOutPartition 'sample_time', 'performance_sample', 'scheme_sample', 'function_sample', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** ERDC_INT_DATA         **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
	[erdc_int_data_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_instance_id] [numeric](19, 0) NULL,
	[erdc_parameter_id] [numeric](19, 0) NULL,
	[value] [numeric](19, 0) NULL,
	[sampletime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[erdc_int_data_id],
	[sampletime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_int_data ([sampletime]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sampletime) from erdc_int_data)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_int_data(sampletime)) FROM erdc_int_data
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sampletime) FROM erdc_int_data AS o WHERE $partition.function_int_data(o.sampletime) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_int_data(o.sampletime)
exec upt_SwitchOutPartition 'sampletime', 'erdc_int_data', 'scheme_int_data', 'function_int_data', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** ERDC_DECIMAL_DATA     **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
	[erdc_int_data_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_instance_id] [numeric](19, 0) NULL,
	[erdc_parameter_id] [numeric](19, 0) NULL,
	[value] [float] NULL,
	[sampletime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[erdc_int_data_id],
	[sampletime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_decimal_data ([sampletime]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sampletime) from erdc_decimal_data)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_decimal_data(sampletime)) FROM erdc_decimal_data
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sampletime) FROM erdc_decimal_data AS o WHERE $partition.function_decimal_data(o.sampletime) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_decimal_data(o.sampletime)
exec upt_SwitchOutPartition 'sampletime', 'erdc_decimal_data', 'scheme_decimal_data', 'function_decimal_data', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** ERDC_STRING_DATA      **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
	[erdc_int_data_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_instance_id] [numeric](19, 0) NULL,
	[erdc_parameter_id] [numeric](19, 0) NULL,
	[value] [text] NULL,
	[sampletime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[erdc_int_data_id],
	[sampletime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_string_data ([sampletime]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sampletime) from erdc_string_data)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_string_data(sampletime)) FROM erdc_string_data
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sampletime) FROM erdc_string_data AS o WHERE $partition.function_string_data(o.sampletime) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_string_data(o.sampletime)
exec upt_SwitchOutPartition 'sampletime', 'erdc_string_data', 'scheme_string_data', 'function_string_data', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO


/**************************
** RANGED_OBJECT_VALUE   **
**************************/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
CREATE TABLE [dbo].performance_data_old(
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[erdc_id] [numeric](19, 0) NULL,
	[uptimehost_id] [numeric](19, 0) NULL,
	[sample_time] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id],
	[sample_time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
) ON scheme_ranged_object_value ([sample_time]);


DECLARE @MIN_DATE datetime
SET @MIN_DATE = (SELECT MIN(sample_time) from ranged_object_value)
DECLARE @OLDEST_PARTITION_NUM int
SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_ranged_object_value(sample_time)) FROM ranged_object_value
/* Get the max datetime for the last partition. This is so that it works with tables where the last partition has more than one month of data */
DECLARE @MAX_DATE_IN_LAST_PARTITION datetime
SELECT @MAX_DATE_IN_LAST_PARTITION = max(o.sample_time) FROM ranged_object_value AS o WHERE $partition.function_ranged_object_value(o.sample_time) = @OLDEST_PARTITION_NUM GROUP BY $partition.function_ranged_object_value(o.sample_time)
exec upt_SwitchOutPartition 'sample_time', 'ranged_object_value', 'scheme_ranged_object_value', 'function_ranged_object_value', @MIN_DATE, @OLDEST_PARTITION_NUM, @MAX_DATE_IN_LAST_PARTITION
GO

