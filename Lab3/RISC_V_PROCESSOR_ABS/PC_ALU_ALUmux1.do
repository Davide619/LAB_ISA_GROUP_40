onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_Risc_V_Lite/RP/Clk
add wave -noupdate /tb_Risc_V_Lite/RP/Rst
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/ProgramCounter_buff
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/ALU_cmp/In_Rs1
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/ALU_cmp/In_Rs2_Imm
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/ALU_cmp/Out_ALU_resul
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/WriteDataMux/Out_mux
add wave -noupdate -radix hexadecimal -childformat {{/tb_Risc_V_Lite/RP/RF/REG(0) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(1) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(2) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(3) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(4) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(5) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(6) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(7) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(8) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(9) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(10) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(11) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(12) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(13) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(14) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(15) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(16) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(17) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(18) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(19) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(20) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(21) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(22) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(23) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(24) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(25) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(26) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(27) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(28) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(29) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(30) -radix hexadecimal} {/tb_Risc_V_Lite/RP/RF/REG(31) -radix hexadecimal}} -subitemconfig {/tb_Risc_V_Lite/RP/RF/REG(0) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(1) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(2) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(3) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(4) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(5) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(6) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(7) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(8) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(9) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(10) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(11) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(12) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(13) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(14) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(15) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(16) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(17) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(18) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(19) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(20) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(21) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(22) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(23) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(24) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(25) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(26) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(27) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(28) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(29) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(30) {-height 15 -radix hexadecimal} /tb_Risc_V_Lite/RP/RF/REG(31) {-height 15 -radix hexadecimal}} /tb_Risc_V_Lite/RP/RF/REG
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/ALU1mux/IN0
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/ALU1mux/IN1
add wave -noupdate /tb_Risc_V_Lite/RP/ALU1mux/s
add wave -noupdate -radix hexadecimal /tb_Risc_V_Lite/RP/ALU1mux/M
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35950 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {18550 ps} {41130 ps}
