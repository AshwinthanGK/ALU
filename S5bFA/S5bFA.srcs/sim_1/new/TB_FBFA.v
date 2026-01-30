`timescale 1ns / 1ps

module tb_S5BFA;

    // Parameter
    parameter N = 8;

    // Inputs
    reg [N-1:0] a;
    reg [N-1:0] b;
    reg         f;      // 0 = add, 1 = subtract

    // Outputs
    wire [N-1:0] s;
    wire         cout;

    // Instantiate the adder/subtractor
    S8BFA #(.N(N)) uut (
        .a(a),
        .b(b),
        .f(f),
        .s(s),
        .cout(cout)
    );

    // Test vectors
    initial begin

        // Test 1: addition
        a = 8'd15; b = 8'd10; f = 0;  #10;
        a = 8'd100; b = 8'd50; f = 0;  #10;

        // Test 2: subtraction
        a = 8'd25; b = 8'd10; f = 1;  #10;
        a = 8'd10; b = 8'd25; f = 1;  #10;  // negative result
        a = 8'd255; b = 8'd1; f = 1;  #10;  // edge case with carry

        // Test 3: addition with max value
        a = 8'd200; b = 8'd55; f = 0; #10;

        // Test 4: subtraction resulting in 0
        a = 8'd50; b = 8'd50; f = 1; #10;

        $finish;
    end

endmodule
