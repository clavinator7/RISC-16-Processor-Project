`timescale 1ns / 1ps

module risc16_processor_tb;

    // --- Testbench Signals ---
    reg clk;
    reg rst_n;

    // Instantiate the Unit Under Test (UUT)
    risc16_processor uut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // --- Clock Generation ---
    // Create a clock with a 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end

    // --- Test Sequence ---
    initial begin
        $dumpfile("cpu_waves.vcd"); // Create a waveform file
        $dumpvars(0, risc16_processor_tb); // Dump all variables in the testbench
        
        // 1. Apply Reset
        $display("Starting simulation...");
        rst_n = 0; // Assert active-low reset
        #20;       // Hold reset for 20ns (2 clock cycles)
        rst_n = 1; // De-assert reset
        
        // 2. Let the processor run for some time
        #200;      // Run for 200ns (20 clock cycles)
        
        // 3. Stop Simulation
        $display("Simulation finished.");
        $stop;
    end

    // --- Monitoring ---
    // This is how we "see" what the processor is doing.
    // We need to access wires *inside* the 'uut'.
    // This is allowed in a testbench.
    initial begin
        // Start monitoring immediately. 
        // It will automatically print whenever a signal changes.
        $monitor(
            "Time=%0t | PC=%h | Instr=%b | R0=%d R1=%d R2=%d R3=%d R4=%d R5=%d R6=%d R7=%d | ALU=%d | WE=%b",
            $time,
            uut.pc_out,         
            uut.instruction,    
            // Accessing the internal registers inside the register_file instance (rf_unit)
            uut.rf_unit.register_file[0],
            uut.rf_unit.register_file[1],
            uut.rf_unit.register_file[2],
            uut.rf_unit.register_file[3],
            uut.rf_unit.register_file[4],
            uut.rf_unit.register_file[5],
            uut.rf_unit.register_file[6],
            uut.rf_unit.register_file[7],
            // End of registers
            uut.alu_out,        
            uut.WE_rf           
        );
    end



    // --- STOP ON HALT ---
    // This block watches the instruction wire inside the UUT.
    // When it sees the specific binary for "BEQ R0, R0, -1", it stops.
    always @(posedge clk) begin
        if (uut.instruction == 16'b110_000_000_1111111) begin
            $display("--------------------------------------------------");
            $display("HALT instruction detected at Time=%0t", $time);
            $display("Program executed successfully.");
            $display("--------------------------------------------------");
            $finish; // <--- This stops the sim and closes the VCD file!
        end
    end

    //
    initial begin
        // Reset sequence
        rst_n = 0;
        #20;
        rst_n = 1;
        
        // SAFETY TIMEOUT
        // If the program runs for more than 10,000 time units, 
        // kill it forcefully. This prevents infinite file growth
        // if the HALT detector fails.
        #10000; 
        
        $display("Timeout reached - Force stopping simulation.");
        $finish;
    end


endmodule
