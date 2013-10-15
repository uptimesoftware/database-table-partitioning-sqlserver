USE uptime
GO

DECLARE @MONTHS_TO_KEEP int;
SET @MONTHS_TO_KEEP = 8

DECLARE @MERGE_DATE date;

IF (SELECT DATENAME(d, (SELECT MIN(sample_date) from performance_aggregate))) > 1
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
							(select MIN(sample_date) from performance_aggregate)
							-1
						)
						*-1, 
						(select MIN(sample_date) from performance_aggregate)
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
					(select MIN(sample_date) from performance_aggregate)
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
IF (
SELECT MIN(sample_date) from performance_aggregate
) < (
SELECT ( CAST( FLOOR( CAST(  DATEADD(month, (@MONTHS_TO_KEEP * -1), GETDATE()) AS FLOAT ) ) AS DATETIME ) )
)
BEGIN
	/* make sure that we aren't trying to drop multiple partitions (only one at a time!) */
	IF (
	SELECT MIN(sample_date) from performance_aggregate
	) < (
	SELECT ( CAST( FLOOR( CAST(  DATEADD(month, ((@MONTHS_TO_KEEP + 1) * -1), GETDATE()) AS FLOAT ) ) AS DATETIME ) )
	)
	BEGIN
		PRINT 'Warning: Attempting to archive more than one partition!';
	END
	ELSE BEGIN
		PRINT 'Only one month is being partitioned (good).';
		
		PRINT 'Merge Date: ';
		PRINT @MERGE_DATE;
		BEGIN TRANSACTION
			IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_aggregate_old' AND type = 'U') DROP TABLE performance_aggregate_old;
			CREATE TABLE [dbo].[performance_aggregate_old](
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

			ALTER PARTITION SCHEME [scheme_aggregate] NEXT USED [PRIMARY];

			DECLARE @OLDEST_PARTITION_NUM int;
			SELECT @OLDEST_PARTITION_NUM = min($PARTITION.function_aggregate(sample_date)) FROM performance_aggregate
			print 'Oldest Partition Number:'
			print @OLDEST_PARTITION_NUM
			ALTER TABLE performance_aggregate SWITCH PARTITION @OLDEST_PARTITION_NUM TO [performance_aggregate_old]PARTITION @OLDEST_PARTITION_NUM
			ALTER PARTITION FUNCTION [function_aggregate]() MERGE RANGE (@MERGE_DATE)
			IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_aggregate_old' AND type = 'U') DROP TABLE performance_aggregate_old;
			PRINT 'DONE!';
		COMMIT TRANSACTION

	END
END
ELSE BEGIN
	PRINT 'No data to archive.'
END
GO
