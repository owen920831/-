vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../fpga1.gen/sources_1/ip/KeyboardCtrl_0_2/src/Ps2Interface.v" \
"../../../../fpga1.gen/sources_1/ip/KeyboardCtrl_0_2/src/KeyboardCtrl.v" \
"../../../../fpga1.gen/sources_1/ip/KeyboardCtrl_0_2/sim/KeyboardCtrl_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

