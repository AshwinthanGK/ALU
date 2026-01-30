`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2026 20:14:02
// Design Name: 
// Module Name: PU
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


module PU(
    input a,b,select,Cin,
    output Cout,
    output Out
    );
    wire sum;
    full_adder FA(a,b,Cin,Out,Cout);
    
    
endmodule
