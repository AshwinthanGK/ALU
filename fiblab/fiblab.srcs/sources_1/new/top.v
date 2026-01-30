`timescale 1ns / 1ps

module top(
    input  wire       clk_100MHz,   // Basys3 main clock
    input  wire       reset,        // btnC for reset
    output wire [0:6] seg,          // 7-segment segments
    output wire [3:0] digit         // 7-segment anodes
);

    // ==========================
    // Internal wires
    // ==========================
    wire clk_1Hz;                     // slow clock for Fibonacci increment
    wire [13:0] fib_num;               // Fibonacci number
    wire [3:0] ones, tens, hundreds, thousands; // BCD digits

    // ==========================
    // Clock divider (100 MHz -> 1 Hz)
    // ==========================
    oneHz_gen clk_div (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .clk_1Hz(clk_1Hz)
    );

    // ==========================
    // Fibonacci generator
    // ==========================
    fib_series fib_gen (
        .clk_1Hz(clk_1Hz),
        .reset(reset),
        .fib_num(fib_num)
    );

    // ==========================
    // Binary to BCD converter
    // ==========================
    decimal_to_bcd bin2bcd (
        .decimal(fib_num),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds),
        .thousands(thousands)
    );

    // ==========================
    // 7-segment display controller
    // ==========================
    seg7_control seg_disp (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds),
        .thousands(thousands),
        .seg(seg),
        .digit(digit)
    );

endmodule
