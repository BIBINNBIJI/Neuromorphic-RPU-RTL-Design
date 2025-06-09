`timescale 1ns / 1ps

module noc_bus #(
    parameter NUM_NODES = 4,
    parameter ADDR_WIDTH = 2
)(
    input wire clk,
    input wire rst,

    input wire [NUM_NODES-1:0] spike_in,
    output reg [NUM_NODES-1:0] spike_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spike_out <= 0;
        end else begin
            spike_out <= spike_in;  // Simple broadcast (upgradeable)
        end
    end

endmodule
