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
    input [11:0] sw,
    output [5:0] LED
    );
    wire c0,c1,c2,c3;
    full_adder FA0(sw[0],sw[6],sw[11],LED[0],c0);
    full_adder FA1(sw[1],sw[7],c0,LED[1],c1);
    full_adder FA2(sw[2],sw[8],c1,LED[2],c2);
    full_adder FA3(sw[3],sw[9],c2,LED[3],c3);
    assign LED[5]= c3;
    assign LED[4] = 1'b0; 
endmodule
