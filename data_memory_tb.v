`timescale 1ns / 1ps

module data_memory_tb;

    // Inputs
    reg clk;
    reg WE_dmem;
    reg [15:0] reg_out, alu_out;

    // Outputs
    wire [15:0] mem_out;

    // Instantiate UUT
    data_memory uut (
        .clk(clk),
        .WE_dmem(WE_dmem),
        .reg_out(reg_out),
        .alu_out(alu_out),
        .mem_out(mem_out)
    )

    // Clock Generator
    initial begin
        clk = 0;
    end
    always begin 
        #5 clk = ~clk;
    end

    task check_and_print_regs;
        
    endtask




endmodule