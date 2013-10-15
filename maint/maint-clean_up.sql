PRINT 'Dropping temp tables'
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'performance_data_old' AND type = 'U') DROP TABLE performance_data_old;
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

PRINT 'Dropping functions'
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetHighestPartition' AND type = 'FN') DROP FUNCTION upt_GetHighestPartition
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetFirstDayOfCurrentMonth' AND type = 'FN') DROP FUNCTION upt_GetFirstDayOfCurrentMonth
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionForTable' AND type = 'FN') DROP FUNCTION upt_GetPartitionForTable
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetPartitionFor_aggregate' AND type = 'FN') DROP FUNCTION upt_GetPartitionFor_aggregate
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

PRINT 'Dropping procedures'
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_SwitchOutPartition' AND type = 'P') DROP PROCEDURE upt_SwitchOutPartition;
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetLeadingPartitionDate' AND type = 'P') DROP PROCEDURE upt_GetLeadingPartitionDate
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'upt_GetSwitchInOutput' AND type = 'P') DROP PROCEDURE upt_GetSwitchInOutput
GO

PRINT 'Done cleaning up'
