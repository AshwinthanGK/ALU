module SR_latch (
    input  Sn,
    input  Rn,
    output Q,
    output Qbar
);

    nand (Q,    Sn, Qbar);
    nand (Qbar, Rn, Q);

endmodule
