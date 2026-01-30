`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.01.2026 13:06:59
// Design Name: 
// Module Name: arithmatic_unit
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

(* use_dsp = "no" *)
module signed_calc (
    input  signed [7:0]  a,b,c,d,e,f,
    output signed [15:0] result
);

assign result = (a + b) * c + (d - e) * f;

endmodule
