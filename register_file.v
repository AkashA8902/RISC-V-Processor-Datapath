`timescale 1ns/1ps
module register_file #(
    parameter DATA_WIDTH = 32,
    parameter REG_WIDTH = 5
)(
    input clk,
    input reset,
    input reg_write,
    input [REG_WIDTH-1:0] rd_reg_1,
    input [REG_WIDTH-1:0] rd_reg_2,
    input [REG_WIDTH-1:0] wr_reg,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data_1,
    output reg [DATA_WIDTH-1:0] rd_data_2
);

reg [DATA_WIDTH-1:0] registers [0:(1<<REG_WIDTH)-1];
integer i;

always @(posedge clk or posedge reset) begin
    if (reset)
        for (i = 0; i < (1<<REG_WIDTH); i = i + 1)
            registers[i] <= 0;
    else if (reg_write && wr_reg != 0)
        registers[wr_reg] <= wr_data;
end

always @(*) rd_data_1 = registers[rd_reg_1];
always @(*) rd_data_2 = registers[rd_reg_2];

endmodule