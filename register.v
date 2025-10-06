module register(
    input clk,
    input rst_n,
    input WE_rf;
    input [15:0] MUX_rf,
    input [15:0] MUX_tgt,
    input [15:0] alu_out,
    input [15:0] mem_out,
    input [15:0] PC,
    input[15:0] instruction,
    output[15:0]reg_out1,
    output [15:0]reg_out2,
);
reg[15:0] regs [0:7];
wire rA = instruction





