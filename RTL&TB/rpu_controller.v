`timescale 1ns / 1ps

module rpu_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire done,              // From learning engine or neuron

    output reg enable_learning,
    output reg reset_neurons,
    output reg rpu_busy
);

    typedef enum reg [1:0] {
        IDLE,
        RUNNING,
        LEARNING,
        RESET
    } state_t;

    state_t current, next;

    always @(posedge clk or posedge rst) begin
        if (rst) current <= IDLE;
        else current <= next;
    end

    always @(*) begin
        next = current;
        enable_learning = 0;
        reset_neurons = 0;
        rpu_busy = 0;

        case (current)
            IDLE: begin
                if (start) next = RUNNING;
            end
            RUNNING: begin
                rpu_busy = 1;
                if (done) next = LEARNING;
            end
            LEARNING: begin
                enable_learning = 1;
                next = RESET;
            end
            RESET: begin
                reset_neurons = 1;
                next = IDLE;
            end
        endcase
    end

endmodule
