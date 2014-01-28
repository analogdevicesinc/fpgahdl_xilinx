

create_project motor_control_zed . -part xc7z020clg484-1 -force
set_property board em.avnet.com:zynq:zed:c [current_project]
set_property ip_repo_paths ../../../library [current_fileset]
update_ip_catalog

create_bd_design "system"
source system_bd.tcl

generate_target {synthesis implementation} \
  [get_files  ./motor_control_zed.srcs/sources_1/bd/system/system.bd]

make_wrapper -files [get_files ./motor_control_zed.srcs/sources_1/bd/system/system.bd] -top
import_files -force -norecurse -fileset sources_1 ./motor_control_zed.srcs/sources_1/bd/system/hdl/system_wrapper.v
import_files -force -norecurse -fileset constrs_1 mc_constr.xdc
import_files -force -norecurse -fileset sources_1 system_top.v
import_files -force -norecurse -fileset constrs_1 ../../base_system/zed/system_constr.xdc

set_property top system_top [current_fileset]

launch_runs synth_1
wait_on_run synth_1
open_run synth_1
report_timing_summary -file report_timing_summary_synth_1.log

launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1
report_timing_summary -file report_timing_summary_impl_1.log

export_hardware [get_files ./motor_control_zed.srcs/sources_1/bd/system/system.bd] \
  [get_runs impl_1] -bitstream


