PRINT 'Dropping functions and schemes'
IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_sample')
   DROP PARTITION SCHEME scheme_sample
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_sample')
   DROP PARTITION FUNCTION function_sample
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_aggregate')
   DROP PARTITION SCHEME scheme_aggregate
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_aggregate')
   DROP PARTITION FUNCTION function_aggregate
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_cpu')
   DROP PARTITION SCHEME scheme_cpu
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_cpu')
   DROP PARTITION FUNCTION function_cpu
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_disk')
   DROP PARTITION SCHEME scheme_disk
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_disk')
   DROP PARTITION FUNCTION function_disk
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_esx3_workload')
   DROP PARTITION SCHEME scheme_esx3_workload
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_esx3_workload')
   DROP PARTITION FUNCTION function_esx3_workload
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_fscap')
   DROP PARTITION SCHEME scheme_fscap
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_fscap')
   DROP PARTITION FUNCTION function_fscap
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_lpar_workload')
   DROP PARTITION SCHEME scheme_lpar_workload
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_lpar_workload')
   DROP PARTITION FUNCTION function_lpar_workload
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_network')
   DROP PARTITION SCHEME scheme_network
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_network')
   DROP PARTITION FUNCTION function_network
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_nrm')
   DROP PARTITION SCHEME scheme_nrm
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_nrm')
   DROP PARTITION FUNCTION function_nrm
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_psinfo')
   DROP PARTITION SCHEME scheme_psinfo
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_psinfo')
   DROP PARTITION FUNCTION function_psinfo
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_vxvol')
   DROP PARTITION SCHEME scheme_vxvol
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_vxvol')
   DROP PARTITION FUNCTION function_vxvol
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_who')
   DROP PARTITION SCHEME scheme_who
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_who')
   DROP PARTITION FUNCTION function_who
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_int_data')
   DROP PARTITION SCHEME scheme_int_data
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_int_data')
   DROP PARTITION FUNCTION function_int_data
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_decimal_data')
   DROP PARTITION SCHEME scheme_decimal_data
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_decimal_data')
   DROP PARTITION FUNCTION function_decimal_data
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_string_data')
   DROP PARTITION SCHEME scheme_string_data
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_string_data')
   DROP PARTITION FUNCTION function_string_data
GO


IF EXISTS (SELECT name FROM sys.PARTITION_SCHEMES WHERE name = 'scheme_ranged_object_value')
   DROP PARTITION SCHEME scheme_ranged_object_value
GO
IF EXISTS (SELECT name FROM SYS.PARTITION_FUNCTIONS WHERE name = 'function_ranged_object_value')
   DROP PARTITION FUNCTION function_ranged_object_value
GO


PRINT 'Dropping temporary tables'
IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_sample_new' AND type = 'U')
   DROP TABLE performance_sample_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_aggregate_new' AND type = 'U')
   DROP TABLE performance_aggregate_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_cpu_new' AND type = 'U')
   DROP TABLE performance_cpu_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_disk_new' AND type = 'U')
   DROP TABLE performance_disk_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_disk_total_new' AND type = 'U')
   DROP TABLE performance_disk_total_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_esx3_workload_new' AND type = 'U')
   DROP TABLE performance_esx3_workload_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_fscap_new' AND type = 'U')
   DROP TABLE performance_fscap_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_lpar_workload_new' AND type = 'U')
   DROP TABLE performance_lpar_workload_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_network_new' AND type = 'U')
   DROP TABLE performance_network_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_nrm_new' AND type = 'U')
   DROP TABLE performance_nrm_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_psinfo_new' AND type = 'U')
   DROP TABLE performance_psinfo_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_vxvol_new' AND type = 'U')
   DROP TABLE performance_vxvol_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'performance_who_new' AND type = 'U')
   DROP TABLE performance_who_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'erdc_int_data_new' AND type = 'U')
   DROP TABLE erdc_int_data_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'erdc_decimal_data_new' AND type = 'U')
   DROP TABLE erdc_decimal_data_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'erdc_string_data_new' AND type = 'U')
   DROP TABLE erdc_string_data_new
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'ranged_object_value_new' AND type = 'U')
   DROP TABLE ranged_object_value_new
GO




PRINT 'Dropping triggers'
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
      WHERE name = 'trig_insert_disk_total' AND type = 'TR')
   DROP TRIGGER trig_insert_disk_total
GO

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'trig_insert_esx3_workload' AND type = 'TR')
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

PRINT 'Done cleaning up'
