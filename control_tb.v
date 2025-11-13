`timescale 1ns / 1ps

module control_tb;

    // Inputs to DUT
    reg [2:0] op;
    reg       EQ;

    // Outputs from DUT
    wire [1:0] FUNC_alu;
    wire       MUX_alu1;
    wire       MUX_alu2;
    wire [1:0] MUX_pc;
    wire       MUX_rf;
    wire [1:0] MUX_tgt;
    wire       WE_rf;
    wire       WE_dmem;

    // Instantiate the DUT
    control uut (
        .op(op),
        .EQ(EQ),
        .FUNC_alu(FUNC_alu),
        .MUX_alu1(MUX_alu1),
        .MUX_alu2(MUX_alu2),
        .MUX_pc(MUX_pc),
        .MUX_rf(MUX_rf),
        .MUX_tgt(MUX_tgt),
        .WE_rf(WE_rf),
        .WE_dmem(WE_dmem)
    );

    // Parameters for opcodes
    parameter ADD  = 3'b000;
    parameter ADDI = 3'b001;
    parameter NAND = 3'b010;
    parameter LUI  = 3'b011;
    parameter LW   = 3'b100;
    parameter SW   = 3'b101;
    parameter BEQ  = 3'b110;
    parameter JALR = 3'b111;
    
    // Test stimulus
    initial begin
        // Setup waveform dumping
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);
        
        // Monitor for any changes to inputs or outputs
        $monitor("Time=%0t op=%b EQ=%b | FUNC_alu=%b, MUX_alu1=%b, MUX_alu2=%b, MUX_pc=%b, MUX_rf=%b, MUX_tgt=%b, WE_rf=%b, WE_dmem=%b",
                 $time, op, EQ, FUNC_alu, MUX_alu1, MUX_alu2, MUX_pc, MUX_rf, MUX_tgt, WE_rf, WE_dmem);

        // Initialize inputs
        op = 3'b000;
        EQ = 1'b0;
        #10; // Wait for logic to settle

        // --- Test ADD ---
        op = ADD;
        EQ = 1'b0; // EQ doesn't matter for ADD
        #10;
        check_outputs(2'b00, 1'b0, 1'b0, 2'b00, 1'b0, 2'b01, 1'b1, 1'b0);

        // --- Test ADDI ---
        op = ADDI;
        #10;
        check_outputs(2'b00, 1'b0, 1'b1, 2'b00, 1'b0, 2'b01, 1'b1, 1'b0);

        // --- Test NAND ---
        op = NAND;
        #10;
        check_outputs(2'b01, 1'b0, 1'b0, 2'b00, 1'b0, 2'b01, 1'b1, 1'b0);

        // --- Test LUI ---
        op = LUI;
        #10;
        check_outputs(2'b10, 1'b1, 1'b0, 2'b00, 1'b0, 2'b01, 1'b1, 1'b0);

        // --- Test LW ---
        op = LW;
        #10;
        check_outputs(2'b00, 1'b0, 1'b1, 2'b00, 1'b0, 2'b00, 1'b1, 1'b0);

        // --- Test SW ---
        op = SW;
        #10;
        check_outputs(2'b00, 1'b0, 1'b1, 2'b00, 1'b1, 2'b00, 1'b0, 1'b1);

        // --- Test BEQ (EQ = 0) ---
        op = BEQ;
        EQ = 1'b0; // Branch NOT taken
        #10;
        check_outputs(2'b11, 1'b0, 1'b0, 2'b00, 1'b1, 2'b00, 1'b0, 1'b0);

        // --- Test BEQ (EQ = 1) ---
        op = BEQ;
        EQ = 1'b1; // Branch IS taken
        #10;
        check_outputs(2'b11, 1'b0, 1'b0, 2'b01, 1'b1, 2'b00, 1'b0, 1'b0);

        // --- Test JALR ---
        op = JALR;
        EQ = 1'b0; // EQ doesn't matter
        #10;
        check_outputs(2'b10, 1'b0, 1'b0, 2'b10, 1'b0, 2'b10, 1'b1, 1'b0);
        
        #10;
        $display("--- All test cases finished ---");
        $finish; // End simulation
    end

    // Task to check all outputs against expected values
    task check_outputs;
        input [1:0] exp_FUNC_alu;
        input       exp_MUX_alu1;
        input       exp_MUX_alu2;
        input [1:0] exp_MUX_pc;
        input       exp_MUX_rf;
        input [1:0] exp_MUX_tgt;
        input       exp_WE_rf;
        input       exp_WE_dmem;
        
        begin
            if (FUNC_alu !== exp_FUNC_alu || MUX_alu1 !== exp_MUX_alu1 || MUX_alu2 !== exp_MUX_alu2 ||
                MUX_pc !== exp_MUX_pc || MUX_rf !== exp_MUX_rf || MUX_tgt !== exp_MUX_tgt ||
                WE_rf !== exp_WE_rf || WE_dmem !== exp_WE_dmem) 
            begin
                $display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                $display("ERROR @ time %0t: op=%b, EQ=%b", $time, op, EQ);
                $display("  Expected: FUNC_alu=%b, MUX_alu1=%b, MUX_alu2=%b, MUX_pc=%b, MUX_rf=%b, MUX_tgt=%b, WE_rf=%b, WE_dmem=%b",
                         exp_FUNC_alu, exp_MUX_alu1, exp_MUX_alu2, exp_MUX_pc, exp_MUX_rf, exp_MUX_tgt, exp_WE_rf, exp_WE_dmem);
                $display("  Actual:   FUNC_alu=%b, MUX_alu1=%b, MUX_alu2=%b, MUX_pc=%b, MUX_rf=%b, MUX_tgt=%b, WE_rf=%b, WE_dmem=%b",
                         FUNC_alu, MUX_alu1, MUX_alu2, MUX_pc, MUX_rf, MUX_tgt, WE_rf, WE_dmem);
                $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
            end 
            else begin
                $display("SUCCESS @ time %0t: op=%b, EQ=%b -> All outputs correct.", $time, op, EQ);
            end
        end
    endtask

endmodule