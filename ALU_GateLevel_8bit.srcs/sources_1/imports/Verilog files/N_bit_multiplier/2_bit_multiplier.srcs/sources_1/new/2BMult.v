`timescale 1ns / 1ps

module Mul8_seq (
    input        clk,
    input        rst,
    input        start,
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] P,
    output       done,
    output       busy
);

    // -----------------------------
    // Internal registers
    // -----------------------------
    reg [15:0] acc;       // accumulator (product)
    reg [15:0] A_shift;   // shifted multiplicand
    reg [7:0]  B_reg;     // shifting multiplier
    reg [3:0]  cnt;       // counts 8 cycles
    reg        done_reg;
    

    assign P    = acc;
    assign busy = (cnt != 4'd0);
    assign done = done_reg;

    
   
    // -----------------------------
    // Gate-level conditional addend
    // addend = (B_reg[0] ? A_shift : 0)
    // implemented using AND gates
    // -----------------------------
    wire [15:0] addend;
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : GEN_ADDEND
            and (addend[k], A_shift[k], B_reg[0]);
        end
    endgenerate

    // -----------------------------
    // 16-bit adder using your S8FAS
    // (N=16, f=0 => ADD)
    // -----------------------------
    wire [15:0] acc_next;
    wire        add_cout;
    wire        add_ov;   // not used for unsigned multiplication

    S8BFAS #(.N(16)) ADD16 (
        .a        (acc),
        .b        (addend),
        .f        (1'b0),
        .s        (acc_next),
        .cout     (add_cout),
        .overflow (add_ov)
    );

    // -----------------------------
    // Sequential control
    // 8-cycle shift-and-add
    // -----------------------------
    always @(posedge clk) begin
        if (rst) begin
            acc      <= 16'd0;
            A_shift  <= 16'd0;
            B_reg    <= 8'd0;
            cnt      <= 4'd0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0; // 1-cycle pulse

            // Accept start only when idle
            if (start && (cnt == 4'd0)) begin
                acc     <= 16'd0;
                A_shift <= {8'd0, A};  // align A at LSBs
                B_reg   <= B;
                cnt     <= 4'd8;
            end else if (cnt != 4'd0) begin
                // Accumulate if B_reg[0]=1 (addend gated by ANDs)
                acc <= acc_next;

                // Shift for next bit
                A_shift <= (A_shift << 1);
                B_reg   <= (B_reg >> 1);

                // Count down
                cnt <= cnt - 1;

                // Done pulse on last iteration
                if (cnt == 4'd1)
                    done_reg <= 1'b1;
            end
        end
    end

endmodule