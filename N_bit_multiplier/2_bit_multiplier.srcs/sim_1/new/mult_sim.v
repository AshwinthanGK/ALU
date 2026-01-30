`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 13:51:40
// Design Name: 
// Module Name: mult_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_FourBMult();

    // Testbench signals
    reg  [3:0] A;
    reg  [3:0] B;
    wire [7:0] P;

    // Instantiate the DUT (Device Under Test)
    FourBMult DUT (
        .A(A),
        .B(B),
        .P(P)
    );

    initial begin
        // Monitor values in simulation console
        $monitor("Time=%0t | A=%d | B=%d | P=%d", $time, A, B, P);

        // Test case 1
        A = 4'd0;  B = 4'd0;
        #10;

        // Test case 2
        A = 4'd500;  B = 4'd5;
        #10;

        // Test case 3
        A = 4'd77;  B = 4'd111;
        #10;

        // Test case 4
        A = 4'd90;  B = 4'd47;
        #10;

        // Test case 5
        A = 4'b1111; B = 4'b1111;
        #10;

        // End simulation
        $finish;
    end

endmodule

