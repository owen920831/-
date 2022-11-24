vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../keyt.gen/sources_1/ip/KeyboardCtrl_0_1/src/Ps2Interface.v" \
"../../../../keyt.gen/sources_1/ip/KeyboardCtrl_0_1/src/KeyboardCtrl.v" \
"../../../../keyt.gen/sources_1/ip/KeyboardCtrl_0_1/sim/KeyboardCtrl_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

