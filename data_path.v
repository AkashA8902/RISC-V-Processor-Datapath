`timescale 1ns/1ps
module data_path #(
    parameter INST_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter REG_WIDTH = 5,
    parameter SHIFT = 2,
    parameter MEM_SIZE = 16
)(
    input clk,
    input reset,
    input rd_en,
    output [DATA_WIDTH-1:0] alu_result
);

wire [INST_WIDTH-1:0] instruction;
wire [$clog2(MEM_SIZE)-1:0] pc;
wire [REG_WIDTH-1:0] rd, rs1, rs2;
wire [2:0] funct3;
wire [6:0] funct7;
wire [DATA_WIDTH-1:0] imm_ext;
wire [DATA_WIDTH-1:0] reg_data1, reg_data2, write_data;
wire [3:0] ALUctrl;
wire reg_write, ALUsrc;
wire z_flag, n_flag, c_flag, v_flag;
wire [6:0] opcode;

// Fetch stage
fetch #(
    .INST_WIDTH(INST_WIDTH),
    .MEM_SIZE(MEM_SIZE)
) fetch_stage (
    .clk(clk),
    .reset(reset),
    .rd_en(rd_en),
    .pc(pc),
    .instruction(instruction)
);

// Decode stage
decode decode_stage(
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm_ext(imm_ext)
);

// Control
control ctrl(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .reg_write(reg_write),
    .ALUctrl(ALUctrl),
    .ALUsrc(ALUsrc)
);

// Register File
register_file #(
    .DATA_WIDTH(DATA_WIDTH),
    .REG_WIDTH(REG_WIDTH)
) rf(
    .clk(clk),
    .reset(reset),
    .reg_write(reg_write),
    .rd_reg_1(rs1),
    .rd_reg_2(rs2),
    .wr_reg(rd),
    .wr_data(write_data),
    .rd_data_1(reg_data1),
    .rd_data_2(reg_data2)
);

// Execute stage
execute #(
    .DATA_WIDTH(DATA_WIDTH)
) ex(
    .reg_data1(reg_data1),
    .reg_data2(reg_data2),
    .imm_ext(imm_ext),
    .ALUctrl(ALUctrl),
    .ALUsrc(ALUsrc),
    .alu_result(alu_result),
    .z_flag(z_flag),
    .n_flag(n_flag),
    .c_flag(c_flag),
    .v_flag(v_flag)
);

// Write Back
write_back #(
    .DATA_WIDTH(DATA_WIDTH)
) wb(
    .alu_result(alu_result),
    .wr_data_reg(write_data)
);

endmodule