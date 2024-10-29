if {![info exists ::env(CLOCKPERIOD)] } {
  set clockPeriod 20
} else {
    set clockPeriod [getenv CLOCKPERIOD]
}

set inputDelayMargin  1
set outputDelayMargin 1

set halfClockPeriod  [list 0 [expr $clockPeriod / 2]]
set riseFallTime     [expr $clockPeriod / 10]
set clockUncertainty [expr $clockPeriod / 100]

create_clock -name clk -period $clockPeriod -waveform $halfClockPeriod [get_ports "clk"]
set_clock_transition -rise $riseFallTime [get_clocks "clk"]
set_clock_transition -fall $riseFallTime [get_clocks "clk"]
set_clock_uncertainty $clockUncertainty  [get_ports "clk"]
set_input_delay  -max $inputDelayMargin  [get_ports "reset"]  -clock [get_clocks "clk"]
set_input_delay  -max $inputDelayMargin  [get_ports "a"]      -clock [get_clocks "clk"]
set_input_delay  -max $inputDelayMargin  [get_ports "b"]      -clock [get_clocks "clk"]
set_input_delay  -max $inputDelayMargin  [get_ports "start"]  -clock [get_clocks "clk"]
set_output_delay -max $outputDelayMargin [get_ports "done"]   -clock [get_clocks "clk"]
set_output_delay -max $outputDelayMargin [get_ports "result"] -clock [get_clocks "clk"]
