module Top_Pipeline_CPU(
    input wire clk,
    input wire reset,
    output wire [31:0] write_back_data
);
    // IF Stage wires
    wire PC_Write;
    wire Branch;
    wire Equal;
    wire Jump;

    wire ifid_write;
    wire ifid_flush;

    wire [31:0] branch_target;
    wire [31:0] jump_target;

    wire [31:0] ifid_instruction;
    wire [31:0] ifid_pc_plus_4;

    // ID Stage wires
    wire idex_MemtoReg;
    wire idex_MemRead;
    wire idex_MemWrite;
    wire idex_ALUSrc;
    wire idex_ALUOp1;
    wire idex_ALUOp0;
    wire idex_RegDst;
    wire idex_RegWrite;

    wire [31:0] idex_pc_plus_4;
    wire [31:0] idex_read_data1;
    wire [31:0] idex_read_data2;
    wire [31:0] idex_sign_ext_immediate;
    wire [5:0] idex_funct;
    wire [4:0] idex_RegisterRs;
    wire [4:0] idex_RegisterRt;
    wire [4:0] idex_RegisterRd;
    // EX Stage wires
    wire exmem_MemtoReg;
    wire exmem_RegWrite;
    wire exmem_MemRead;
    wire exmem_MemWrite;
    wire [31:0] exmem_ALU_result;
    wire [31:0] exmem_write_data;
    wire [4:0] exmem_RegisterRd;
    // WB Stage wires
    wire memwb_MemtoReg;
    wire memwb_RegWrite;
    wire [31:0] memwb_read_data;
    wire [31:0] memwb_ALU_result;
    wire [4:0] memwb_RegisterRd;
    wire [31:0] write_back_data;
    IF_Stage u_IF_Stage(
        .clk(clk),
        .reset(reset),
        .PC_Write(PC_Write),
        .Branch(Branch),
        .Equal(Equal),
        .Jump(Jump),
        .ifid_write(ifid_write),
        .ifid_flush(ifid_flush),
        .branch_target(branch_target),
        .jump_target(jump_target),
        .ifid_instruction(ifid_instruction),
        .ifid_pc_plus_4(ifid_pc_plus_4)
    );

    ID_Stage u_ID_Stage(
        .clk(clk),
        .reset(reset),

        .ifid_instruction(ifid_instruction),
        .ifid_pc_plus_4(ifid_pc_plus_4),

        .memwb_RegWrite(memwb_RegWrite),
        .memwb_RegisterRd(memwb_RegisterRd),
        .write_back_data(write_back_data),

        .PC_Write(PC_Write),
        .Branch(Branch),
        .Equal(Equal),
        .Jump(Jump),

        .ifid_write(ifid_write),
        .ifid_flush(ifid_flush),

        .branch_target(branch_target),
        .jump_target(jump_target),

        .idex_MemtoReg(idex_MemtoReg),
        .idex_MemRead(idex_MemRead),
        .idex_MemWrite(idex_MemWrite),
        .idex_ALUSrc(idex_ALUSrc),
        .idex_ALUOp1(idex_ALUOp1),
        .idex_ALUOp0(idex_ALUOp0),
        .idex_RegDst(idex_RegDst),
        .idex_RegWrite(idex_RegWrite),

        .idex_read_data1(idex_read_data1),
        .idex_read_data2(idex_read_data2),
        .idex_sign_ext_immediate(idex_sign_ext_immediate),
        .idex_RegisterRs(idex_RegisterRs),
        .idex_RegisterRt(idex_RegisterRt),
        .idex_RegisterRd(idex_RegisterRd),
        .idex_funct(idex_funct)
    );

    EX_Stage u_EX_Stage(
        .clk(clk),
        .reset(reset),

        .idex_MemtoReg(idex_MemtoReg),
        .idex_MemRead(idex_MemRead),
        .idex_MemWrite(idex_MemWrite),
        .idex_ALUSrc(idex_ALUSrc),
        .idex_ALUOp1(idex_ALUOp1),
        .idex_ALUOp0(idex_ALUOp0),
        .idex_RegDst(idex_RegDst),
        .idex_RegWrite(idex_RegWrite),

        .idex_read_data1(idex_read_data1),
        .idex_read_data2(idex_read_data2),
        .idex_sign_ext_immediate(idex_sign_ext_immediate),
        .idex_RegisterRs(idex_RegisterRs),
        .idex_RegisterRt(idex_RegisterRt),
        .idex_RegisterRd(idex_RegisterRd),
        .idex_funct(idex_funct),

        .memwb_RegisterRd(memwb_RegisterRd),
        .memwb_RegWrite(memwb_RegWrite),
        .write_back_data(write_back_data),

        .exmem_MemtoReg(exmem_MemtoReg),
        .exmem_RegWrite(exmem_RegWrite),
        .exmem_MemRead(exmem_MemRead),
        .exmem_MemWrite(exmem_MemWrite),
        .exmem_ALU_result(exmem_ALU_result),
        .exmem_write_data(exmem_write_data),
        .exmem_RegisterRd(exmem_RegisterRd)
    );
    MEM_Stage u_MEM_Stage(
        .clk(clk),
        .reset(reset),

        .exmem_MemtoReg(exmem_MemtoReg),
        .exmem_RegWrite(exmem_RegWrite),
        .exmem_MemRead(exmem_MemRead),
        .exmem_MemWrite(exmem_MemWrite),
        .exmem_ALU_result(exmem_ALU_result),
        .exmem_write_data(exmem_write_data),
        .exmem_RegisterRd(exmem_RegisterRd),

        .memwb_MemtoReg(memwb_MemtoReg),
        .memwb_RegWrite(memwb_RegWrite),
        .memwb_read_data(memwb_read_data),
        .memwb_ALU_result(memwb_ALU_result),
        .memwb_RegisterRd(memwb_RegisterRd)
    );
    WB_Stage u_WB_Stage(
        .clk(clk),
        .reset(reset),

        .memwb_MemtoReg(memwb_MemtoReg),
        .memwb_ReadData(memwb_read_data),
        .memwb_ALU_result(memwb_ALU_result),

        .write_back_data(write_back_data)
    );

endmodule