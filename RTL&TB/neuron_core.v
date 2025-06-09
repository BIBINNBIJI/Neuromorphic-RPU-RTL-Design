`timescale 1ns / 1ps

module neuron_core #(
    parameter integer THRESHOLD = 100,
    parameter integer LEAK_VALUE = 1,
    parameter integer REFRACTORY_PERIOD = 10
)(
    input wire clk,
    input wire rst,
    input wire spike_in,             // Incoming spike event
    output reg spike_out             // Neuron fires
);

    reg [7:0] membrane_potential;
    reg [3:0] refractory_counter;
    reg in_refractory;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            membrane_potential <= 0;
            spike_out <= 0;
            in_refractory <= 0;
            refractory_counter <= 0;
        end else begin
            spike_out <= 0;  // Default state

            if (in_refractory) begin
                // Decrement refractory counter
                if (refractory_counter > 0) begin
                    refractory_counter <= refractory_counter - 1;
                end else begin
                    in_refractory <= 0;
                end
            end else begin
                // Integrate spike input
                if (spike_in)
                    membrane_potential <= membrane_potential + 1;
                else if (membrane_potential > LEAK_VALUE)
                    membrane_potential <= membrane_potential - LEAK_VALUE;
                
                // Check firing condition
                if (membrane_potential >= THRESHOLD) begin
                    spike_out <= 1;
                    membrane_potential <= 0;
                    in_refractory <= 1;
                    refractory_counter <= REFRACTORY_PERIOD;
                end
            end
        end
    end

endmodule
