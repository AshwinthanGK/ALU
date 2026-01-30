`timescale 1ns / 1ps

module oneHz_gen(
    input clk_100MHz,
    input reset,
    output reg clk_1Hz
    );
    
    //To Do: Counter based clock design 
    
    // 23 bits are enough to count up to 5,000,000
    reg [26:0] count;

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            count   <= 27'd0;
            clk_1Hz <= 1'b0;
        end else begin
            if (count == 27'd49_999_999) begin
                count   <= 27'd0;
                clk_1Hz <= ~clk_1Hz;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule

    

