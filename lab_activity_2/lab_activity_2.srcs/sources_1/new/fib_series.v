`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2024 10:50:52 PM
// Design Name: 
// Module Name: fib_series
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


module fib_series( 
    input clk_10Hz, 
    input reset, 
    output wire [13:0] fib_num
    );
    
    reg [13:0] fib_prev;   // F(n-2)
    reg [13:0] fib_curr;   // F(n-1)
    reg [13:0] fib_next;   // F(n)
    
    always @(posedge clk_10Hz or posedge reset) begin
        if (reset) begin
            fib_prev <= 14'd0;
            fib_curr <= 14'd1;
        end 
        else begin
            fib_next = fib_prev + fib_curr;

            if (fib_next < 14'd10000) begin
                fib_prev <= fib_curr;
                fib_curr <= fib_next;
            end 
            else begin
                // Hold the last valid value when limit is reached
                fib_prev <= fib_prev;
                fib_curr <= fib_curr;
            end
        end
    end

    assign fib_num = fib_curr;

//To Do: Complete the module 
// Use non-blocking assignment 

endmodule
