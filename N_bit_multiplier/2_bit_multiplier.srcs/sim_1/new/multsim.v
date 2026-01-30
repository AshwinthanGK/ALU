`timescale 1ns / 1ps

module tb_NxNStructMult;

    parameter N = 4;             // Width of multiplier
    reg  [N-1:0] A;
    reg  [N-1:0] B;
    wire [2*N-1:0] P;

    // Instantiate the multiplier
    NxNStructMult #(N) DUT (
        .A(A),
        .B(B),
        .P(P)
    );

    integer i;  // Loop for multiple test vectors

    // Define test vectors
    reg [N-1:0] testA [0:4];
    reg [N-1:0] testB [0:4];

    initial begin
        // Define 5 input pairs
        testA[0] = 4'd0;   testB[0] = 4'd0;
        testA[1] = 4'd3;   testB[1] = 4'd5;
        testA[2] = 4'd7;   testB[2] = 4'd2;
        testA[3] = 4'd9;   testB[3] = 4'd4;
        testA[4] = 4'd15;  testB[4] = 4'd15;

        // Apply test vectors one by one
        for (i = 0; i < 5; i = i + 1) begin
            A = testA[i];
            B = testB[i];
            #10;  // Wait for output to settle

            // Print results
            $display("Time=%0t | A=%d B=%d => P=%d (Expected=%d)", 
                     $time, A, B, P, A*B);
        end

        $fini
