module alu (
    //inputs
    input  wire [15:0] src1_reg,    
    input  wire [15:0] src2_reg,    
    input  wire [9:0] imm,  

    input  wire        MUX_alu1,
    input  wire        MUX_alu2,
    input  wire [1:0]  FUNC_alu,

    //outputs
    output reg  [15:0] alu_out,
    output wire        EQ
);
    //FUNC_ALU operations
    localparam [1:0]
        ALU_ADD   = 2'b00,
        ALU_NAND  = 2'b01,
        ALU_PASS1 = 2'b10,
        ALU_EQL   = 2'b11;

    wire [15:0] sign_ext_imm; 
    wire [15:0] left_shift_imm; 

    wire [15:0] SRC1_alu;
    wire [15:0] SRC2_alu;
    
    //ALU MUX determines if imm values or reg values are used in operations
    assign SRC1_alu = MUX_alu1 ? left_shift_imm : src1_reg;
    assign SRC2_alu = MUX_alu2 ? sign_ext_imm : src2_reg;

    //sign extend and left shift immediate for operations
    assign sign_ext_imm = {{9{imm[6]}}, imm[6:0]}; 
    assign left_shift_imm = imm << 6; 

    //equal flag if src1 and src2 are equal for EQ! op
    assign EQ = (SRC1_alu == SRC2_alu);

    always @(*) begin
        case (FUNC_alu)
            ALU_ADD: begin
                alu_out = SRC1_alu + SRC2_alu;
            end

            ALU_NAND: begin
                alu_out = ~(SRC1_alu & SRC2_alu);
            end

            ALU_PASS1: begin
                alu_out = SRC1_alu;
            end
            ALU_EQL: begin
                alu_out = 16'h0000;
            end
            //default case
            default:
            begin
                alu_out = 16'h0000;
            end
        endcase
    end

endmodule