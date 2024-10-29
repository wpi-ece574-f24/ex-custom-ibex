# set_db init_lib_search_path  /opt/cadence/libraries/gsclib045_all_v4.7/gsclib045/timing/
# read_libs slow_vdd1v0_basicCells.lib

# set_db init_lib_search_path  /opt/skywater/libraries/sky130_fd_sc_hd/latest/timing
# read_libs sky130_fd_sc_hd__ss_100C_1v60.lib

if {![info exists ::env(TIMINGPATH)] } {
    puts "Error: missing TIMINGPATH"
    exit(0)
}

if {![info exists ::env(TIMINGLIB)] } {
    puts "Error: missing TIMINGLIB"
    exit(0)
}

set_db init_lib_search_path [getenv TIMINGPATH]
read_libs [getenv TIMINGLIB]

set_db init_hdl_search_path {../../vendor/lowrisc_ip/ip/prim/rtl ../../build/custom_ibex_0/src/lowrisc_dv_dv_fcov_macros_0}

# read_hdl -language sv ../../custom/dv/verilator/top_verilator.sv 
# read_hdl -language sv ../../vendor/lowrisc_ip/dv/dpi/uartdpi/uartdpi.sv 
# read_hdl -language sv ../../vendor/lowrisc_ibex/shared/rtl/sim/simulator_ctrl.sv 

# read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_1p.sv 
# read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_adv.sv 
# read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_ram_2p.sv 
# read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_register_file_fpga.sv 
# read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_register_file_latch.sv 

read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_flop_macros.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_assert.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_onehot_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_onehot_mux.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_onehot_check.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_scr.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_subst_perm.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_present.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_prince.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_cipher_pkg.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_lfsr.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_22_16_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_22_16_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_28_22_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_28_22_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_39_32_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_39_32_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_64_57_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_64_57_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_72_64_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_72_64_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_22_16_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_22_16_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_39_32_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_39_32_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_72_64_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_72_64_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_76_68_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_hamming_76_68_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_22_16_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_22_16_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_28_22_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_28_22_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_39_32_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_39_32_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_64_57_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_64_57_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_72_64_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_72_64_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_22_16_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_22_16_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_39_32_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_39_32_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_72_64_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_72_64_enc.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_76_68_dec.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_secded_inv_hamming_76_68_enc.sv 

read_hdl -language sv ../../vendor/lowrisc_ibex/shared/rtl/ram_1p.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/shared/rtl/ram_2p.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/shared/rtl/bus.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/shared/rtl/timer.sv 

read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_ram_2p_pkg.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_ram_2p-impl_0/prim_ram_2p.sv 

read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_prim_pkg-impl_0.1/prim_pkg.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_ram_1p-impl_0/prim_ram_1p.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/dv/uvm/icache/dv/prim_badbit/prim_badbit_ram_1p.sv 
read_hdl -language sv ../../rtl/system/jtag_id_pkg.sv 
read_hdl -language sv ../../custom/rtl/custom_ibex.sv 
read_hdl -language sv ../../rtl/system/dm_top.sv 
read_hdl -language sv ../../rtl/system/debounce.sv 
read_hdl -language sv ../../rtl/system/gpio.sv 
read_hdl -language sv ../../rtl/system/pwm.sv 
read_hdl -language sv ../../rtl/system/pwm_wrapper.sv 
read_hdl -language sv ../../rtl/system/uart.sv 
read_hdl -language sv ../../rtl/system/spi_host.sv 
read_hdl -language sv ../../rtl/system/spi_top.sv 
read_hdl -language sv ../../custom/rtl/myreg.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/debug_rom/debug_rom.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/debug_rom/debug_rom_one_scratch.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/src/dm_pkg.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/src/dm_sba.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/src/dm_csrs.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/src/dm_mem.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/src/dmi_cdc.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/src/dmi_jtag.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_sync_reqack.sv 
read_hdl -language sv ../../vendor/pulp_riscv_dbg/src/dmi_jtag_tap.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_clock_inv-impl_0/prim_clock_inv.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_inv.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_clock_mux2-impl_0/prim_clock_mux2.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_clock_mux2.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_mux2.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_async_sram_adapter.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_async_simple.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_async.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_fifo_sync_cnt.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_flop_2sync.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_cdc_rand_delay.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_flop-impl_0/prim_flop.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_flop.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_flop.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim/rtl/prim_util_pkg.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_register_file_ff.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_lockstep.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_top.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_buf-impl_0/prim_buf.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_buf.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_buf.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_and2-impl_0/prim_and2.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_and2.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_and2.sv 

read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_pkg.sv
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_alu.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_branch_predict.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_compressed_decoder.sv 

read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_controller.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_cs_registers.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_csr.sv ../../vendor/lowrisc_ibex/rtl/ibex_counter.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_decoder.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_ex_block.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_fetch_fifo.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_id_stage.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_if_stage.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_load_store_unit.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_multdiv_fast.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_multdiv_slow.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_prefetch_buffer.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_pmp.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_wb_stage.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_dummy_instr.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_core.sv 
read_hdl -language sv ../../vendor/lowrisc_ibex/rtl/ibex_icache.sv 
read_hdl -language sv ../../build/custom_ibex_0/sim-verilator/generated/lowrisc_prim_clock_gating-impl_0/prim_clock_gating.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_generic/rtl/prim_generic_clock_gating.sv 
read_hdl -language sv ../../vendor/lowrisc_ip/ip/prim_xilinx/rtl/prim_xilinx_clock_gating.sv 

if {![info exists ::env(BASENAME)] } {
  set basename "default"
} else {
    set basename [getenv BASENAME]
}

set_top_module custom_ibex

elaborate
read_sdc constraints_top.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
syn_map
syn_opt

#reports
report_timing > reports/${basename}_report_timing.rpt
report_power  > reports/${basename}_report_power.rpt
report_area   > reports/${basename}_report_area.rpt
report_qor    > reports/${basename}_report_qor.rpt

set outputnetlist     outputs/${basename}_netlist.v
set outputconstraints outputs/${basename}_constraints.sdc
set outputdelays      outputs/${basename}_delays.sdf

write_hdl > $outputnetlist
write_sdc > $outputconstraints
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge  -setuphold split > $outputdelays

exit

