`timescale 1ns / 1ps

module learning_engine (
    input wire clk,
    input wire rst,
    input wire pre_spike,
    input wire post_spike,
    output reg signed [7:0] delta_w
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            delta_w <= 0;
        end else begin
            if (pre_spike && post_spike)
                delta_w <= 8'sd2;   // Strengthen synapse
            else if (pre_spike && !post_spike)
                delta_w <= -8'sd1;  // Weaken synapse
            else
                delta_w <= 0;
        end
    end

endmodule
