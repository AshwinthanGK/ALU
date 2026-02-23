`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of peradeniya
// Engineer: Ashwinthan
// 
// Create Date: 20.12.2025 21:00:46
// Design Name: 
// Module Name: signed 8 bit full_adder
// Project Name: ALU
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


module full_adder(
    input a,b,cin, 
    output sum,carry
);
    wire s1 , c1 ,c2;
    
    half_adder HA1(a,b,s1,c1);
    half_adder HA2(s1,cin,sum,c2);
    or(carry,c1,c2) ;
endmodule
