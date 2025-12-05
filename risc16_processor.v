module risc16_processor (
    input wire clk,
    input wire rst_n
    // This top-level module has no outputs for now,
    // as it's self-contained. For simulation, you'll
    // probe the internal wires from a testbench.
);

    // --- Internal Wires ---

    // Control Signals (from control unit)
    wire        MUX_alu1, MUX_alu2, MUX_rf, WE_rf, WE_dmem;
    wire [1:0]  FUNC_alu, MUX_pc, MUX_tgt;

    // Instruction Memory <-> PC
    wire [15:0] pc_out;         // Output of PC [cite: 1] -> Input to IM
    wire [15:0] instruction;    // Output of IM -> Input to Control/Datapath

    // Instruction Fields (Split from 'instruction' wire)
    wire [2:0]  op;
    wire [2:0]  rA;
    wire [2:0]  rB;
    wire [2:0]  rC;
    wire [9:0]  imm10;
    wire [6:0]  imm7;

    // Register File <-> ALU / Data Memory
    wire [15:0] reg_out1;       // reg_out1 (from rB) [cite: 98] -> ALU src1
    wire [15:0] reg_out2;       // reg_out2 (from rC/rA) [cite: 99, 100] -> ALU src2 / Data Memory input

    // ALU -> Datapath / Control
    wire [15:0] alu_out;        // ALU result [cite: 79]
    wire        EQ;             // ALU equality flag [cite: 79]

    // Data Memory -> Register File
    wire [15:0] mem_out;        // Data read from memory [cite: 110]

    // --- Instruction Splitting Logic ---
    // These 'assign' statements break the 16-bit instruction
    // into its component parts to be fed to other modules.
    
    // Opcode for Control Unit [cite: 11]
    assign op    = instruction[15:13]; 
    
    // Register addresses for Register File [cite: 92]
    assign rA    = instruction[12:10];
    assign rB    = instruction[9:7]; 
    assign rC    = instruction[2:0];
    
    // Immediate values for ALU and PC
    assign imm10 = instruction[9:0];  // For ALU (LUI) [cite: 79, 82]
    assign imm7  = instruction[6:0];  // For ALU (ADDI, etc.) [cite: 79, 80] & PC (BEQ) [cite: 1, 7]


    // --- Module Instantiations ---

    // 1. Program Counter (PC)
    pc pc_unit (
        .clk(clk),
        .rst_n(rst_n),
        .MUX_output(MUX_pc),    // From Control [cite: 1, 11]
        .imm(imm7),             // From Instruction [cite: 1, 3]
        .alu_out(alu_out),      // From ALU [cite: 1, 8]
        .nxt_instr(pc_out)      // Output to IM [cite: 1] and RF [cite: 92]
    );

    // 2. Instruction Memory
    instruction_memory im_unit (
        .address(pc_out),       // Input from PC
        .instruction(instruction) // Output to datapath
    );

    // 3. Control Unit
    control control_unit (
        .op(op),                // From Instruction [cite: 11]
        .EQ(EQ),                // From ALU [cite: 11]
        .MUX_alu1(MUX_alu1),    // To ALU
        .MUX_alu2(MUX_alu2),    // To ALU
        .MUX_rf(MUX_rf),        // To Register File
        .WE_rf(WE_rf),          // To Register File
        .WE_dmem(WE_dmem),      // To Data Memory
        .FUNC_alu(FUNC_alu),    // To ALU
        .MUX_pc(MUX_pc),        // To PC
        .MUX_tgt(MUX_tgt)       // To Register File
    );

    // 4. Register File
    register_file rf_unit (
        .clk(clk),
        .MUX_tgt(MUX_tgt),      // From Control [cite: 92, 102]
        .MUX_rf(MUX_rf),        // From Control [cite: 92, 99]
        .WE_rf(WE_rf),          // From Control [cite: 92, 106]
        .mem_out(mem_out),      // From Data Memory [cite: 92, 102]
        .alu_out(alu_out),      // From ALU [cite: 92, 103]
        .pc(pc_out),            // From PC (for JALR) [cite: 92, 104]
        .rA(rA),                // From Instruction [cite: 92, 97, 100]
        .rB(rB),                // From Instruction [cite: 92, 98]
        .rC(rC),                // From Instruction [cite: 92, 100]
        .reg_out1(reg_out1),    // To ALU [cite: 92]
        .reg_out2(reg_out2)     // To ALU & Data Memory [cite: 92]
    );

    // 5. ALU
    alu alu_unit (
        .MUX_alu1(MUX_alu1),    // From Control [cite: 79, 83]
        .MUX_alu2(MUX_alu2),    // From Control [cite: 79, 84]
        .FUNC_alu(FUNC_alu),    // From Control [cite: 79, 85]
        .src1_reg(reg_out1),    // From Register File [cite: 79, 83]
        .src2_reg(reg_out2),    // From Register File [cite: 79, 84]
        .imm(imm10),            // From Instruction [cite: 79, 80, 81]
        .EQ(EQ),                // To Control [cite: 79, 85]
        .alu_out(alu_out)       // To PC, RF, Data Memory [cite: 79]
    );

    // 6. Data Memory
    data_memory dmem_unit (
        .clk(clk),
        .WE_dmem(WE_dmem),      // From Control [cite: 110, 115]
        .reg_out(reg_out2),     // Data to write (from RF) [cite: 110, 115]
        .alu_out(alu_out),      // Address (from ALU) [cite: 110, 114, 115]
        .mem_out(mem_out)       // Data read (to RF) [cite: 110, 114]
    );

endmodule