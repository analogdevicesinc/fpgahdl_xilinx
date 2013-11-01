
proc run_coregen {mhsinst} {  
  set core_dir [file join [xget_hw_pcore_dir $mhsinst] ..]
  set adi_common_dir [file join $core_dir .. adi_common_v1_00_a]
  set adi_common_dir [file normalize $adi_common_dir]
  source [file join $adi_common_dir data generate_ngc_and_v.tcl]
  generate_ngc_and_v $adi_common_dir "ad_dds_1"
}  
