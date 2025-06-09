`timescale 1ns / 1ps

module actuator_driver (
    input wire clk,
    input wire rst,
    input wire spike_in,
    output reg [7:0] motor_command
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            motor_command <= 8'd0;
        else if (spike_in)
            motor_command <= motor_command + 8'd10;
        else
            motor_command <= motor_command - 8'd1; // decay
    end

endmodule
