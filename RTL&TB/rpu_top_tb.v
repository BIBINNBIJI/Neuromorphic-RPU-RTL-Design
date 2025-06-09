`timescale 1ns / 1ps

module rpu_top_tb;

  // Inputs
  reg clk;
  reg rst;
  reg start;
  reg [7:0] sensor_data;
  reg data_valid;

  // Outputs
  wire [7:0] motor_command;

  // Instantiate the Unit Under Test (UUT)
  rpu_top uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .sensor_data(sensor_data),
    .data_valid(data_valid),
    .motor_command(motor_command)
  );

  // Clock generation: 10ns clock
  initial begin
    clk = 0;
  end
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    $dumpfile("rpu_top_tb.vcd");      // For waveform viewing in GTKWave
    $dumpvars(0, rpu_top_tb);

    // Initialize Inputs
    rst = 1;
    start = 0;
    sensor_data = 8'd0;
    data_valid = 0;

    // Reset pulse
    #20;
    rst = 0;

    // Start pulse
    #10;
    start = 1;
    #10;
    start = 0;

    // First sensor input
    #20;
    sensor_data = 8'd55;
    data_valid = 1;
    #10;
    data_valid = 0;

    // Wait a bit and send another input
    #40;
    sensor_data = 8'd100;
    data_valid = 1;
    #10;
    data_valid = 0;

    // Wait and finish
    #100;
    $finish;
  end

endmodule
