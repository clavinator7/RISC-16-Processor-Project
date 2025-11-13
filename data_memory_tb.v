`timescale 1ns / 1ps

module data_memory_tb;

    // Signals
    reg clk;
    reg WE_dmem;
    reg [15:0] reg_out;
    reg [15:0] alu_out;
    wire [15:0] mem_out;

    // Instantiate DUT
    data_memory dut (
        .clk(clk),
        .WE_dmem(WE_dmem),
        .reg_out(reg_out),
        .alu_out(alu_out),
        .mem_out(mem_out)
    );

    // Parameters
    parameter MEM_SIZE  = 65536; // 16-bit address space
    parameter MAX_FAILS = 1024;  // maximum failures to log

    // Failure Log
    reg [15:0] fail_addr [0:MAX_FAILS-1];
    reg [15:0] fail_expected [0:MAX_FAILS-1];
    reg [15:0] fail_got [0:MAX_FAILS-1];
    integer fail_counter;

    // Clock generation
    initial begin
        clk = 0;
        fail_counter = 0;
        forever #5 clk = ~clk; // 10 ns period
    end

    // Generate a deterministic value from address
    function [15:0] generate_value;
        input [15:0] addr;
        begin
            generate_value = addr & 16'h6976;
        end
    endfunction

    // Check a single memory address
    task check_read_single_addr;
        input [15:0] addr;
        input [15:0] expected;
        begin
            alu_out = addr;
            #1; // small delay to allow mem_out to stabilize
            if ((mem_out !== expected) && (fail_counter < MAX_FAILS)) begin
                fail_counter = fail_counter + 1;
                fail_addr[fail_counter] = addr;
                fail_expected[fail_counter] = expected;
                fail_got[fail_counter] = mem_out;
            end
        end
    endtask

    // Write to a single memory address
    task write_single_addr;
        input [15:0] target_addr;
        input [15:0] input_data;
        begin
            @(posedge clk);
            alu_out = target_addr;
            reg_out = input_data;
            WE_dmem = 1;
            @(posedge clk);
            WE_dmem = 0;
        end
    endtask

    // Full memory test
    task test_full_memory;
        integer i;
        begin
            $display("Starting full test of %0d memory addresses...", MEM_SIZE);

            $display("Sequential read-write test:");
            $display("This tests read/write sequentially.");
            for (i = 0; i < MEM_SIZE; i = i + 1) begin
                write_single_addr(i, generate_value(i));
                #1;
                check_read_single_addr(i, generate_value(i));
            end

            $display("Batch read-write test:");
            $display("This tests memory integrity after writing all addresses first.");
            for (i = 0; i < MEM_SIZE; i = i + 1) write_single_addr(i, generate_value(i));
            for (i = 0; i < MEM_SIZE; i = i + 1) check_read_single_addr(i, generate_value(i));
        end
    endtask

    // Print summary of failures
    task print_summary;
        integer i;
        begin
            $display("All tests completed.");
            if (fail_counter == 0) begin
                $display("No failures, all tests passed!");
            end else begin
                $display("Number of failed tests: %0d", fail_counter);
                for (i = 0; i < fail_counter; i = i + 1) begin
                    $display("Failure #%0d: Address=%0h, Expected=%0h, Got=%0h", 
                             i, fail_addr[i], fail_expected[i], fail_got[i]);
                end
            end
        end
    endtask

    // Run the testbench
    initial begin
        WE_dmem = 0;
        reg_out = 0;
        alu_out = 0;
        #10;
        test_full_memory();
        print_summary();
        $finish;
    end

endmodule
