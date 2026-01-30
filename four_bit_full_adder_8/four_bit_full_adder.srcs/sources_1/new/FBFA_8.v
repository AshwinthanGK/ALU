`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 15:46:06
// Design Name: 
// Module Name: FBFA
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


module FBFA(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [4:0] s,
    output cout
    );
    wire c0,c1,c2,c3;
    full_adder FA0(a[0],b[0],cin,s[0],c0);
    full_adder FA1(a[1],b[1],c0,s[1],c1);
    full_adder FA2(a[2],b[2],c1,s[2],c2);
    full_adder FA3(a[3],b[3],c2,s[3],cout); 
endmodule
