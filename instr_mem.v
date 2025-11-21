`timescale 1ns/1ps
module inst_mem #(
    parameter INST_WIDTH = 32,
    parameter MEM_SIZE = 16
)(
    input clk,
    input rd_en,
    input [$clog2(MEM_SIZE)-1:0] rd_addr,
    output reg [INST_WIDTH-1:0] instruction
);

reg [INST_WIDTH-1:0] memory [0:MEM_SIZE-1];

initial $readmemh("instructions.mem", memory);

always @(posedge clk) begin
    if (rd_en)
        instruction <= memory[rd_addr];
end

endmodule