
proc run_coregen {mhsinst} {  
  set core_dir [file join [xget_hw_pcore_dir $mhsinst] ..]
  set adi_common_dir [file join $core_dir .. adi_common_v1_00_a]
  set adi_common_dir [file normalize $adi_common_dir]
  source [file join $adi_common_dir data generate_ngc_and_v.tcl]
  generate_ngc_and_v $core_dir "axi_fft_float4k_fftx_1"
  generate_ngc_and_v $core_dir "axi_fft_float64k_fftx_1"
  generate_ngc_and_v $core_dir "axi_fft_floatmulx_1"
  generate_ngc_and_v $core_dir "axi_fft_floatsqrtx_1"
  generate_ngc_and_v $core_dir "axi_fft_floataddx_1"
  generate_ngc_and_v $core_dir "axi_fft_float2fixx_1"
  generate_ngc_and_v $core_dir "axi_fft_fix2floatx_1"
}  
