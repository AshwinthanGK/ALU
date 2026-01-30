`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2026 23:07:42
// Design Name: 
// Module Name: 2BMult
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


module FourBMult(
    output [7:0] P,
    input [3:0] A,
    input [3:0] B
    );
    
    wire [3:0] w [3:0];
    
    genvar i,j;
    generate 
     for(j=0 ; j<4 ; j=j+1)begin: gen_rows
        for(i=0 ; i<4 ; i=i+1)begin: gen_cols
            assign w[i][j] = A[i]&B[j];
        end
     end
    endgenerate

    assign P[0] = w[0][0];
    
    half_adder HA1(w[1][0],w[0][1],P[1],wc1);
    
    full_adder FA1(wc1,w[2][0],w[1][1],ws1,wc2);
    half_adder HA2(w[0][2],ws1,P[2],wc3);
    
    full_adder FA2(wc2,w[3][0],w[2][1],ws2,wc4);
    full_adder FA3(w[1][2],ws2,wc3,ws3,wc5);
    half_adder HA3(w[0][3],ws3,P[3],wc6);
    
    full_adder FA4(w[3][1],w[2][2],wc4,ws4,wc7);
    full_adder FA5(w[1][3],ws4,wc5,ws5,wc8);
    half_adder HA4(wc6,ws5,P[4],wc9);
    
    full_adder FA6(w[3][2],w[2][3],wc7,ws6,wc10);
    full_adder FA7(ws6,wc8,wc9,P[5],wc11);
    
    full_adder FA8(w[3][3],wc10,wc11,P[6],P[7]);
    
    
    
endmodule
