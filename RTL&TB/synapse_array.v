`timescale 1ns / 1ps

module synapse_array #(
    parameter NUM_SYNAPSES = 16,
    parameter ADDR_WIDTH = 4,               // log2(NUM_SYNAPSES)
    parameter WEIGHT_WIDTH = 8
)(
    input wire clk,
    input wire rst,

    input wire spike_in,                    // Incoming spike event
    input wire [ADDR_WIDTH-1:0] neuron_addr, // Address of target neuron

    // Learning interface
    input wire enable_learning,
    input wire signed [7:0] delta_w,        // Weight change (+/-)

    output reg [WEIGHT_WIDTH-1:0] weight_out
);

    reg [WEIGHT_WIDTH-1:0] weights [0:NUM_SYNAPSES-1];

    // Initialization
    integer i;
    always @(posedge rst) begin
        for (i = 0; i < NUM_SYNAPSES; i = i + 1) begin
            weights[i] <= 8'd1; // Initialize with weight = 1
        end
    end

    // Read + optional update
    always @(posedge clk) begin
        if (spike_in) begin
            weight_out <= weights[neuron_addr];

            if (enable_learning) begin
                weights[neuron_addr] <= weights[neuron_addr] + delta_w;
            end
        end
    end

endmodule
