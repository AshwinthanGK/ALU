`timescale 1ns/1ps

module tb_ALU_ME;

    // DUT inputs
    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  aluop;
    reg         clk;

    // DUT outputs
    wire [31:0] result;
    wire        zero;

    // Instantiate DUT
    ALU_ME dut (
        .a(a),
        .b(b),
        .aluop(aluop),
        .clk(clk),
        .result(result),
        .zero(zero)
    );

    // Clock generation: 10 ns period
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // -------- Helper task: apply one opcode and check --------
    task automatic run_one_op(input [31:0] A, input [31:0] B, input [3:0] OP);
        reg [31:0] exp_result;
        reg        exp_zero;
        reg        exp_slt;
    begin
        // Drive inputs before the clock edge
        a     = A;
        b     = B;
        aluop = OP;

        // Compute expected values (match your ALU behavior)
        exp_slt = ($signed(A) < $signed(B)) ? 1'b1 : 1'b0;

        case (OP)
            4'b0000: exp_result = A + B;             // ADD
            4'b0010: exp_result = A - B;             // SUB
            4'b0100: exp_result = A & B;             // AND
            4'b0101: exp_result = A | B;             // OR
            4'b0110: exp_result = ~(A | B);          // NOR
            4'b1010: exp_result = A ^ B;             // XOR
            4'b1111: exp_result = {31'b0, exp_slt};  // SLT
            default: exp_result = 32'b0;             // default in your ALU
        endcase

        // zero rule used in your ALU spec:
        // - for SLT: zero = slt
        // - otherwise: zero = (result == 0)
        if (OP == 4'b1111)
            exp_zero = exp_slt;
        else
            exp_zero = (exp_result == 32'b0);

        // Wait for DUT to register output on posedge
        @(posedge clk);
        #1; // small delay to allow nonblocking updates to settle

        // Display and check
        $display("A=%0d  B=%0d  OP=%b  RESULT=%0d (0x%08h)  ZERO=%b | EXP=%0d (0x%08h)  EXPZ=%b  %s",
                 A, B, OP, result, result, zero,
                 exp_result, exp_result, exp_zero,
                 ((result === exp_result) && (zero === exp_zero)) ? "PASS" : "FAIL");

        if ((result !== exp_result) || (zero !== exp_zero)) begin
            $display("  MISMATCH -> got result=%h zero=%b, expected result=%h zero=%b",
                     result, zero, exp_result, exp_zero);
        end
    end
    endtask

    // -------- Run one input set through all 7 ops + random op --------
    task automatic run_set(input [31:0] A, input [31:0] B);
        reg [3:0] rnd;
    begin
        $display("\n==============================");
        $display("TEST SET: A=%0d, B=%0d", A, B);
        $display("==============================");

        // 7 required operations (per lab table)
        run_one_op(A, B, 4'b0000); // ADD
        run_one_op(A, B, 4'b0010); // SUB
        run_one_op(A, B, 4'b0100); // AND
        run_one_op(A, B, 4'b0101); // OR
        run_one_op(A, B, 4'b0110); // NOR
        run_one_op(A, B, 4'b1010); // XOR
        run_one_op(A, B, 4'b1111); // SLT

        // Random 4-bit opcode
        rnd = $urandom_range(0, 15);
        $display("---- Random opcode for this set: %b ----", rnd);
        run_one_op(A, B, rnd);
    end
    endtask

    // -------- Main stimulus --------
    initial begin
        // init
        a = 0;
        b = 0;
        aluop = 0;

        // Let clock run a little
        repeat (2) @(posedge clk);

        // Given input sets
        run_set(32'd10,      32'd5);
        run_set(32'd5673982, 32'd8436235);
        run_set(32'd934,     32'd934);

        $display("\nAll tests done.");
        $finish;
    end

endmodule
