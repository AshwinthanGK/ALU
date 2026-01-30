`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2025 21:45:15
// Design Name: 
// Module Name: Stimuli
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


module Stimuli(

    );
    reg a;
    reg b;
    wire s;
    wire c;
    
    half_adder uut(a,b,s,c);
    
    initial begin
    a=0 ; b=0 ; #10;
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 1; #10;
    $finish ;
    end
endmodule
