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
    wire sel_1,sel_2;
    
    full_adder FA(a,~b,Cin,sum,Cout);
    and (sel_1,sum,select);
    and(sel_2,a,~select);
    or(Out,sel_1,sel_2);
    
    
endmodule
