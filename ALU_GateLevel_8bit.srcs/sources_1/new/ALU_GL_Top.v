`timescale 1ns / 1ps

module ALU_GL_Top(
    input        clk,
    input        reset,
    input        start,          // NEW: start operation
    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] opcode,
    output [15:0] result,
    output       zero,
    output       negative,
    output       overflow,
    output       cout,
    output       busy,           // NEW
    output       done,           // NEW (1-cycle pulse)
    output       div0            // NEW (latched/pulsed by divider module)
);

    // -----------------------------
    // Opcode map (edit if you want)
    // -----------------------------
    localparam OP_ADDU = 4'h0;
    localparam OP_SUBU = 4'h1;
    localparam OP_ADDS = 4'h2;
    localparam OP_SUBS = 4'h3;
    localparam OP_MULU = 4'h4;
    localparam OP_MULS = 4'h5;
    localparam OP_DIVU = 4'h6;

    // -----------------------------
    // Internal result/flag registers
    // -----------------------------
    reg [15:0] result_reg;
    reg        done_reg;

    reg        overflow_reg;
    reg        cout_reg;

    assign result   = result_reg;
    assign done     = done_reg;

    // Always-valid flags from latched result
    assign zero     = (result_reg == 16'd0);
    assign negative = result_reg[15];

    assign overflow = overflow_reg;
    assign cout     = cout_reg;

    // -----------------------------
    // ADD/SUB unit (your gate-level)
    // -----------------------------
    wire [7:0] addsub_s;
    wire       addsub_cout;
    wire       addsub_ov;

    // f=0 add, f=1 sub
    wire addsub_f = (opcode == OP_SUBU) || (opcode == OP_SUBS);

    S8BFAS #(.N(8)) addsub (
        .a        (A),
        .b        (B),
        .f        (addsub_f),
        .s        (addsub_s),
        .cout     (addsub_cout),
        .overflow (addsub_ov)
    );

    // Extend ADD/SUB result to 16-bit
    wire is_signed_addsub = (opcode == OP_ADDS) || (opcode == OP_SUBS);
    wire [15:0] addsub_ext_signed = {{8{addsub_s[7]}}, addsub_s};
    wire [15:0] addsub_ext_uns    = {8'd0, addsub_s};
    wire [15:0] addsub_result16   = is_signed_addsub ? addsub_ext_signed : addsub_ext_uns;

    // Flags for ADD/SUB
    wire addsub_overflow_flag = is_signed_addsub ? addsub_ov : 1'b0; // overflow meaningful for signed ops
    wire addsub_cout_flag     = addsub_cout;                         // carry/no-borrow meaningful for unsigned

    // -----------------------------
    // MULU / MULS wrapper in ALU top
    // -----------------------------
    wire signA = A[7];
    wire signB = B[7];
    wire signP = signA ^ signB;

    // abs(A) and abs(B) (behavioral two's complement; synthesizable)
    wire [7:0] A_abs = signA ? (~A + 8'd1) : A;
    wire [7:0] B_abs = signB ? (~B + 8'd1) : B;

    wire isMULS = (opcode == OP_MULS);
    wire isMULU = (opcode == OP_MULU);

    wire [7:0] mul_inA = isMULS ? A_abs : A;
    wire [7:0] mul_inB = isMULS ? B_abs : B;

    // Multiplier core
    wire [15:0] mul_mag;
    wire        mul_done, mul_busy;

    reg mul_start; // pulse
    Mul8_seq mul_u (
        .clk   (clk),
        .rst   (reset),
        .start (mul_start),
        .A     (mul_inA),
        .B     (mul_inB),
        .P     (mul_mag),
        .done  (mul_done),
        .busy  (mul_busy)
    );

    // sign-fix only for MULS
    wire [15:0] mul_signed = signP ? (~mul_mag + 16'd1) : mul_mag;
    wire [15:0] mul_out    = isMULS ? mul_signed : mul_mag;

    // -----------------------------
    // Divider core (unsigned)
    // -----------------------------
    wire [7:0] div_q, div_r;
    wire       div_done, div_busy_int, div0_int;

    reg div_start; // pulse
    Div_top_seq div_u (
        .clk      (clk),
        .rst      (reset),
        .start    (div_start),
        .dividend (A),
        .divisor  (B),
        .quotient (div_q),
        .remainder(div_r),
        .done     (div_done),
        .div0     (div0_int)
    );

    assign div0 = div0_int;

    // Pack divider outputs into 16-bit result: {remainder, quotient}
    // (common hardware-friendly format; change if you want quotient only)
    wire [15:0] div_out = {div_r, div_q};

    // -----------------------------
    // Busy definition (multi-cycle ops)
    // -----------------------------
    assign busy = mul_busy || div_busy_int;

    // We don't have div_busy output in your divider; define it here:
    // Divider is busy when not done and operation has started. Simplest is to expose cnt!=0 inside divider,
    // but since your divider doesn't output busy, we approximate using "not idle state" at top:
    // We'll implement a local busy tracker for divider.
    reg div_running;
    assign div_busy_int = div_running;

    // -----------------------------
    // Simple ALU controller
    // - ADD/SUB: complete immediately on start
    // - MUL/DIV: start submodule and wait for done
    // -----------------------------
    reg [3:0] op_lat;  // latch opcode for multi-cycle ops

    always @(posedge clk) begin
        if (reset) begin
            result_reg   <= 16'd0;
            done_reg     <= 1'b0;
            overflow_reg <= 1'b0;
            cout_reg     <= 1'b0;

            mul_start    <= 1'b0;
            div_start    <= 1'b0;
            div_running  <= 1'b0;
            op_lat       <= 4'd0;
        end else begin
            // default pulses low
            done_reg  <= 1'b0;
            mul_start <= 1'b0;
            div_start <= 1'b0;

            // clear div_running when divider finishes
            if (div_running && div_done)
                div_running <= 1'b0;

            // Start accepted only when idle (no running mul/div)
            if (start && !mul_busy && !div_running) begin
                op_lat <= opcode;

                // ADD/SUB complete immediately
                if (opcode == OP_ADDU || opcode == OP_SUBU || opcode == OP_ADDS || opcode == OP_SUBS) begin
                    result_reg   <= addsub_result16;
                    overflow_reg <= addsub_overflow_flag;
                    cout_reg     <= addsub_cout_flag;
                    done_reg     <= 1'b1;
                end
                
                // MULU/MULS start multiplier
                else if (opcode == OP_MULU || opcode == OP_MULS) begin
                    mul_start <= 1'b1;
                    // flags will be set when done
                end
                
                // DIVU start divider
                else if (opcode == OP_DIVU) begin
                    div_start   <= 1'b1;
                    div_running <= 1'b1;
                    // flags will be set when done
                end
                
                else begin
                    // undefined opcode: output 0 and done
                    result_reg   <= 16'd0;
                    overflow_reg <= 1'b0;
                    cout_reg     <= 1'b0;
                    done_reg     <= 1'b1;
                end
            end

            // Capture multiplier result when it finishes
            if (mul_done) begin
                result_reg   <= mul_out;
                overflow_reg <= 1'b0;
                cout_reg     <= 1'b0;
                done_reg     <= 1'b1;
            end

            // Capture divider result when it finishes
            if (div_done && div_running) begin
                result_reg   <= div_out;
                overflow_reg <= 1'b0;
                cout_reg     <= 1'b0;
                done_reg     <= 1'b1;
            end
        end
    end

endmodule