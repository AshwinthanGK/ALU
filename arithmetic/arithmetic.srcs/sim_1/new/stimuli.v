`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.01.2026 13:21:27
// Design Name: 
// Module Name: stimuli
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


`timescale 1ns / 1ps

module tb_signed_calc;

    // Inputs
    reg signed [7:0] a, b, c, d, e, f;
    
    // Output
    wire signed [15:0] result;

    // DUT - Device Under Test
    signed_calc dut (
        .a(a), .b(b), .c(c),
        .d(d), .e(e), .f(f),
        .result(result)
    );

    // Test stimulus
    initial begin
        $display("   TIME |   a   |   b   |   c   |   d   |   e   |   f   |       result      ");
        $display("--------|-------|-------|-------|-------|-------|-------|-------------------");
        $monitor("%7t | %5d | %5d | %5d | %5d | %5d | %5d | %6d (%04h)", 
                 $time, a, b, c, d, e, f, result, result);

        // Test 1: Simple positive numbers
        #100;  a=  10; b=  20; c=   5; d=  30; e=  10; f=   4;  
        
        // Test 2: Negative numbers
        #100;  a= -15; b=  25; c=   3; d= -20; e= -30; f=   6;  
        
        // Test 3: All negative
        #100;  a= -40; b= -30; c=   4; d= -50; e=  20; f=  -5;  
        
        // Test 4: Small values + zero
        #100;  a=   0; b=   0; c=  10; d=   5; e=   5; f=   7;  
        
        // Test 5: Near maximum positive
        #100;  a= 100; b=  99; c=   2; d= 120; e= -50; f=   3;  
        
        // Test 6: Near overflow case (will saturate in 16-bit)
        #100;  a= 127; b= 127; c= 127; d= 127; e=-128; f= 127;  
        
        // Test 7: Random-ish mix
        #100;  a= -77; b=  45; c= -12; d=  89; e= -33; f= -64;  
        
        // Test 8: All maximum negative
        #100;  a=-128; b=-128; c= -64; d=-128; e= 127; f= -64;  

        #200;
        $display("\nSimulation finished.");
        $finish;
    end

endmodule
