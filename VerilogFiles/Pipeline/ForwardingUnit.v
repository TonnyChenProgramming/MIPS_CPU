module ForwardingUnit(
    input wire [4:0] exmem_RegisterRd,
    input wire exmem_RegWrite,
    input wire [4:0] memwb_RegisterRd,
    input wire memwb_RegWrite,
    input wire [4:0] idex_RegisterRs,
    input wire [4:0] idex_RegisterRt,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);
    always @(*) begin
        // Default no forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // EX hazard
        if (exmem_RegWrite && (exmem_RegisterRd != 0) && (exmem_RegisterRd == idex_RegisterRs)) begin
            ForwardA = 2'b10;
        end
        if (exmem_RegWrite && (exmem_RegisterRd != 0) && (exmem_RegisterRd == idex_RegisterRt)) begin
            ForwardB = 2'b10;
        end

        // MEM hazard
        if (memwb_RegWrite && (memwb_RegisterRd != 0) && 
            !(exmem_RegWrite && (exmem_RegisterRd != 0) && (exmem_RegisterRd == idex_RegisterRs)) &&
            (memwb_RegisterRd == idex_RegisterRs)) begin
            ForwardA = 2'b01;
        end
        if (memwb_RegWrite && (memwb_RegisterRd != 0) && 
            !(exmem_RegWrite && (exmem_RegisterRd != 0) && (exmem_RegisterRd == idex_RegisterRt)) &&
            (memwb_RegisterRd == idex_RegisterRt)) begin
            ForwardB = 2'b01;
        end
    end
endmodule