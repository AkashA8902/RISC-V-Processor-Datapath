`timescale 1ns/1ps
module fetch #(
    parameter INST_WIDTH = 32,
    parameter MEM_SIZE = 16
)(
    input clk,
    input reset,
    input rd_en,
    output reg [$clog2(MEM_SIZE)-1:0] pc,
    output [INST_WIDTH-1:0] instruction
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 0;
    else if (rd_en)
        pc <= pc + 1;
end

inst_mem #(
    .INST_WIDTH(INST_WIDTH),
    .MEM_SIZE(MEM_SIZE)
) imem (
    .clk(clk),
    .rd_en(rd_en),
    .rd_addr(pc),
    .instruction(instruction)
);

endmodule