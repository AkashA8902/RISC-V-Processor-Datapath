`timescale 1ns/1ps
module write_back #(
    parameter DATA_WIDTH = 32
) (
    input [DATA_WIDTH-1:0] alu_result,
    output reg [DATA_WIDTH-1:0] wr_data_reg
);
always @(*) wr_data_reg = alu_result;
endmodule