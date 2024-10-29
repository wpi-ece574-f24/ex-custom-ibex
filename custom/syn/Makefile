# include ../../build/custom_ibex_0/sim-verilator/core-deps.mk

# svfiles := $(filter %.sv, $(fusesoc-deps))

# all:
# 	@echo $(svfiles)

syn:
	BASENAME=custom_ibex \
	CLOCKPERIOD=50 \
	TIMINGPATH=/opt/cadence/libraries/gsclib045_all_v4.7/gsclib045/timing/ \
	TIMINGLIB=slow_vdd1v0_basicCells.lib \
	genus -f genus_script.tcl

clean:
	rm -rf outputs reports genus.log* genus.cmd* *~ fv
