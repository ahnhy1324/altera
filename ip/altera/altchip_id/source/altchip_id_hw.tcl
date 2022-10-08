# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/13.0sp1/ip/altchip_id/source/altchip_id_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 12.1

# Source files
source altchip_id_proc_hw.tcl

# +-----------------------------------
# | module Unique Chip ID
# +-----------------------------------
set_module_property NAME altchip_id
set_module_property VERSION 13.0
set_module_property DISPLAY_NAME "Altera Unique Chip ID"
set_module_property DESCRIPTION "The ALTCHIP_ID megafunction allows you to read the unique chip ID"
set_module_property GROUP "Configuration & Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
#set_module_property DATASHEET_URL "http://www.altera.com/literature/ug"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true

# +-----------------------------------
# | Parameters
# +-----------------------------------
add_display_item "" "General" GROUP tab
add_display_item "General" "Information" TEXT "Maximum frequency of clkin signal is 100MHz"

add_parameter device_family STRING
set_parameter_property device_family VISIBLE false
set_parameter_property device_family SYSTEM_INFO {DEVICE_FAMILY}

add_parameter DEVICE_TYPE INTEGER
set_parameter_property DEVICE_TYPE DEFAULT_VALUE 1
set_parameter_property DEVICE_TYPE ALLOWED_RANGES {1 2}
set_parameter_property DEVICE_TYPE VISIBLE false
set_parameter_property DEVICE_TYPE HDL_PARAMETER true
set_parameter_property DEVICE_TYPE DERIVED true

# +-----------------------------------
# | UI Interface
# +-----------------------------------
#clkin port
set CLKIN_INTERFACE "clkin"
add_interface $CLKIN_INTERFACE clock end
add_interface_port $CLKIN_INTERFACE $CLKIN_INTERFACE clk Input 1

#reset port
set RESET_INTERFACE "reset"
add_interface $RESET_INTERFACE reset end
set_interface_property $RESET_INTERFACE associatedClock clkin
add_interface_port $RESET_INTERFACE $RESET_INTERFACE reset Input 1

#output port - data_valid, chip_id
add_interface output avalon_streaming start
set_interface_property output associatedClock clkin
add_interface_port output "data_valid" valid Output 1
add_interface_port output "chip_id" data Output 64

set_module_property ELABORATION_CALLBACK elaboration_callback

# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
set_fileset_property quartus_synth TOP_LEVEL altchip_id
