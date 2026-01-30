module ALU(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  aluop,
    input  wire        clk,
    output reg  [31:0] result,
    output reg         zero
);

wire slt;

// Signed SLT (common ALU behavior)
assign slt = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;


always @(posedge clk) begin
    // default outputs each cycle (avoids latches / stale values)
    result <= 32'b0;
    zero   <= 1'b0;

    // ===== Logic group when aluop[2] == 1 =====
    // (matches the Bad_ALU flowchart’s right side)
    if (aluop[2] == 1'b1) begin
        if (aluop[1] == 1'b0) begin
            if (aluop[0] == 1'b0) begin
                // AND process (0100)
                result <= a & b;
            end else begin
                // OR process (0101)
                result <= a | b;
            end
        end else begin
            if (aluop[0] == 1'b0) begin
                // XOR process (1010 in the lab table, but flowchart uses this branch)
                result <= a ^ b;
            end else begin
                // NOR process (0110)
                result <= ~(a | b);
            end
        end
    end

    // ===== Non-logic group =====
    else begin
        // SLT operation when aluop[3] == 1 (intended for 1111)
        if (aluop[3] == 1'b1) begin
            result <= {31'b0, slt};
            zero   <= slt;               // "Zero will become 1 if slt is true"
        end

        // ADD/SUB via case
        else begin
            case (aluop)
                4'b0000: result <= a + b;   // Addition
                4'b0010: result <= a - b;   // Subtraction
                default: result <= 32'b0;
            endcase
        end
    end
end

endmodule
