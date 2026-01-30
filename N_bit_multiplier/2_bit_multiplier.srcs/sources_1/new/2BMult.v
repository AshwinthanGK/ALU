`timescale 1ns / 1ps

module NxNStructMult #(
    parameter N = 8   // Width of inputs
)(
    input  [N-1:0] A,
    input  [N-1:0] B,
    output [2*N-1:0] P
);

    // -------------------------------
    // Partial products
    // -------------------------------
    wire [N-1:0] pp [N-1:0];  // pp[row][col]

    genvar i, j;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_rows
            for (j = 0; j < N; j = j + 1) begin : gen_cols
                assign pp[i][j] = A[j] & B[i];
            end
        end
    endgenerate

    // -------------------------------
    // Wires for sums and carries
    // -------------------------------
    // Maximum diagonal depth = 2*N-1
    wire [2*N-2:0] sum [N-1:0];   // sum[row][diagonal]
    wire [2*N-2:0] carry [N-1:0]; // carry[row][diagonal]

    genvar r, c;

    // -------------------------------
    // Structural connections
    // -------------------------------

    // LSB
    assign P[0] = pp[0][0];

    // Generate adder tree
    generate
        for (r = 0; r < N; r = r + 1) begin : row_loop
            for (c = 0; c < N; c = c + 1) begin : col_loop
                if (r == 0 && c == 0) begin
                    // Already assigned LSB
                end
                else if (r == 0) begin
                    // First row: only half-adders along the row
                    if (c == 1) begin
                        half_adder HA0 (
                            .a(pp[0][c]),
                            .b(pp[1][c-1]),
                            .sum(sum[0][c]),
                            .carry(carry[0][c])
                        );
                    end else if (c > 1) begin
                        full_adder FA0 (
                            .a(pp[0][c]),
                            .b(pp[1][c-1]),
                            .cin(carry[0][c-1]),
                            .sum(sum[0][c]),
                            .carry(carry[0][c])
                        );
                    end
                end
                else if (r > 0) begin
                    // Remaining rows: full adders
                    if (c == 0) begin
                        half_adder HA_row (
                            .a(pp[r][c]),
                            .b(sum[r-1][c+1]),
                            .sum(sum[r][c]),
                            .carry(carry[r][c])
                        );
                    end else begin
                        full_adder FA_row (
                            .a(pp[r][c]),
                            .b(sum[r-1][c+1]),
                            .cin(carry[r][c-1]),
                            .sum(sum[r][c]),
                            .carry(carry[r][c])
                        );
                    end
                end
            end
        end
    endgenerate

    // -------------------------------
    // Assign final output P
    // -------------------------------
    generate
        for (i = 1; i < 2*N-1; i = i + 1) begin : assign_out
            assign P[i] = sum[N-1][i-1];
        end
    endgenerate

endmodule
