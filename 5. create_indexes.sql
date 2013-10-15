BEGIN TRANSACTION

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'LATEST_PERF_SAMPLE')
   DROP INDEX LATEST_PERF_SAMPLE ON performance_sample
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'LATEST_SAMPLE_BY_HOST')
   DROP INDEX LATEST_SAMPLE_BY_HOST ON  performance_sample
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'CPU_SAMPLE_ID')
   DROP INDEX CPU_SAMPLE_ID ON  performance_cpu
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'DISK_SAMPLE_ID')
   DROP INDEX DISK_SAMPLE_ID ON  performance_disk
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'DISK_TOTAL_SAMPLE_ID')
   DROP INDEX DISK_TOTAL_SAMPLE_ID ON  performance_disk_total
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'ESX3_WORKLOAD_SAMPLE_ID')
   DROP INDEX ESX3_WORKLOAD_SAMPLE_ID ON  performance_esx3_workload
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'FSCAP_SAMPLE_ID')
   DROP INDEX FSCAP_SAMPLE_ID ON  performance_fscap
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'LPAR_WORKLOAD_SAMPLE_ID')
   DROP INDEX LPAR_WORKLOAD_SAMPLE_ID ON  performance_lpar_workload
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'NETWORK_SAMPLE_ID')
   DROP INDEX NETWORK_SAMPLE_ID ON  performance_network
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'PSINFO_SAMPLE_ID')
   DROP INDEX PSINFO_SAMPLE_ID ON  performance_psinfo
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'VXVOL_SAMPLE_ID')
   DROP INDEX VXVOL_SAMPLE_ID ON  performance_vxvol
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'WHO_SAMPLE_ID')
   DROP INDEX WHO_SAMPLE_ID ON  performance_who
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'IDX_SVC_METRICS_INT')
   DROP INDEX IDX_SVC_METRICS_INT ON  erdc_int_data
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'IDX_SVC_METRICS_DEC')
   DROP INDEX IDX_SVC_METRICS_DEC ON  erdc_decimal_data
GO

IF EXISTS (SELECT name FROM sysindexes
   WHERE name like 'IDX_SVC_METRICS_STR')
   DROP INDEX IDX_SVC_METRICS_STR ON  erdc_string_data
GO




CREATE INDEX LATEST_PERF_SAMPLE ON performance_sample
(
erdc_id,
sample_time
)

CREATE INDEX LATEST_SAMPLE_BY_HOST ON performance_sample
(
uptimehost_id,
sample_time
)


CREATE INDEX CPU_SAMPLE_ID ON performance_cpu
(
sample_id
)

CREATE INDEX DISK_SAMPLE_ID ON performance_disk
(
sample_id
)

CREATE INDEX DISK_TOTAL_SAMPLE_ID ON performance_disk_total
(
sample_id
)

CREATE INDEX ESX3_WORKLOAD_SAMPLE_ID ON performance_esx3_workload
(
sample_id
)

CREATE INDEX FSCAP_SAMPLE_ID ON performance_fscap
(
sample_id
)

CREATE INDEX LPAR_WORKLOAD_SAMPLE_ID ON performance_lpar_workload
(
sample_id
)

CREATE INDEX NETWORK_SAMPLE_ID ON performance_network
(
sample_id
)

CREATE INDEX PSINFO_SAMPLE_ID ON performance_psinfo
(
sample_id
)

CREATE INDEX VXVOL_SAMPLE_ID ON performance_vxvol
(
sample_id
)

CREATE INDEX WHO_SAMPLE_ID ON performance_who
(
sample_id
)

CREATE INDEX IDX_SVC_METRICS_INT ON erdc_int_data
(
erdc_parameter_id,
erdc_instance_id,
sampletime
)

CREATE INDEX IDX_SVC_METRICS_DEC ON erdc_decimal_data
(
erdc_parameter_id,
erdc_instance_id,
sampletime
)

CREATE INDEX IDX_SVC_METRICS_STR ON erdc_string_data
(
erdc_parameter_id,
erdc_instance_id,
sampletime
)

COMMIT TRANSACTION
