module ALU_ME(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  aluop,
    input  wire        clk,
    output reg  [31:0] result,
    output reg         zero
);

wire slt;
assign slt = ($signed(a) < $signed(b));   

reg [31:0] next_result;
reg        next_zero;

always @(*) begin
    next_result = 32'b0;
    next_zero   = 1'b0;

    case (aluop)
        4'b0000: next_result = a + b;          // ADD
        4'b0010: next_result = a - b;          // SUB
        4'b0100: next_result = a & b;          // AND
        4'b0101: next_result = a | b;          // OR
        4'b0110: next_result = ~(a | b);       // NOR
        4'b1010: next_result = a ^ b;          // XOR
        4'b1111: next_result = {31'b0, slt};   // SLT
        default: next_result = 32'b0;
    endcase

    // zero flag rule:
    // - for SLT: zero = slt (as per your lab usage)
    // - otherwise: zero = (result == 0)
    if (aluop == 4'b1111)
        next_zero = slt;
    else
        next_zero = (next_result == 32'b0);
end

always @(posedge clk) begin
    result <= next_result;
    zero   <= next_zero;
end

endmodule
