module control (
    // inputs
    input reg [2:0] op,
    input reg       EQ,

    // all MUX outputs controlled by control
    output reg [1:0] FUNC_alu, 
    output reg       MUX_alu1,
    output reg       MUX_alu2,
    output reg [1:0] MUX_pc,
    output reg       MUX_rf,
    output reg [1:0] MUX_tgt,
    output reg       WE_rf,
    output reg       WE_dmem
);

    // opcode variables for easier readibility
    localparam [2:0]
            ADD = 3'b000,
            ADDI = 3'b001,
            NAND = 3'b010,
            LUI = 3'b011,
            LW = 3'b100,
            SW = 3'b101,
            BEQ = 3'b110,
            JALR = 3'b111;

    always @(*) begin
        // each opcode case sets MUX's differently 
        case (op)
            ADD: begin
                FUNC_alu = 2'b00;
                MUX_alu1 = 0;
                MUX_alu2 = 0;
                MUX_pc = 2'b00;
                MUX_rf = 0;
                MUX_tgt = 2'b01;
                WE_rf = 1;
                WE_dmem = 0;
            end

            ADDI: begin
                FUNC_alu = 2'b00;
                MUX_alu1 = 0;
                MUX_alu2 = 1;
                MUX_pc = 2'b00;
                MUX_rf = 0;
                MUX_tgt = 2'b01;
                WE_rf = 1;
                WE_dmem = 0;
            end

            NAND: begin
                FUNC_alu = 2'b01;
                MUX_alu1 = 0;
                MUX_alu2 = 0;
                MUX_pc = 2'b00;
                MUX_rf = 0;
                MUX_tgt = 2'b01;
                WE_rf = 1;
                WE_dmem = 0;
            end

            LUI: begin
                FUNC_alu = 2'b10;
                MUX_alu1 = 1;
                MUX_alu2 = 0;
                MUX_pc = 2'b00;
                MUX_rf = 0;
                MUX_tgt = 2'b01;
                WE_rf = 1;
                WE_dmem = 0;
            end

            LW: begin
                FUNC_alu = 2'b00;
                MUX_alu1 = 0;
                MUX_alu2 = 1;
                MUX_pc = 2'b00;
                MUX_rf = 0;
                MUX_tgt = 2'b00;
                WE_rf = 1;
                WE_dmem = 0;
            end

            SW: begin
                FUNC_alu = 2'b00;
                MUX_alu1 = 0;
                MUX_alu2 = 1;
                MUX_pc = 2'b10;
                MUX_rf = 1;
                MUX_tgt = 2'b00;
                WE_rf = 0;
                WE_dmem = 1;
            end

            BEQ: begin
                FUNC_alu = 2'b11;
                MUX_alu1 = 0;
                MUX_alu2 = 0;
                MUX_pc = EQ ? 2'b01 : 2'b00;
                MUX_rf = 1;
                MUX_tgt = 2'b00;
                WE_rf = 0;
                WE_dmem = 0;
            end

            JALR: begin
                FUNC_alu = 2'b10;
                MUX_alu1 = 0;
                MUX_alu2 = 0;
                MUX_pc = 2'b10;
                MUX_rf = 0;
                MUX_tgt = 2'b10;
                WE_rf = 1;
                WE_dmem = 0;
            end
        endcase
    end
endmodule