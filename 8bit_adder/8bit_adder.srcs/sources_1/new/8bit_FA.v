`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2026 11:58:37
// Design Name: 
// Module Name: 8bit_FA
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


module EBFA(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] s,
    output cout
    );
    wire c0,c1;
    FBFA FBFA1(a[3:0],b[3:0],cin,s[3:0],c0);
    FBFA FBFA2(a[7:4],b[7:4],c0,s[7:4],cout);
    
endmodule

