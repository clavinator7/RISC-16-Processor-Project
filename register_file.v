module register_file(
    // Inputs
    input wire clk,         // System clock
    input wire [1:0] MUX_tgt, // Selects write data source
    input wire MUX_rf,     // Selects address for read port 2
    input wire WE_rf,      // Write Enable
    input wire [15:0] mem_out, // Data from memory
    input wire [15:0] alu_out, // Data from ALU
    input wire [15:0] pc,      // Program Counter
    input wire [2:0] rA,      // Register address A
    input wire [2:0] rB,      // Register address B
    input wire [2:0] rC,      // Register address C
    // Outputs
    output reg [15:0] reg_out1, // Data read port 1
    output reg [15:0] reg_out2  // Data read port 2
);
    // Registers that will make up our register file
    reg [15:0] register_file [0:7]; // 8 registers, 16-bit each

    wire [15:0] tgt_reg_data; // Data to be written
    wire [2:0] tgt_reg_num;   // Address for write
    wire [2:0] src1;          // Address for read port 1
    wire [2:0] src2;          // Address for read port 2

    // Number to keep track of iterations
    integer i;

    // Initialize all registers to zero
    initial for(i = 0; i < 8; i++) register_file[i] = 16'h0000;

    // Combinatorially selects data for writing
    assign tgt_reg_data = (MUX_tgt == 2'b00) ? mem_out : ((MUX_tgt == 2'b01) ? alu_out : ((MUX_tgt == 2'b10) ? pc+1 : 16'h0000));
    // Write address is always rA
    assign tgt_reg_num = rA; 
    // Read port 1 address is always rB
    assign src1 = rB; 
    // Selects read address for port 2 (rA or rC)
    assign src2 = (MUX_rf) ? rA : rC;

    always @(posedge clk) begin
        // Perform write operation if WE is high and not writing to R0
        if(WE_rf && tgt_reg_num !== 0) register_file[tgt_reg_num] <= tgt_reg_data;
        // Read data for port 1
        reg_out1 <= register_file[src1];
        // Read data for port 2
        reg_out2 <= register_file[src2];
    end

endmodule