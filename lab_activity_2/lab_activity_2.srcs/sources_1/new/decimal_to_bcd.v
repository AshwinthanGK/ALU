`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2024 12:38:20 PM
// Design Name: 
// Module Name: decimal_to_bcd
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


// 14-bit binary to BCD output

module decimal_to_bcd(
  decimal,
  ones,
  tens,
  hundreds,
  thousands
);

  //Declare input output
  
  input  wire [13:0] decimal;
  output reg [3:0] ones ;
  output reg [3:0] tens ;
  output reg [3:0] hundreds ;
  output reg [3:0] thousands;
  
  reg [15:0] bcd_out;
  
  //Declare internal variables
  
  reg [29:0] memreg;
  integer index;

  always @ (decimal) begin
    
    // clear previous number
    memreg [29:14] = 0;
    // load new number
    memreg [13:0] = decimal;
    
    // loop 14 times: the 'double-dabble' algorithm - for more information on how this works, google 'double dabble algorithm' :)
    
    // The total number of shifts required is equal to the width of the register holding the decimal value, in this case, 14 shifts <-- take note as information online frequently mentions 8 shifts but doesnt explain why. In most examples 8 bits are used to display 3 segments, 0 to 255.
    
    for(index=0; index < 14; index = index+1)
      begin
        
        if(memreg[29:26] > 4) begin
          memreg[29:26] = memreg[29:26] + 3;
        end
        
        if(memreg[25:22] > 4) begin
          memreg[25:22] = memreg[25:22] + 3;
        end
        
        if(memreg[21:18] > 4) begin
          memreg[21:18] = memreg[21:18] + 3;
        end
        
        if(memreg[17:14] > 4) begin
          memreg[17:14] = memreg[17:14] + 3;
        end
        
        memreg = memreg << 1;
        
      end
    
    // BCD values to outputs - this module outputs four BCD values in a single 16-bit register 'bcd_out.' Bits 0 to 3 are BCD digit 1, bits 4 to 7 are BCD digit 2 etc..
    
    bcd_out = memreg[29:14];
    ones = bcd_out[3:0];
    tens = bcd_out[7:4];
    hundreds = bcd_out[11:8]; 
    thousands = bcd_out[15:12]; 
    
  end
  
endmodule