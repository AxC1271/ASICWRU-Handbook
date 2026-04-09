# ASICWRU Handbook

Welcome to the ASICWRU Handbook! This GitHub repo covers everything you'll need to know, starting from the basic fundamentals up to the most advanced topics of digital systems design. We will go over the basics of logic gates, writing simple Verilog implementations, to building entire pipelined processors from scratch.

A little bit about me: I'm a Case Western computer engineering student (as of April 2026), and I love working on digital systems design and computer architecture. I've taped out multiple chips as an undergrad, debugged my way through every layer of the RTL-to-GDS stack, and learned most of what's in this handbook the hard way — through trial, error, and a lot of waveform tracing.

The motivation behind me writing this is very simple: I firmly believe that knowledge should not be gatekept. Hardware design has a reputation for being inaccessible — buried in expensive textbooks, paywalled courses, or locked inside companies. That reputation isn't entirely wrong, but it doesn't have to stay that way. Everything in this handbook is something I wish had been written down clearly when I was learning it. If you're a student at CWRU, a club member, or just someone on the internet who's curious about how chips actually work — this is for you.

## Organization

This repository is broken down into the following chapters:

- `Chapter 1`: Digital Logic

  This chapter covers logic gates at the transistor level, covering static CMOS layouts for all types of circuits. Learn how to convert Boolean expressions into transistor circuits, as well as understanding sequential logic and finite state machines.

- `Chapter 2`: Verilog / SystemVerilog

  This chapter covers HDLs, such as Verilog and SystemVerilog. These languages describe the circuits we built in Chapter 1 at a high level, making it easy to implement and simulate logic circuits. This chapter aims to cover Verilog implementations of basic adders, multiplexers, and even UART controllers.

- `Chapter 3`: Verification using Python cocotb (ECSE317 + ECSE318)

  It is said that for every RTL design engineer, there are three design verification engineers to ensure the design doesn't break. We cover how to write a testbench in Verilog, SystemVerilog Assertions (SVAs), and then Python's cocotb library for automated test cases. Verification is introduced here — before architecture — because you should be testing your RTL from the moment you write it, not after you've built a whole processor.

- `Chapter 4`: Intro to Computer Architecture (ECSE314)

  This chapter covers the basics of computer architecture with the foundational knowledge from Chapters 1–3. Specifically, we go over the RISC-V ISA, single-cycle processors, multi-stage pipelines, and more advanced techniques for making a processor run fast. We start on the basic datapath flow and realize it in Verilog. By the end of this chapter, you should be able to build your own RV32I single-cycle processor.

- `Chapter 5`: RTL to GDS Flow

  With everything covered previously, this chapter explains how RTL gets converted into a `.gds` file — the physical layout of your silicon chip. We cover synthesis with Yosys, place and route with OpenROAD, and the full Tiny Tapeout CI pipeline. This chapter is where everything comes together.

- `Chapter 6`: Timing/Power Constraints 

  This chapter describes the laws of physics that govern timing constraints of modern digital circuits. Having seen the full RTL-to-GDS flow in Chapter 5, timing constraints now have concrete meaning. We cover timing slack, how to read a static timing analysis report, setup and hold violations, TT/FF/SS corner analysis, and an introduction to Synopsys/Xilinx Design Constraints (SDC/XDC).

- `Chapter 7`: Clock Domain Crossings

  This chapter explains metastability and why transferring data across different clock domains without proper synchronization is dangerous. We cover 2-flop synchronizers, why they can still fail, alternative synchronizer topologies, MTBF analysis, and the physics of metastability.

---

Please keep in mind that this is not an exhaustive list — more chapters may be added in the future depending on what people request. I highly encourage you to fork this repository and work through the exercises to supplement your understanding of these concepts.

---

## References

The following references were used in writing this handbook and are recommended for deeper reading:

- **Patterson, D. A. & Hennessy, J. L.** — *Computer Organization and Design: RISC-V Edition* (Morgan Kaufmann). The standard computer architecture textbook. Chapters 1–4 are essential for Chapter 4 of this handbook.
- **RISC-V International** — *The RISC-V Instruction Set Manual, Volume I: Unprivileged ISA*. The official specification. Chapter 2 covers the RV32I base integer instruction set. Available at [riscv.org/technical/specifications](https://riscv.org/technical/specifications/).
- **Weste, N. & Harris, D.** — *CMOS VLSI Design: A Circuits and Systems Perspective* (Addison-Wesley). The reference for Chapter 1's transistor-level treatment of static CMOS.
- **Sutherland, S., Davidmann, S. & Flake, P.** — *SystemVerilog for Design* (Springer). A practical reference for the SystemVerilog constructs covered in Chapter 2.
- **Tiny Tapeout Documentation** — The official docs covering the TT submission flow, `info.yaml` configuration, and CI pipeline. Available at [tinytapeout.com](https://tinytapeout.com).
- **cocotb Documentation** — The official reference for writing Python-based hardware testbenches. Available at [docs.cocotb.org](https://docs.cocotb.org).
- **HDLBits** — Browser-based Verilog exercise platform. Essential companion to Chapters 2 and 3. Available at [hdlbits.01xz.net](https://hdlbits.01xz.net).
- **OpenROAD Project** — Documentation for the open-source RTL-to-GDS toolchain used in Chapter 5. Available at [openroad.readthedocs.io](https://openroad.readthedocs.io).
- **IHP SG13G2 PDK** — Process design kit documentation for the 130nm BiCMOS process used by Tiny Tapeout. Available at [github.com/IHP-GmbH/IHP-Open-PDK](https://github.com/IHP-GmbH/IHP-Open-PDK).