APP = myreg-test

all:
	@echo "Targets:"
	@echo "simprep          Build Verilator based system simulator"
	@echo "swprep           Compile software (Current application: $(APP))"
	@echo "runfst           Run Verilator and record waveformtrace"
	@echo "run              Run Verilator"
	@echo "syn              Prepare code for synthesis (to be done in ex-custom-obex-syn repo)"
	@echo "clean            Remove intermediate files"

build/custom_ibex_0/sim-verilator/Vtop_verilator:
	fusesoc --cores-root=. run --target=sim --tool=verilator --setup --build custom_ibex

simprep: build/custom_ibex_0/sim-verilator/Vtop_verilator

sw/c/build/demo/$(APP)/$(APP):
	mkdir -p sw/c/build
	cd sw/c/build; cmake ..; make

swprep: sw/c/build/demo/$(APP)/$(APP)

runfst: build/custom_ibex_0/sim-verilator/Vtop_verilator sw/c/build/demo/$(APP)/$(APP)
	build/custom_ibex_0/sim-verilator/Vtop_verilator -t sim.fst --meminit=ram,./sw/c/build/demo/$(APP)/$(APP)

run: build/custom_ibex_0/sim-verilator/Vtop_verilator sw/c/build/demo/$(APP)/$(APP)
	build/custom_ibex_0/sim-verilator/Vtop_verilator --meminit=ram,./sw/c/build/demo/$(APP)/$(APP)

syn:
	fusesoc --cores-root=. run --target=synth --tool=vivado --setup custom_ibex

clean:
	rm -rf build sw/c/build
