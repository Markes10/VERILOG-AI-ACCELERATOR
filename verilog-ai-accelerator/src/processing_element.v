// ==============================================================================
// Custom AI Hardware Accelerator: 2D Systolic Processing Element (PE)
// Language: Verilog (IEEE 1364-2001)
// ==============================================================================

module processing_element (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        clear_acc,
    input  wire signed [7:0]  a_in,     // Activations input from left
    input  wire signed [7:0]  b_in,     // Weights input from top
    output reg  signed [7:0]  a_out,    // Activations passed to right
    output reg  signed [7:0]  b_out,    // Weights passed to bottom
    output reg  signed [31:0] acc_out   // Accumulated partial sum
);

    wire signed [15:0] mult_result;
    assign mult_result = a_in * b_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_out   <= 8'sd0;
            b_out   <= 8'sd0;
            acc_out <= 32'sd0;
        end else begin
            // Pipeline forwarding to adjacent systolic neighbors
            a_out <= a_in;
            b_out <= b_in;

            // Multiply-Accumulate
            if (clear_acc) begin
                acc_out <= mult_result;
            end else begin
                acc_out <= acc_out + mult_result;
            end
        end
    end

endmodule
