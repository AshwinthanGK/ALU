module S8BFAS #(
    parameter N = 8
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    input                f,      // 0 = add, 1 = subtract
    
    output signed [N-1:0] s,
    output               cout,
    output               overflow
);

    wire [N:0]   carry;
    wire [N-1:0] b_mod;

    // For subtraction: invert B and add 1
    assign carry[0] = f;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) 
            begin : ADDER
            assign b_mod[i] = b[i] ^ f;

            full_adder FA (
                .a     (a[i]),
                .b     (b_mod[i]),
                .cin   (carry[i]),
                .sum   (s[i]),
                .carry (carry[i+1])
            );
        end
    endgenerate

    // Unsigned carry out
    assign cout = carry[N];

    // Signed overflow detection
    assign overflow =
        (~(a[N-1] ^ b_mod[N-1])) & (a[N-1] ^ s[N-1]);


endmodule
