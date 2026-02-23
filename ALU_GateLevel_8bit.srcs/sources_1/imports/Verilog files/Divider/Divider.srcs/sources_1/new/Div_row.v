`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.01.2026 12:24:36
// Design Name: 
// Module Name: Div_row
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


module Div_row(
    input [7:0] a,b ,
    output  [7:0]Y,
    output ge
    );
    wire [8:0]carry;
    assign carry[0]= 1'b1;
    
    genvar i,j;
    generate 
    for (j=0 ; j<8 ; j = j+1)begin:generate_PUs
    PU PU_Array(.a(a[j]),
                .b(b[j]),
                .select(1'b1),      //always take subtract bit
                .Cin(carry[j]),
                .Cout(carry[j+1]),
                .Out(Y[j]));
    end
    endgenerate
    
    assign ge = carry[8];
    
endmodule
