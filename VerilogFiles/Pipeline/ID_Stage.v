module ID_Stage(
    input wire clk,
    input wire reset,
    // input from IF Stage
    input wire [31:0] ifid_instruction,
    input wire [31:0] ifid_pc_plus_4,
    // input from WB Stage
    input wire memwb_RegWrite,
    input wire [4:0] memwb_RegisterRd,
    input wire [31:0] write_back_data,

    // output to IF Stage
    // control/ hazard signals
    output wire PC_Write,
    output wire Branch,
    output wire Equal,
    output wire Jump,

    output wire ifid_write,
    output wire ifid_flush,
    //pc signals
    output wire [31:0] branch_target,
    output wire [31:0] jump_target
,
    //output to EX Stage
    output reg idex_MemtoReg,
    output reg idex_MemRead,
    output reg idex_MemWrite,
    output reg idex_ALUSrc,
    output reg idex_ALUOp1,
    output reg idex_ALUOp0,
    output reg idex_RegDst,
    output reg idex_RegWrite,


    output reg [31:0] idex_read_data1,
    output reg [31:0] idex_read_data2,
    output reg [31:0] idex_sign_ext_immediate,
    output reg [4:0] idex_RegisterRs,
    output reg [4:0] idex_RegisterRt,
    output reg [4:0] idex_RegisterRd,
    output reg [5:0] idex_funct
);
    wire [5:0] ifid_op = ifid_instruction[31:26];
    wire [4:0] ifid_RegisterRs = ifid_instruction[25:21];
    wire [4:0] ifid_RegisterRt = ifid_instruction[20:16];
    wire [4:0] ifid_RegisterRd = ifid_instruction[15:11];
    wire [4:0] ifid_shamt = ifid_instruction[10:6];
    wire [5:0] ifid_funct = ifid_instruction[5:0];
    wire [15:0] ifid_immediate = ifid_instruction[15:0];
    
    
    wire nop_write;
    wire RegDst,MemRead,MemtoReg,ALUOp0,ALUOp1,MemWrite,ALUSrc,RegWrite;

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] sign_ext_immediate;

    assign branch_target = ifid_pc_plus_4 + (sign_ext_immediate << 2);
    assign jump_target = {ifid_pc_plus_4[31:28], ifid_instruction[25:0], 2'b00};
    assign Equal = (read_data1 == read_data2);
    assign ifid_funct = ifid_instruction[5:0];
    
    HazardDetectionUnit u_HazardDetectionUnit(
        .idex_MemRead(idex_MemRead),
        .idex_RegisterRt(idex_RegisterRt),
        .ifid_RegisterRs(ifid_RegisterRs),
        .ifid_RegisterRt(ifid_RegisterRt),
        .PC_Write(PC_Write),
        .ifid_write(ifid_write),
        .nop_write(nop_write)
    );
    InstructionToControlSignal u_InstructionToControlSignal(
        .instruction(ifid_op),
        .equal(Equal),
        .RegDst(RegDst),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp0(ALUOp0),
        .ALUOp1(ALUOp1),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ifid_flush(ifid_flush)
    );
    RegisterFile u_RegisterFile(
        .clk(clk),
        .reset(reset),
        .read_reg1(ifid_RegisterRs),
        .read_reg2(ifid_RegisterRt),
        .write_reg(memwb_RegisterRd), // not used in ID stage
        .write_data(write_back_data), // not used in ID stage
        .reg_write(memwb_RegWrite), // not used in ID stage
        .read_data1(read_data1), 
        .read_data2(read_data2)  
    );

    SignExtend u_SignExtend(
        .in(ifid_immediate),
        .out(sign_ext_immediate)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin

            idex_MemRead <= 1'b0;
            idex_MemtoReg <= 1'b0;
            idex_ALUOp1 <= 1'b0;
            idex_ALUOp0 <= 1'b0;
            idex_MemWrite <= 1'b0;
            idex_ALUSrc <= 1'b0;
            idex_RegWrite <= 1'b0;
            idex_RegDst <= 1'b0;

            idex_read_data1 <= 32'd0;
            idex_read_data2 <= 32'd0;
            idex_sign_ext_immediate <= 32'd0;

            idex_RegisterRs <= 5'd0;
            idex_RegisterRt <= 5'd0;
            idex_RegisterRd <= 5'd0;
            idex_funct <= 6'd0;
        end else begin
            if (nop_write) begin
                idex_MemRead <= 1'b0;
                idex_MemtoReg <= 1'b0;
                idex_ALUOp1 <= 1'b0;
                idex_ALUOp0 <= 1'b0;
                idex_MemWrite <= 1'b0;
                idex_ALUSrc <= 1'b0;
                idex_RegWrite <= 1'b0;
                idex_RegDst <= 1'b0;

                idex_read_data1 <= 32'd0;
                idex_read_data2 <= 32'd0;
                idex_sign_ext_immediate <= 32'd0;

                idex_RegisterRs <= 5'd0;
                idex_RegisterRt <= 5'd0;
                idex_RegisterRd <= 5'd0;
                idex_funct <= 6'd0;
            end else begin
                idex_MemRead <= MemRead;
                idex_MemtoReg <= MemtoReg;
                idex_ALUOp1 <= ALUOp1;
                idex_ALUOp0 <= ALUOp0;
                idex_MemWrite <= MemWrite;
                idex_ALUSrc <= ALUSrc;
                idex_RegWrite <= RegWrite;
                idex_RegDst <= RegDst;

                idex_read_data1 <= read_data1;
                idex_read_data2 <= read_data2;
                idex_sign_ext_immediate <= sign_ext_immediate;

                idex_RegisterRs <= ifid_RegisterRs;
                idex_RegisterRt <= ifid_RegisterRt;
                idex_RegisterRd <= ifid_RegisterRd;
                idex_funct <= ifid_funct;
            end
        end
    end

endmodule