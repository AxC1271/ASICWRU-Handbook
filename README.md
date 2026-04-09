# ASICWRU Handbook

Welcome to the ASICWRU Handbook! This GitHub repo covers everything you'll need to know, starting from the basic fundamentals up to the most advanced topics of digital systems design. This handbook was written to cover digital logic concepts taught from courses like ECSE281, ECSE314, ECSE315, ECSE317, and ECSE318 at a much deeper level. We will go over the basics of logic gates, writing simple Verilog implementations, to building entire pipelined processors from scratch.

## Organization

This repository will be broken down into multiple chapters:

- `Chapter 1`: Digital Logic (ECSE281 + ECSE315)

This chapter covers logic gates at the transistor level, covering static CMOS layouts for all types of circuits. Learn how to convert Boolean expressions into transistor circuits, as well as understanding sequential logic and finite state machines.

- `Chapter 2`: Verilog/SystemVerilog (ECSE317 + ECSE318)

This chapter covers HDLs, such as Verilog and SystemVerilog. These languages describe the circuits we've built in Chapter 1 at a high level, making it easy to implement and simulate logic circuits. This chapter aims to act as the functional equivalent to ECSE317 and ECSE318, covering Verilog implementations of basic adders, multiplexers, and even UART controllers.

- `Chapter 3`: Computer Architecture (ECSE314)

This chapter covers the basics of computer architecture with the foundational knowledge from Chapters 1 and 2. Specifically, we will go over the RISC-V ISA, single-cycle processors, multi-stage pipelines, and much more advanced techniques to make a processor run really fast. We will start on the basic datapath flow and realize them in Verilog. By the end of this chapter, you should be able to make your own RV32I single-cycle processor.

- `Chapter 4`: Timing Constraints (ECSE315)

This chapter describes the laws of physics that govern timing constraints of modern digital circuits. We will go over timing slack, how to read a static timing report, and techniques for meeting timing. This covers timing closure at a high level from the RTL side, but it mentions TT/FF/SS corner analysis briefly as well as Synopsys Design Constraints.

- `Chapter 5`: Clock Domain Crossings

This chapter explains the concept of metastability and why it can be dangerous to transfer data across different clock domains without proper synchronization. We will cover 2-flop synchronizers and other types of synchronizers (why 2-flop synchronizers are prone to fail) as well as MTBF and the physics behind metastability.

- `Chapter 6`: Verification using Python cocotb



- `Chapter 7`: RTL to GDS Flow

Please keep in mind that this is not an exhaustive list, as more chapters may come in the future.

---

## References

---