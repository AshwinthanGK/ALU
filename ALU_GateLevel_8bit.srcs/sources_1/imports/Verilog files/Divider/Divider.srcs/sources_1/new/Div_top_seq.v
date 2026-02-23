`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2026 18:07:30
// Design Name: 
// Module Name: Div_top
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


module Div_top_seq (
    input        clk,
    input        rst,
    input        start,
    input  [7:0] dividend,
    input  [7:0] divisor,
    output [7:0] quotient,
    output [7:0] remainder,
    output       done,
    output       div0
);

    reg [7:0] R, Q, D;
    reg [3:0] cnt;
    reg done_reg;
    reg div0_reg;
    
    assign done = done_reg;
    assign div0 = div0_reg;

    wire [7:0] R_shift = {R[6:0], Q[7]};
    wire [7:0] Q_shift = {Q[6:0], 1'b0};

    wire [7:0] R_next;
    wire ge; // carry[8]

    Div_row subrow (
        .a(R_shift),
        .b(D),
        .Y(R_next),
        .ge(ge)        // expose carry[8] from Div_row
    );

    always @(posedge clk) begin
        if (rst) begin
            R <= 0; Q <= 0; D <= 0; cnt <= 4'b0;
            done_reg <= 1'b0;
            div0_reg <= 1'b0;
            
        end else begin
            done_reg <= 1'b0;
            
        if (start && (cnt == 4'd0)) begin
            div0_reg <= 1'b0; 
                if (divisor == 8'b0) begin
                     R <= 8'd0;
                     Q <= 8'd0;
                     D <= 8'd0;
                     cnt <= 4'd0;
    
                     div0_reg <= 1'b1;
                     done_reg <= 1'b1;
                end           
                else begin
                    R <= 8'd0;
                    Q <= dividend;
                    D <= divisor;
                    cnt <= 4'd8;
                end
        end else if (cnt != 0) begin
            R <= (ge ? R_next : R_shift) ;
            Q <= {Q_shift[7:1], ge};
            cnt <= cnt - 1;
            done_reg <= (cnt== 4'd1) ?  1'b1 :1'b0;
        end
        end
    end

    assign quotient  = Q;
    assign remainder = R;
    

endmodule

