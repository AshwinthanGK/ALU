# 8-bit Arithmetic Logic Unit (ALU) – Gate-Level Verilog RTL

This project implements a fully synthesizable **8-bit Arithmetic Logic Unit (ALU)** using
structural (gate-level) Verilog.  
The design includes addition, subtraction, multiplication, and division, and demonstrates
classical datapath construction from fundamental building blocks.

The objective of this work is to understand how real processor ALUs are created from
bit-slice arithmetic, carry propagation, and control logic rather than relying on
behavioral operators.

---

## Features

- 8-bit Addition  
- 8-bit Subtraction (two’s complement)  
- 8-bit Multiplication  
- 8-bit Division (restoring, iterative)  
- Signed / unsigned interpretation support  
- Modular hierarchical design  
- Fully synthesizable RTL  
- Simulation testbenches for verification  

---

## Operations Implemented

| Opcode | Operation |
|-------|----------|
| ADD | A + B |
| SUB | A − B |
| MUL | A × B |
| DIV | A ÷ B (quotient + remainder) |

---

## Arithmetic Principles Used

### Addition
Ripple-carry adder built from:
- Half adders  
- Full adders  

Carry propagates from LSB → MSB.

---

### Subtraction
Implemented using:

A - B = A + (~B + 1)

The same adder hardware is reused by conditionally inverting operand **B**
and setting the initial carry-in.

---

### Multiplication
Partial products generated using AND gates and accumulated using
adder stages.

---

### Division
Implemented using the **restoring division algorithm**.

For each bit:
1. Shift remainder left and inject next dividend bit.
2. Attempt subtraction with divisor.
3. If no borrow → keep result, quotient bit = 1.
4. Else → restore remainder, quotient bit = 0.

The divider is **sequential**, reusing a single subtract/restore datapath
across multiple clock cycles.

---

## Hardware Architecture

The ALU is partitioned into:

ALU
├── Add/Sub Unit
│ └── full_adder chain
├── Multiplier
│ └── partial product network
├── Divider (sequential)
│ ├── R register
│ ├── Q register
│ ├── D register
│ ├── control FSM
│ └── Div_row (PU array)
└── Operation Select (MUX)


---

## Datapath Philosophy

This project emphasizes:

- Building arithmetic from gates  
- Bit-slice scalability  
- Carry / borrow reasoning  
- Reusing combinational hardware across cycles  
- Clear separation of control and datapath  

---

## Signed Number Handling

Two’s complement representation is used.

Important notes:
- The adder hardware is identical for signed and unsigned numbers.
- Interpretation is determined by flags such as overflow and sign.
- Division can be extended by applying magnitude arithmetic followed by sign correction.

---

## Timing Model

| Operation | Latency |
|----------|--------|
| ADD | 1 cycle (combinational) |
| SUB | 1 cycle (combinational) |
| MUL | 1 cycle (current implementation) |
| DIV | 8 cycles (iterative) |

---

## Verification

Testbenches validate:
- Functional correctness  
- Carry/borrow behavior  
- Remainder generation  
- Multi-cycle completion for division  

Expected results are compared against behavioral computations in simulation.

---

## Learning Outcomes

This project demonstrates practical understanding of:

- Structural RTL design  
- Generate constructs  
- Two’s complement arithmetic  
- Borrow vs carry interpretation  
- Sequential reuse of combinational logic  
- FSM + datapath integration  
- Microarchitectural trade-offs (area vs latency)

---

## Why This Project Is Valuable

Many student ALUs rely on `+ - * /` operators.

This design instead:
- Constructs arithmetic from primitive gates  
- Reflects real implementation techniques  
- Shows deeper understanding of hardware behavior  

---

## Possible Extensions

- Parameterizable bit width  
- Pipelined multiplier/divider  
- Additional logical operations  
- Status flag generation (Z, N, C, V)  
- Integration into a CPU datapath  

---

## Tools

- Verilog HDL  
- Vivado / XSIM  

---

## Author

Ashwin
