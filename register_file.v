module register(
    input wire clk,
    input wire rst_n,
    input wire WE_rf;
    input wire [15:0] MUX_rf,
    input wire [15:0] MUX_tgt,
    input wire [15:0] alu_out,
    input wire [15:0] mem_out,
    input wire [15:0] pc,
    input wire [15:0] instruction,
    output reg [15:0] reg_out1,
    output reg [15:0] reg_out2,
);

    wire [15:0] regs [0:7];
    integer i;

    wire [2:0] rA, rB, rC;

    assign rA = instruction[12:10];
    assign rB = instruction[9:7];
    assign rC = instruction[2:0];
    assign regs[0] = 16'h0000;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i = 0; i < 8; i++) regs[i] = 16'h0000;
        end
    end

endmodule



