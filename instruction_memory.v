module instruction_mem(
    input wire [15:0] pc_out, 
    //which instruction to read
    output wire [15:0] instr_out//which instruction gives to CPU
);
    reg [15:0] instruction_mem [0:65535];//65536 instructions, 16 bits each
    integer i;

    initial begin //initialize all instructions to 0
        for (i=0; i<65536; i=i+1) 
            instruction_mem[i] = 16'h0000;
    end
    assign instr_out = instruction_mem[pc_out];
    //Connects the instruction to the output; value in memory location sent to ouptut
endmodule