`timescale 1ns/1ps
module execute #(
    parameter DATA_WIDTH = 32
)(
    input  [DATA_WIDTH-1:0] reg_data1,
    input  [DATA_WIDTH-1:0] reg_data2,
    input  [DATA_WIDTH-1:0] imm_ext,
    input  [3:0]  ALUctrl,
    input         ALUsrc,
    output [DATA_WIDTH-1:0] alu_result,
    output        z_flag, n_flag, c_flag, v_flag
);

wire [DATA_WIDTH-1:0] alu_b;
assign alu_b = (ALUsrc) ? imm_ext : reg_data2;

alu #(.DATA_WIDTH(DATA_WIDTH)) alu_inst(
    .x(reg_data1),
    .y(alu_b),
    .ALUctrl(ALUctrl),
    .out_result(alu_result),
    .z_flag(z_flag),
    .n_flag(n_flag),
    .c_flag(c_flag),
    .v_flag(v_flag)
);

endmodule