`timescale 1ns/1ps

module alu #(
    parameter DATA_WIDTH = 32,
    parameter SHIFT = 2 //use this value for doing shift operation
) (
    input [DATA_WIDTH-1:0] x,
    input [DATA_WIDTH-1:0] y,
    input [3:0] ALUctrl,
    output reg [DATA_WIDTH-1:0] out_result,
    output reg n_flag,
    output reg z_flag,
    output reg c_flag,
    output reg v_flag
);

    reg [DATA_WIDTH-1:0] logic_out;     // MUX2 output
    reg [DATA_WIDTH-1:0] shift_out;     // MUX1 output
    reg [DATA_WIDTH-1:0] slt_out;       // SLT output
    reg [DATA_WIDTH-1:0] mux3_out;      // Output from MUX3


    wire [DATA_WIDTH-1:0] y_mod;        // Y or ~Y via XOR
    wire adder_cin;
    wire [DATA_WIDTH-1:0] adder_result;
    wire carry_out;

    // Prepare modified Y and adder input
    assign y_mod = y ^ {DATA_WIDTH{ALUctrl[2]}};  // XOR for invert if b2=1
    assign adder_cin = ALUctrl[2];
    assign {carry_out, adder_result} = x + y_mod + adder_cin;

always@(*)
begin
    
    // Default flags
        c_flag = 0;
        v_flag = 0;

        // Logic operations
        logic_out = (ALUctrl[1:0] == 2'b00) ? (x & y) :
                    (ALUctrl[1:0] == 2'b01) ? (x | y) :
                    (ALUctrl[1:0] == 2'b10) ? adder_result :
                    (ALUctrl[1:0] == 2'b11) ? (x ^ y) : {DATA_WIDTH{1'b0}};

        // Shift operations
        shift_out = (ALUctrl[3:2] == 2'b01) ? (x << SHIFT) :
                    (ALUctrl[3:2] == 2'b10) ? (x >> SHIFT) :
                    (ALUctrl[3:2] == 2'b11) ? ($signed(x) >>> SHIFT) :
                    {DATA_WIDTH{1'b0}};

        // SLT operation
        slt_out = (ALUctrl == 4'b1110) ? ((x < y) ? 4'b0001 : 4'b0000) : {DATA_WIDTH{1'b0}};

        // MUX3: Select between logic_out and SLT
        mux3_out = (ALUctrl[3]) ? slt_out : logic_out;

        // MUX4: Final output selection
        out_result = (ALUctrl == 4'b1110) ? slt_out :
                     ((ALUctrl[3:2] == 2'b01) || (ALUctrl[3:2] == 2'b10) || (ALUctrl[3:2] == 2'b11)) ? shift_out :
                     mux3_out;

        // Flags
        z_flag = (out_result == 0);
        n_flag = out_result[DATA_WIDTH-1];
        c_flag = (ALUctrl[1:0] == 2'b10) ? carry_out : 1'b0;
        v_flag = (ALUctrl[1:0] == 2'b10) ? ((~(x[DATA_WIDTH-1] ^ y_mod[DATA_WIDTH-1])) & (x[DATA_WIDTH-1] ^ adder_result[DATA_WIDTH-1])) : 1'b0;
    end
//The final result (last MUX)

endmodule