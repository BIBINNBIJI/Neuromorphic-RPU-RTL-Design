`timescale 1ns / 1ps

module sensor_interface (
    input wire clk,
    input wire rst,
    input wire [7:0] sensor_data,
    input wire data_valid,

    output reg spike_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spike_out <= 0;
        end else begin
            // Generate spike if sensor value crosses a threshold
            if (data_valid && sensor_data > 8'd128)
                spike_out <= 1;
            else
                spike_out <= 0;
        end
    end

endmodule
