`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 16:14:04
// Design Name: 
// Module Name: TB_FBFA
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


module TB_FBFA();
    reg [11:0] sw;
    wire [5:0] LED;
    
    
    FBFA uut( .sw(sw) , .LED(LED));
    
    initial begin
     sw = 12'b0;
     
     #10 sw = 12'b0;
     #10 sw = 12'b000000000001;
     #10 sw = 12'b101110000000;
     #10 sw = 12'b101010001010;
     #10 sw = 12'b001111001111;
     #10 sw = 12'b101100000000;
     
     #10 $finish;
     end
     
     
     
    
endmodule
