`timescale 1ns / 1ps

module rpu_top (
    input wire clk,
    input wire rst,
    input wire start,                   // From host/controller
    input wire [7:0] sensor_data,      // External sensor input
    input wire data_valid,             // Valid signal from sensor

    output wire [7:0] motor_command    // Actuator output
);

    // === Internal Signals ===
    wire sensor_spike;
    wire neuron_spike;
    wire routed_spike;
    wire [3:0] source_id, target_id;

    wire enable_learning;
    wire reset_neurons;
    wire rpu_busy;
    wire signed [7:0] delta_w;
    wire [7:0] synapse_weight;
    wire done;

    // === Module Instances ===

    sensor_interface sensor_if (
        .clk(clk),
        .rst(rst),
        .sensor_data(sensor_data),
        .data_valid(data_valid),
        .spike_out(sensor_spike)
    );

    synapse_array syn_array (
        .clk(clk),
        .rst(rst),
        .spike_in(sensor_spike),
        .neuron_addr(4'd0),
        .enable_learning(enable_learning),
        .delta_w(delta_w),
        .weight_out(synapse_weight)
    );

    neuron_core #(
        .THRESHOLD(100),
        .LEAK_VALUE(1),
        .REFRACTORY_PERIOD(10)
    ) neuron_inst (
        .clk(clk),
        .rst(rst | reset_neurons),
        .spike_in(sensor_spike),      // Using sensor spike directly for demo
        .spike_out(neuron_spike)
    );

    axon_interface axon_if (
        .clk(clk),
        .rst(rst),
        .spike_in(neuron_spike),
        .source_id(4'd0),
        .target_id(target_id),
        .routed_spike(routed_spike)
    );

    learning_engine learn_eng (
        .clk(clk),
        .rst(rst),
        .pre_spike(sensor_spike),
        .post_spike(neuron_spike),
        .delta_w(delta_w)
    );

    actuator_driver actuator (
        .clk(clk),
        .rst(rst),
        .spike_in(neuron_spike),
        .motor_command(motor_command)
    );

    rpu_controller ctrl (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(neuron_spike),  // Treat neuron_spike as activity completion
        .enable_learning(enable_learning),
        .reset_neurons(reset_neurons),
        .rpu_busy(rpu_busy)
    );

endmodule
