// ==============================================================================
// 4x4 2D Mesh Systolic Array Accelerator Top-Level
// ==============================================================================

module systolic_array_4x4 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        clear_acc,
    input  wire signed [7:0]  act_in_0,
    input  wire signed [7:0]  act_in_1,
    input  wire signed [7:0]  act_in_2,
    input  wire signed [7:0]  act_in_3,
    input  wire signed [7:0]  wt_in_0,
    input  wire signed [7:0]  wt_in_1,
    input  wire signed [7:0]  wt_in_2,
    input  wire signed [7:0]  wt_in_3,
    output wire signed [31:0] pe_acc_00,
    output wire signed [31:0] pe_acc_33
);

    // Interconnect wires
    wire signed [7:0] a_wire [0:3][0:4];
    wire signed [7:0] b_wire [0:4][0:3];
    wire signed [31:0] acc_wire [0:3][0:3];

    assign a_wire[0][0] = act_in_0;
    assign a_wire[1][0] = act_in_1;
    assign a_wire[2][0] = act_in_2;
    assign a_wire[3][0] = act_in_3;

    assign b_wire[0][0] = wt_in_0;
    assign b_wire[0][1] = wt_in_1;
    assign b_wire[0][2] = wt_in_2;
    assign b_wire[0][3] = wt_in_3;

    genvar r, c;
    generate
        for (r = 0; r < 4; r = r + 1) begin : gen_rows
            for (c = 0; c < 4; c = c + 1) begin : gen_cols
                processing_element pe_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .clear_acc(clear_acc),
                    .a_in(a_wire[r][c]),
                    .b_in(b_wire[r][c]),
                    .a_out(a_wire[r][c+1]),
                    .b_out(b_wire[r+1][c]),
                    .acc_out(acc_wire[r][c])
                );
            end
        end
    endgenerate

    assign pe_acc_00 = acc_wire[0][0];
    assign pe_acc_33 = acc_wire[3][3];

endmodule
