`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2025 09:59:44 PM
// Design Name: 
// Module Name: tb1
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



//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2025 09:18:39 PM
// Design Name: 
// Module Name: tb
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

module fib_tb(); 

    reg clk_10Hz;
    reg reset; 
    wire [13:0] fib_num; 
    
    fib_series dut(.clk_10Hz(clk_10Hz), .reset(reset), .fib_num(fib_num)); 
    
initial begin 
    clk_10Hz = 0; 
    forever #5 clk_10Hz = ~clk_10Hz; 
end 

initial begin 
 $monitor("Time = %0t ns | Reset = %b | Fibonacci Number = %d", $time, reset, fib_num);    
   //To Do: Define the inputs 
     //Apply reset
     reset = 1'b1;
     #20
     
     //Release reset
     reset = 1'b0;
     
     #300;
     
     reset = 1'b1;
     #20;
     reset = 1'b0;
     #200;
     $finish;
     
     end
    
endmodule

