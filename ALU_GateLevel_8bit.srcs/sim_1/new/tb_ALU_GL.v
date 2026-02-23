`timescale 1ns / 1ps

module tb_ALU_GL_Top;

  // DUT I/O
  reg         clk;
  reg         reset;
  reg         start;
  reg  [7:0]  A;
  reg  [7:0]  B;
  reg  [3:0]  opcode;

  wire [15:0] result;
  wire        zero;
  wire        negative;
  wire        overflow;
  wire        cout;
  wire        busy;
  wire        done;
  wire        div0;

  // Opcodes (MUST match your ALU_GL_Top)
  localparam OP_ADDU = 4'h0;
  localparam OP_SUBU = 4'h1;
  localparam OP_ADDS = 4'h2;
  localparam OP_SUBS = 4'h3;
  localparam OP_MULU = 4'h4;
  localparam OP_MULS = 4'h5;
  localparam OP_DIVU = 4'h6;

  // Instantiate DUT
  ALU_GL_Top dut (
    .clk      (clk),
    .reset    (reset),
    .start    (start),
    .A        (A),
    .B        (B),
    .opcode   (opcode),
    .result   (result),
    .zero     (zero),
    .negative (negative),
    .overflow (overflow),
    .cout     (cout),
    .busy     (busy),
    .done     (done),
    .div0     (div0)
  );

  // Clock gen: 100MHz equivalent (10ns period)
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // ---------------------------
  // Helpers
  // ---------------------------

  // Apply a 1-cycle start pulse (only when idle)
  task automatic pulse_start;
    begin
      @(negedge clk);
      start = 1'b1;
      @(negedge clk);
      start = 1'b0;
    end
  endtask

  // Wait for done pulse
  task automatic wait_done;
    integer guard;
    begin
      guard = 0;
      while (done !== 1'b1) begin
        @(posedge clk);
        guard = guard + 1;
        if (guard > 2000) begin
          $display("[%0t] ERROR: timeout waiting for done", $time);
          $finish;
        end
      end
      // done is a pulse; sample outputs in same cycle after posedge
      @(posedge clk); // move 1 cycle forward to avoid accidental re-sampling
    end
  endtask

  // Run a single ALU operation and wait if multi-cycle
  task automatic run_op(input [3:0] op, input [7:0] a_in, input [7:0] b_in);
    begin
      // Wait until idle
      while (busy === 1'b1) @(posedge clk);

      opcode = op;
      A      = a_in;
      B      = b_in;

      pulse_start();

      // For add/sub: done is immediate (same cycle as start handling)
      // For mul/div: done comes later
      wait_done();
    end
  endtask

  // Simple checker for ADDU/SUBU where result is zero-extended [7:0]
  task automatic check_addsub_u(
    input [3:0] op,
    input [7:0] a_in,
    input [7:0] b_in
  );
    reg [8:0] exp9;
    reg [7:0] exp8;
    reg       exp_cout;
    begin
      run_op(op, a_in, b_in);

      if (op == OP_ADDU) begin
        exp9 = {1'b0,a_in} + {1'b0,b_in};
        exp8 = exp9[7:0];
        exp_cout = exp9[8];
      end else begin // SUBU
        // In many ALUs, cout=1 means no borrow. For A - B using two's complement add,
        // carry out behaves as no-borrow.
        exp9 = {1'b0,a_in} + {1'b0,(~b_in)} + 9'd1;
        exp8 = exp9[7:0];
        exp_cout = exp9[8];
      end

      if (result !== {8'd0, exp8}) begin
        $display("[%0t] FAIL U op=%0h A=%0d B=%0d result=%h expected=%h",
                 $time, op, a_in, b_in, result, {8'd0,exp8});
        $finish;
      end

      if (cout !== exp_cout) begin
        $display("[%0t] FAIL U cout op=%0h A=%0d B=%0d cout=%b expected=%b",
                 $time, op, a_in, b_in, cout, exp_cout);
        $finish;
      end

      if (overflow !== 1'b0) begin
        $display("[%0t] FAIL U overflow should be 0 op=%0h overflow=%b", $time, op, overflow);
        $finish;
      end

      $display("[%0t] PASS U op=%0h A=%0d B=%0d -> result=%h cout=%b",
               $time, op, a_in, b_in, result, cout);
    end
  endtask

  // Checker for signed add/sub (ADDS/SUBS): sign-extended to 16, overflow meaningful
  task automatic check_addsub_s(
    input [3:0] op,
    input signed [7:0] a_in_s,
    input signed [7:0] b_in_s
  );
    reg signed [8:0] exp9_s;
    reg signed [7:0] exp8_s;
    reg signed [15:0] exp16_s;
    reg exp_ov;
    begin
      run_op(op, a_in_s[7:0], b_in_s[7:0]);

      if (op == OP_ADDS) begin
        exp9_s  = a_in_s + b_in_s;
      end else begin
        exp9_s  = a_in_s - b_in_s;
      end

      exp8_s  = exp9_s[7:0];
      exp16_s = {{8{exp8_s[7]}}, exp8_s};

      // Signed overflow check for 8-bit:
      // For ADD: if signs same and result sign differs
      // For SUB: a - b = a + (-b) => use same rule with b_mod sign; easiest is compare exp9 range
      // We'll do range-based overflow (safe in TB):
      exp_ov = (exp9_s > 9'sd127) || (exp9_s < -9'sd128);

      if (result !== exp16_s) begin
        $display("[%0t] FAIL S op=%0h A=%0d B=%0d result=%h expected=%h",
                 $time, op, a_in_s, b_in_s, result, exp16_s);
        $finish;
      end

      if (overflow !== exp_ov) begin
        $display("[%0t] FAIL S overflow op=%0h A=%0d B=%0d overflow=%b expected=%b",
                 $time, op, a_in_s, b_in_s, overflow, exp_ov);
        $finish;
      end

      $display("[%0t] PASS S op=%0h A=%0d B=%0d -> result=%h overflow=%b",
               $time, op, a_in_s, b_in_s, result, overflow);
    end
  endtask

  // Checker for MULU (unsigned) and DIVU
  task automatic check_mulu(input [7:0] a_in, input [7:0] b_in);
    reg [15:0] exp;
    begin
      run_op(OP_MULU, a_in, b_in);
      exp = a_in * b_in;

      if (result !== exp) begin
        $display("[%0t] FAIL MULU A=%0d B=%0d result=%h expected=%h",
                 $time, a_in, b_in, result, exp);
        $finish;
      end

      if (overflow !== 1'b0 || cout !== 1'b0) begin
        $display("[%0t] FAIL MULU flags overflow=%b cout=%b (expected 0,0)",
                 $time, overflow, cout);
        $finish;
      end

      $display("[%0t] PASS MULU A=%0d B=%0d -> result=%h", $time, a_in, b_in, result);
    end
  endtask

  task automatic check_divu(input [7:0] a_in, input [7:0] b_in);
    reg [7:0] exp_q, exp_r;
    reg [15:0] exp_packed;
    begin
      if (b_in == 0) begin
        $display("TB: skipping div by zero (per requirement)");
        disable check_divu;
      end

      run_op(OP_DIVU, a_in, b_in);

      exp_q = a_in / b_in;
      exp_r = a_in % b_in;
      exp_packed = {exp_r, exp_q}; // must match your ALU packing

      if (result !== exp_packed) begin
        $display("[%0t] FAIL DIVU A=%0d B=%0d result=%h expected=%h (R=%0d Q=%0d)",
                 $time, a_in, b_in, result, exp_packed, exp_r, exp_q);
        $finish;
      end

      $display("[%0t] PASS DIVU A=%0d B=%0d -> R=%0d Q=%0d packed=%h",
               $time, a_in, b_in, exp_r, exp_q, result);
    end
  endtask

  // ---------------------------
  // Test sequence
  // ---------------------------
  initial begin
    // init
    reset  = 1'b1;
    start  = 1'b0;
    A      = 8'd0;
    B      = 8'd0;
    opcode = OP_ADDU;

    // reset for a few cycles
    repeat(5) @(posedge clk);
    reset = 1'b0;
    repeat(2) @(posedge clk);

    // -----------------------
    // Unsigned ADD/SUB tests
    // -----------------------
    // within limits
    check_addsub_u(OP_ADDU, 8'd10, 8'd20);      // 30
    check_addsub_u(OP_SUBU, 8'd50, 8'd20);      // 30

    // going over limit (wrap expected), cout expected
    check_addsub_u(OP_ADDU, 8'd200, 8'd100);    // 300 -> 44, cout=1
    check_addsub_u(OP_SUBU, 8'd10,  8'd20);     // underflow -> wraps, cout indicates borrow/no-borrow

    // -----------------------
    // Signed ADD/SUB tests
    // -----------------------
    // within limits
    check_addsub_s(OP_ADDS,  8'sd20,  8'sd30);  // 50
    check_addsub_s(OP_SUBS,  8'sd20,  8'sd30);  // -10

    // overflow cases
    check_addsub_s(OP_ADDS,  8'sd127, 8'sd1);   // overflow
    check_addsub_s(OP_SUBS, -8'sd128, 8'sd1);   // overflow (-129 not representable)

    // -----------------------
    // MULU tests
    // -----------------------
    check_mulu(8'd13, 8'd11);     // 143
    check_mulu(8'd255, 8'd255);   // 65025 = 0xFE01

    // -----------------------
    // DIVU tests (no div0)
    // -----------------------
    check_divu(8'd100, 8'd7);     // Q=14 R=2
    check_divu(8'd255, 8'd10);    // Q=25 R=5
    check_divu(8'd9,   8'd3);     // Q=3 R=0

    $display("[%0t] ALL TESTS PASSED", $time);
    $finish;
  end

endmodule