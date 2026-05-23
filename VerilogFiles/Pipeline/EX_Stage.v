module EX_Stage(
    input wire clk,
    input wire reset,
    // input from ID Stage
    input wire idex_MemtoReg,
    input wire idex_MemRead,
    input wire idex_MemWrite,
    input wire idex_ALUSrc,
    input wire idex_ALUOp1,
    input wire idex_ALUOp0,
    input wire idex_RegDst,
    input wire idex_RegWrite,


    input wire [31:0] idex_read_data1,
    input wire [31:0] idex_read_data2,
    input wire [31:0] idex_sign_ext_immediate,
    input wire [4:0] idex_RegisterRs,
    input wire [4:0] idex_RegisterRt,
    input wire [4:0] idex_RegisterRd,
    input wire [5:0] idex_funct,

    //input from write back stage for forwarding unit
    input wire [4:0] memwb_RegisterRd,
    input wire memwb_RegWrite,
    input wire [31:0] write_back_data, // to be used for forwarding

    // output to EX/MEM registers
    output reg exmem_MemtoReg,
    output reg exmem_RegWrite,
    output reg exmem_MemRead,
    output reg exmem_MemWrite,
    output reg [31:0] exmem_ALU_result,
    output reg [31:0] exmem_write_data,
    output reg [4:0] exmem_RegisterRd
);
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;
    wire [31:0] ALU_input1;
    wire [31:0] ALU_input2;
    wire [2:0] ALU_Sel;
    wire [31:0] ALU_result;
    wire [31:0] ALU_write_data;
    wire [4:0] RegisterRd = idex_RegDst ? idex_RegisterRd : idex_RegisterRt;

    //not used in this stage but kept for clarity
    wire zero;
    wire Overflow; 

    assign ALU_input1 = (ForwardA == 2'b00) ? idex_read_data1 :
                        (ForwardA == 2'b10) ? exmem_ALU_result :
                        (ForwardA == 2'b01) ? write_back_data : 32'd0; // Additional cases can be added as needed
    assign ALU_write_data = (ForwardB == 2'b00) ? idex_read_data2 :
                            (ForwardB == 2'b10) ? exmem_ALU_result :
                            (ForwardB == 2'b01) ? write_back_data : 32'd0; 
    assign ALU_input2 = idex_ALUSrc ? idex_sign_ext_immediate : ALU_write_data;
// Additional cases can be added as needed
    // Forwarding Unit
    ForwardingUnit u_ForwardingUnit(
        .exmem_RegisterRd(exmem_RegisterRd),
        .exmem_RegWrite(exmem_RegWrite),
        .memwb_RegisterRd(memwb_RegisterRd), // To be connected
        .memwb_RegWrite(memwb_RegWrite),   // To be connected
        .idex_RegisterRs(idex_RegisterRs),
        .idex_RegisterRt(idex_RegisterRt),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    ALUControl u_ALUControl(
        .ALUOp({idex_ALUOp1, idex_ALUOp0}),      
        .funct(idex_funct),
        .ALU_Sel(ALU_Sel)
    );

    ALU_32bits u_ALU_32bits(
        .A       (ALU_input1),
        .B       (ALU_input2),
        .ALU_Sel (ALU_Sel),
        .Result  (ALU_result),
        .Zero    (zero),
        .Overflow(Overflow)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            exmem_MemtoReg <= 1'b0;
            exmem_RegWrite <= 1'b0;
            exmem_MemRead <= 1'b0;
            exmem_MemWrite <= 1'b0;
            exmem_ALU_result <= 32'd0;
            exmem_write_data <= 32'd0;
            exmem_RegisterRd <= 5'd0;
        end else begin
            exmem_MemtoReg <= idex_MemtoReg;
            exmem_RegWrite <= idex_RegWrite;
            exmem_MemRead <= idex_MemRead;
            exmem_MemWrite <= idex_MemWrite;
            exmem_ALU_result <= ALU_result;
            exmem_write_data <= ALU_write_data; // typically the second ALU input is written to memory
            exmem_RegisterRd <= RegisterRd;
        end
    end

endmodule