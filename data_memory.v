

module data_memory (
    input wire clk,
    input wire WE_dmem,
    input wire [15:0] reg_out,
    input wire [15:0] alu_out,
    output wire [15:0] mem_out
);

    // Internal storage for the 65535 memory locations
    reg [15:0] memory [0:65535];

        // --- INITIALIZATION ---
    integer i;
    initial begin
        for (i = 0; i <= 65535; i = i + 1) begin
            memory[i] = 16'h0000;
        end
    end

    //Leave a line to import a premade memory file in the future



    // Asynchronous read logic
    assign mem_out = memory[alu_out]; // For LW, but active all the time since it's the only possible value for mem_out

    // Synchronous write logic
    always @(posedge clk) begin
        if (WE_dmem) begin // SW
            memory[alu_out] <= reg_out;
        end

    end

endmodule 