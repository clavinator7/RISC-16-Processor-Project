module register_file(
    // Inputs
    input wire clk,
    input wire [1:0] MUX_tgt,
    input wire MUX_rf,
    input wire WE_rf,
    input wire [15:0] mem_out,
    input wire [15:0] alu_out,
    input wire [15:0] pc,
    input wire [2:0] rA,
    input wire [2:0] rB,
    input wire [2:0] rC,
    // Outputs
    output reg [15:0] reg_out1,
    output reg [15:0] reg_out2
);
    // Registers that will make up our register file
    reg [15:0] register_file [0:7];
    // What will actually be at the TGT input port after the mux
    wire [15:0] tgt_reg_data;
    wire [2:0] tgt_reg_num;
    wire [2:0] src1;
    wire [2:0] src2;
    // Number to keep track of iterations
    integer i;

    // TODO: Initialize registers without using rst_n input since it's not provided in the TB
    initial begin
        for(i = 0; )

    // TODO: Find out if you need to increment pc
    assign tgt_reg_data = (MUX_tgt == 2'b00) ? mem_out : ((MUX_tgt == 2'b01) ? alu_out : ((MUX_tgt == 2'b10) ? pc : 16'h0000));
    assign tgt_reg_num = rA;
    assign src1 = rB;
    assign src2 = (MUX_rf) ? rA : rC;
    
    always @(posedge clk) begin
        if(WE_rf) register_file[tgt_reg_num] <= tgt_reg_data;
        reg_out1 <= (src1 !== 0) ? register_file[src1] : 16'h0000;
        reg_out2 <= (src2 !== 0) ? register_file[src2] : 16'h0000;
    end

endmodule



