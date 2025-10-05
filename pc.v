module pc(
    input wire clk,
    input wire rst_n,
    input wire [1:0] MUX_output,
    input wire [6:0] imm,
    input wire [15:0] alu_out,
    output reg [15:0] nxt_instr
);

    // Duplicate the MSB 9 times, then concat with 7 bit immediate value
    wire [15:0] sign_extend_imm = {{9{imm[6]}}, imm[6:0]};

    always @(posedge clk or negedge rst_n) begin
        // Reset PC when reset signal is given
        if (!rst_n)
            nxt_instr <= 16'h0000;
        else begin
            case (MUX_output)
                // Increment PC as usual
                2'b00: nxt_instr <= nxt_instr + 16'h0001;
                // Increment PC then add imm value
                2'b01: nxt_instr <= nxt_instr + 16'h0001 + sign_extend_imm;
                // Jump to address indicated by out of ALU
                2'b10: nxt_instr <= alu_out;
                // Increment PC as usual
                default: nxt_instr <= nxt_instr + 16'h0001;
            endcase
        end
    end

endmodule
