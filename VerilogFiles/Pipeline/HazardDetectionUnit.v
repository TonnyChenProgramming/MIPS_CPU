module HazardDetectionUnit(
    //load instruction flag
    input wire idex_MemRead,

    // key registers for load-use hazard detection
    input wire [4:0] idex_RegisterRt,
    input wire [4:0] ifid_RegisterRs,
    input wire [4:0] ifid_RegisterRt,



    output wire PC_Write,
    output wire ifid_write,
    output wire nop_write

);
    // Load-use hazard detection
    wire load_stall = idex_MemRead && ((idex_RegisterRt == ifid_RegisterRs)||(idex_RegisterRt == ifid_RegisterRt));

    assign PC_Write = ~load_stall;
    assign ifid_write = ~load_stall;
    assign nop_write = load_stall;

 
endmodule