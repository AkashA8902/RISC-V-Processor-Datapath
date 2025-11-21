`timescale 1ns/1ps

module tb_data_path #(
    parameter INST_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter REG_WIDTH = 5,
    parameter SHIFT = 2,
    parameter MEM_SIZE = 16
) (

);

reg clk;
reg reset;
reg rd_en;
wire [DATA_WIDTH-1:0] alu_result;

always #5 clk = ~clk;

data_path #(
    .INST_WIDTH(INST_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .REG_WIDTH(REG_WIDTH),
    .SHIFT(SHIFT),
    .MEM_SIZE(MEM_SIZE)
) DUT (
    .clk(clk),
    .reset(reset),
    .rd_en(rd_en),
    .alu_result(alu_result)
);

initial
begin
    clk = 0;
    reset = 1;
    rd_en = 1;
    #12 reset = 0;
end

endmodule
