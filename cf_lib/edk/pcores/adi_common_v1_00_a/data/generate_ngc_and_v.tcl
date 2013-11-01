proc generate_ngc_and_v {basedir target} {
  set ngcfile "$target.ngc"
  set verilogfile "$target.v"
  set xcofile "$target.xco"

  puts "Generating $ngcfile and $verilogfile"

  set netlist [file join $basedir netlist]
  set verilog [file join $basedir hdl verilog]

  if { [file exists [file join $netlist $ngcfile]] != 1 } {
    set current_dir [pwd]
    set tmp [file join $basedir tmp]
    file mkdir $tmp
    cd $tmp
    set result [catch {exec coregen -b [file join $netlist $xcofile] -intstyle xflow}]
    cd $current_dir
 
    file copy -force [file join $tmp $ngcfile] [file join $netlist $ngcfile]
    file copy -force [file join $tmp $verilogfile] [file join $verilog $verilogfile]

    file delete -force $tmp
  }
}
