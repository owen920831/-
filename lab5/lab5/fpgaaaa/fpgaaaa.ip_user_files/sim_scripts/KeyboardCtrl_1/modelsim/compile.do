vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr \
"../../../../fpgaaaa.gen/sources_1/ip/KeyboardCtrl_1/src/Ps2Interface.v" \
"../../../../fpgaaaa.gen/sources_1/ip/KeyboardCtrl_1/src/KeyboardCtrl.v" \
"../../../../fpgaaaa.gen/sources_1/ip/KeyboardCtrl_1/sim/KeyboardCtrl_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

