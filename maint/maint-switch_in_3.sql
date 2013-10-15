EXECUTE upt_GetSwitchInOutput 'performance_aggregate', 'performance_aggregate_new', 'sample_date', 'scheme_aggregate', 'function_aggregate'
GO

EXECUTE upt_GetSwitchInOutput 'performance_cpu', 'performance_cpu_new', 'sample_date', 'scheme_cpu', 'function_cpu'
GO

EXECUTE upt_GetSwitchInOutput 'performance_disk', 'performance_disk_new', 'sample_date', 'scheme_disk', 'function_disk'
GO

EXECUTE upt_GetSwitchInOutput 'performance_disk_total', 'performance_disk_total_new', 'sample_date', 'scheme_disk_total', 'function_disk_total'
GO

EXECUTE upt_GetSwitchInOutput 'performance_esx3_workload', 'performance_esx3_workload_new', 'sample_date', 'scheme_esx3_workload', 'function_esx3_workload'
GO

EXECUTE upt_GetSwitchInOutput 'performance_fscap', 'performance_fscap_new', 'sample_date', 'scheme_fscap', 'function_fscap'
GO

EXECUTE upt_GetSwitchInOutput 'performance_lpar_workload', 'performance_lpar_workload_new', 'sample_date', 'scheme_lpar_workload', 'function_lpar_workload'
GO

EXECUTE upt_GetSwitchInOutput 'performance_network', 'performance_network_new', 'sample_date', 'scheme_network', 'function_network'
GO

EXECUTE upt_GetSwitchInOutput 'performance_nrm', 'performance_nrm_new', 'sample_date', 'scheme_nrm', 'function_nrm'
GO

EXECUTE upt_GetSwitchInOutput 'performance_psinfo', 'performance_psinfo_new', 'sample_date', 'scheme_psinfo', 'function_psinfo'
GO

EXECUTE upt_GetSwitchInOutput 'performance_vxvol', 'performance_vxvol_new', 'sample_date', 'scheme_vxvol', 'function_vxvol'
GO

EXECUTE upt_GetSwitchInOutput 'performance_who', 'performance_who_new', 'sample_date', 'scheme_who', 'function_who'
GO

EXECUTE upt_GetSwitchInOutput 'performance_sample', 'performance_sample_new', 'sample_time', 'scheme_sample', 'function_sample'
GO

EXECUTE upt_GetSwitchInOutput 'erdc_int_data', 'erdc_int_data_new', 'sampletime', 'scheme_int_data', 'function_int_data'
GO

EXECUTE upt_GetSwitchInOutput 'ranged_object_value', 'ranged_object_value_new', 'sample_time', 'scheme_ranged_object_value', 'function_ranged_object_value'
GO
