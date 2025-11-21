`timescale 1ns/1ps
module control(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg       reg_write,
    output reg [3:0] ALUctrl,
    output reg       ALUsrc
);

always @(*) begin
    reg_write = 0;
    ALUctrl   = 4'b0000;
    ALUsrc    = 0;

    case (opcode)
        7'b0110011: begin // R-type
            reg_write = 1;
            ALUsrc    = 0;
            case ({funct7, funct3})
                {7'b0000000, 3'b000}: ALUctrl = 4'b0010; // ADD
                {7'b0100000, 3'b000}: ALUctrl = 4'b0110; // SUB
                {7'b0000000, 3'b111}: ALUctrl = 4'b0000; // AND
                {7'b0000000, 3'b110}: ALUctrl = 4'b0001; // OR
                {7'b0000000, 3'b100}: ALUctrl = 4'b0011; // XOR
                {7'b0000000, 3'b001}: ALUctrl = 4'b0111; // SLL
                {7'b0000000, 3'b101}: ALUctrl = 4'b1011; // SRL
                {7'b0100000, 3'b101}: ALUctrl = 4'b1111; // SRA
                {7'b0000000, 3'b010}: ALUctrl = 4'b1110; // SLT
                default: ALUctrl = 4'b0000;
            endcase
        end
        7'b0010011: begin // I-type
            reg_write = 1;
            ALUsrc    = 1;
            case (funct3)
                3'b000: ALUctrl = 4'b0010; // ADDI
                3'b111: ALUctrl = 4'b0000; // ANDI
                3'b110: ALUctrl = 4'b0001; // ORI
                3'b100: ALUctrl = 4'b0011; // XORI
                3'b001: ALUctrl = 4'b0111; // SLLI
                3'b101: begin
                    if (funct7 == 7'b0000000) ALUctrl = 4'b1011; // SRLI
                    else if (funct7 == 7'b0100000) ALUctrl = 4'b1111; // SRAI
                end
                3'b010: ALUctrl = 4'b1110; // SLTI
                default: ALUctrl = 4'b0000;
            endcase
        end
        default: begin
            reg_write = 0;
            ALUctrl   = 4'b0000;
            ALUsrc    = 0;
        end
    endcase
end

endmodule