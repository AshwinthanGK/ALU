`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 14:54:04
// Design Name: 
// Module Name: Simulate_SR
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


module Simulate_SR();
    reg Sn,Rn;
    wire Q,Qbar;
    
    SR_latch uut(
        .Sn(Sn),
        .Rn(Rn),
        .Q(Q),
        .Qbar(Qbar));
    
    initial begin
    Sn=1 ; Rn=1;
    
    #10 Sn=0; Rn=1;
    #10 Sn=1 ; Rn=1;
    #10 Sn=1; Rn=0;
    #10 Sn=1 ; Rn=1;
    #10 Sn=0; Rn=0;
    #10 Sn=1 ; Rn=1;
    
    #10 $finish;
    
    end
        
endmodule
