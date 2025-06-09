`timescale 1ns / 1ps

module axon_interface #(
    parameter ADDR_WIDTH = 4
)(
    input wire clk,
    input wire rst,
    input wire spike_in,
    input wire [ADDR_WIDTH-1:0] source_id,

    output reg [ADDR_WIDTH-1:0] target_id,
    output reg routed_spike
);

    // Simple static routing table (can be upgraded to dynamic)
    reg [ADDR_WIDTH-1:0] routing_table [0:(1<<ADDR_WIDTH)-1];

    integer i;
    always @(posedge rst) begin
        for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1)
            routing_table[i] <= i;  // Identity mapping by default
    end

    always @(posedge clk) begin
        routed_spike <= 0;
        if (spike_in) begin
            target_id <= routing_table[source_id];
            routed_spike <= 1;
        end
    end

endmodule
