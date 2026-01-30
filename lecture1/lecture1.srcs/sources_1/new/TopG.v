`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2025 14:42:36
// Design Name: 
// Module Name: TopG
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


module TopG(
    input [1:0]sw,
    output [1:0]led
    );
    half_adder HA1(
    .a(sw[0]),
    .b(sw[1]),
    .s(led[0]),
    .c(led[1])
    );
    
endmodule
