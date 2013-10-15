IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetHighestPartition' AND type = 'FN') DROP FUNCTION upt_GetHighestPartition
GO
CREATE FUNCTION dbo.upt_GetHighestPartition  (
@TABLE_NAME varchar(50)
)
RETURNS int
AS
BEGIN
	DECLARE @RV int;
	SELECT @RV = max(partition_number) FROM sys.partitions
		WHERE OBJECT_ID = OBJECT_ID(@TABLE_NAME);
	RETURN @RV;
END
GO




IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetFirstDayOfCurrentMonth' AND type = 'FN') DROP FUNCTION upt_GetFirstDayOfCurrentMonth
GO
CREATE FUNCTION dbo.upt_GetFirstDayOfCurrentMonth ()
RETURNS datetime
AS
BEGIN
	DECLARE @RV datetime;
	/* Calculate the 1st day of the current month and let's start with that... */
	IF (SELECT DATENAME(DAY, (GETDATE()))) > 1
	BEGIN
		/* Not the first day of the month */
		SELECT @RV = ( CAST ( FLOOR ( CAST ( DATEADD ( day, DATENAME ( d, ( GETDATE() ) -1 ) *-1, ( GETDATE() ) ) AS FLOAT ) ) AS DATETIME ) )
	END
	ELSE BEGIN
		/* The first day of the month (less math is necessary) */
		SELECT @RV = ( CAST ( FLOOR ( CAST ( GETDATE() AS FLOAT ) ) AS DATETIME ) )
	END
	RETURN @RV;
END
GO




IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionForTable' AND type = 'FN') DROP FUNCTION upt_GetPartitionForTable
GO
CREATE FUNCTION dbo.upt_GetPartitionForTable (
@TABLE_NAME varchar(50),
@CHECK_DATE datetime
)
RETURNS int
AS
BEGIN
	DECLARE @RV int;
	/* check table names and run appropriate function to get partition number for datetime */
	IF (@TABLE_NAME = 'performance_aggregate')
		SET @RV = dbo.upt_GetPartitionFor_aggregate(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_cpu')
		SET @RV = dbo.upt_GetPartitionFor_cpu(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_disk')
		SET @RV = dbo.upt_GetPartitionFor_disk(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_disk_total')
		SET @RV = dbo.upt_GetPartitionFor_disk_total(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_esx3_workload')
		SET @RV = dbo.upt_GetPartitionFor_esx3_workload(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_fscap')
		SET @RV = dbo.upt_GetPartitionFor_fscap(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_lpar_workload')
		SET @RV = dbo.upt_GetPartitionFor_lpar_workload(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_network')
		SET @RV = dbo.upt_GetPartitionFor_network(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_nrm')
		SET @RV = dbo.upt_GetPartitionFor_nrm(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_psinfo')
		SET @RV = dbo.upt_GetPartitionFor_psinfo(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_vxvol')
		SET @RV = dbo.upt_GetPartitionFor_vxvol(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_who')
		SET @RV = dbo.upt_GetPartitionFor_who(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'performance_sample')
		SET @RV = dbo.upt_GetPartitionFor_sample(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'erdc_int_data')
		SET @RV = dbo.upt_GetPartitionFor_int(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'erdc_decimal_data')
		SET @RV = dbo.upt_GetPartitionFor_decimal(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'erdc_string_data')
		SET @RV = dbo.upt_GetPartitionFor_string(@CHECK_DATE)
	ELSE IF (@TABLE_NAME = 'ranged_object_value')
		SET @RV = dbo.upt_GetPartitionFor_ranged(@CHECK_DATE)
	ELSE
		SET @RV = 0 /* should never get here */
	RETURN @RV;
END
GO


/* Have to have seperate functions for each performance table because we can't set variables within an EXECUTE statement, and we need an EXECUTE statement to use variable table names. */

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_aggregate' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_aggregate
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_cpu' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_cpu
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_disk' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_disk
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_disk_total' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_disk_total
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_esx3_workload' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_esx3_workload
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_fscap' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_fscap
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_lpar_workload' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_lpar_workload
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_network' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_network
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_nrm' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_nrm
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_psinfo' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_psinfo
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_vxvol' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_vxvol
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_who' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_who
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_sample' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_sample
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_int' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_int
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_decimal' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_decimal
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_string' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_string
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_ranged' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_ranged
GO


CREATE FUNCTION dbo.upt_GetPartitionFor_aggregate (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_aggregate(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_cpu (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_cpu(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_disk (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_disk(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_disk_total (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_disk_total(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_esx3_workload (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_esx3_workload(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_fscap (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_fscap(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_lpar_workload (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_lpar_workload(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_network (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_network(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_nrm (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_nrm(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_psinfo (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_psinfo(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_vxvol (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_vxvol(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_who (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_who(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_sample (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_sample(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_int (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_int_data(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_decimal (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_decimal_data(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_string (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_string_data(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO

CREATE FUNCTION dbo.upt_GetPartitionFor_ranged (@CHECK_DATE datetime)
RETURNS int
AS
BEGIN
	DECLARE @PART_NUM int;
	SELECT @PART_NUM = $PARTITION.function_ranged_object_value(@CHECK_DATE)
	RETURN @PART_NUM;
END
GO







IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetLeadingPartitionDate' AND type = 'P') DROP PROCEDURE upt_GetLeadingPartitionDate
GO
CREATE PROCEDURE upt_GetLeadingPartitionDate
	@TABLE_NAME varchar(50),
	@LAST_MONTH datetime OUTPUT
AS
BEGIN
	/*DECLARE @LAST_MONTH datetime;*/
	DECLARE @NEXT_MONTH datetime;
	DECLARE @LAST_PARTITION int;
	DECLARE @NEXT_PARTITION int;
	DECLARE @SQLString varchar(500);
	DECLARE @S2 nvarchar(500);

	SET @NEXT_PARTITION = 0

	/* Calculate the 1st day of the current month and let's start with that... */
	set @LAST_MONTH = dbo.upt_GetFirstDayOfCurrentMonth()

	/* Setup the current partition */
	SET @LAST_PARTITION = dbo.upt_GetPartitionForTable(@TABLE_NAME, @LAST_MONTH)
	
	/* check for invalid tables (return value from above function will be zero) */
	IF @LAST_PARTITION = 0
		PRINT 'Warning: Invalid table to archive'

	/* Now we'll compare and keep trying to see when next month's data will be put in to the same partition as the previous month, and then we'll have the leading partition datetime */
	WHILE ( @LAST_PARTITION <> @NEXT_PARTITION )
	BEGIN
		SET @LAST_PARTITION = @NEXT_PARTITION
		
		/* go to the next month */
		SELECT @NEXT_MONTH = DATEADD(MONTH, 1, @LAST_MONTH)
		
		/* get next month's partition number */
		SET @NEXT_PARTITION = dbo.upt_GetPartitionForTable(@TABLE_NAME, @NEXT_MONTH)
		
		/* check if the last and next partitions are the same, and if so... */
		IF ( @LAST_PARTITION = @NEXT_PARTITION )
		BEGIN
			/* ... break */
			BREAK
		END
		
		/* otherwise, just update the last partition/month */
		SET @LAST_MONTH = @NEXT_MONTH
	END
END
GO


IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetSwitchInOutput' AND type = 'P') DROP PROCEDURE upt_GetSwitchInOutput
GO
CREATE PROCEDURE upt_GetSwitchInOutput (
@TABLE_NAME varchar(50),
@NEW_TABLE_NAME varchar(50),
@COL_NAME varchar(50),
@SCHEME_NAME varchar(50),
@PARTITION_FUNCTION varchar(50)
)
AS
BEGIN

	DECLARE @LEADING_DATE datetime
	DECLARE @NEXT_DATE datetime
	EXECUTE upt_GetLeadingPartitionDate @TABLE_NAME, @LEADING_DATE OUTPUT
	SET @NEXT_DATE = DATEADD(MONTH, 1, @LEADING_DATE)


	PRINT 'ALTER TABLE ' + @NEW_TABLE_NAME + ' ADD CONSTRAINT constraint_month CHECK ( ' + @COL_NAME + ' >= ''' + CONVERT(varchar(20), @LEADING_DATE) + ''' and ' + @COL_NAME + ' < ''' + CONVERT(varchar(20), @NEXT_DATE) + ''' )'
	PRINT 'GO'

	PRINT 'BEGIN TRANSACTION'

	PRINT 'ALTER PARTITION SCHEME ' + @SCHEME_NAME + ' NEXT USED [PRIMARY]'
	DECLARE @HIGHEST_PARTITION int
	SET @HIGHEST_PARTITION = dbo.upt_GetHighestPartition(@TABLE_NAME)

	PRINT 'ALTER TABLE ' + @NEW_TABLE_NAME + ' SWITCH TO ' + @TABLE_NAME + ' PARTITION ' + CONVERT(varchar(10), @HIGHEST_PARTITION)
	PRINT 'ALTER PARTITION FUNCTION [' + @PARTITION_FUNCTION + ']() SPLIT RANGE(''' + CONVERT(varchar(20), @NEXT_DATE) + ''')'

	/* drop constraint */
	PRINT 'DROP TABLE ' + @NEW_TABLE_NAME

	PRINT 'COMMIT TRANSACTION'
	PRINT 'GO'
	PRINT ''

END
GO