vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr \
"../../../../fpga1.gen/sources_1/ip/KeyboardCtrl_0_2/src/Ps2Interface.v" \
"../../../../fpga1.gen/sources_1/ip/KeyboardCtrl_0_2/src/KeyboardCtrl.v" \
"../../../../fpga1.gen/sources_1/ip/KeyboardCtrl_0_2/sim/KeyboardCtrl_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

