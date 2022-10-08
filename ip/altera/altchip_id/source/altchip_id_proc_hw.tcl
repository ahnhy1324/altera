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
# | $Header: //acds/rel/13.0sp1/ip/altchip_id/source/altchip_id_proc_hw.tcl#1 $
# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------
proc elaboration_callback {} {
	
	update_device_type_params elaboration
	
}

# +----------------------------------------------
# | Function to update the device_type parameter
# | 	1 - Stratix V
# |		2 - Arria V, Cyclone V
# +----------------------------------------------
proc update_device_type_params {flag} {

	set get_device_family [get_parameter_value device_family]
	set is_SV [expr {$get_device_family == "Stratix V"}]
	
	if {!($get_device_family == "Stratix V" || $get_device_family == "Arria V" || $get_device_family == "Cyclone V")} {
		send_message error "ALTCHIP_ID only supports 28nm device family."
	}
	
	if {$is_SV} {
		set_parameter_value DEVICE_TYPE 1
	} else {
		set_parameter_value DEVICE_TYPE 2
	}
}
	
# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {

	send_message info "generating top-level entity $entityname"
	add_fileset_file "altchip_id.v" VERILOG PATH "altchip_id.v"

}