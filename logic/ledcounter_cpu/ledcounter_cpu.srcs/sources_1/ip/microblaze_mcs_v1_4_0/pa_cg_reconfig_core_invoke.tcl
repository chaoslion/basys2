# Tcl script generated by PlanAhead

set reloadAllCoreGenRepositories false

set tclUtilsPath "c:/Xilinx/14.7/ISE_DS/PlanAhead/scripts/pa_cg_utils.tcl"

set repoPaths ""

set cgIndexMapPath "D:/HARDSOFTALL/Projekte/basys2/led_counter/led_counter.srcs/sources_1/ip/cg_nt_index_map.xml"

set cgProjectPath "d:/HARDSOFTALL/Projekte/basys2/led_counter/led_counter.srcs/sources_1/ip/microblaze_mcs_v1_4_0/coregen.cgc"

set ipFile "d:/HARDSOFTALL/Projekte/basys2/led_counter/led_counter.srcs/sources_1/ip/microblaze_mcs_v1_4_0/microblaze_mcs_v1_4_0.xco"

set ipName "microblaze_mcs_v1_4_0"

set chains "CUSTOMIZE_CURRENT_CHAIN INSTANTIATION_TEMPLATES_CHAIN"

set bomFilePath "d:/HARDSOFTALL/Projekte/basys2/led_counter/led_counter.srcs/sources_1/ip/microblaze_mcs_v1_4_0/pa_cg_bom.xml"

set cgPartSpec "xc3s100e-5cp132"

set hdlType "VHDL"

# generate the IP
set result [source "c:/Xilinx/14.7/ISE_DS/PlanAhead/scripts/pa_cg_reconfig_core.tcl"]

exit $result

