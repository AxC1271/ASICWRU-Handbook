# 03 – Design Verification

## What is Design Verification?

Writing RTL is only half the job.

Once you have a design — a counter, a UART controller, a processor — you need to answer a question that turns out to be surprisingly hard: *is it actually correct?* Not "it seemed to work when I simulated it" correct. Correct in the sense that you have systematic, documented confidence that it behaves as intended across all inputs, all timing conditions, and all edge cases that matter.

That process is called **design verification**, and in the industry it is treated as a discipline in its own right. At companies like Intel, AMD, and Apple, verification engineers outnumber RTL designers. The ratio at most large chip companies is roughly two verification engineers for every one designer — sometimes higher. There are entire teams whose sole job is to find bugs before silicon is cut, because once a chip is manufactured, there is no patch.

Design verification sits between RTL design and physical implementation in the chip development flow. You write the logic, you verify it exhaustively, and only then do you hand it to the tools that synthesize and place-and-route it into actual gates. Getting verification wrong doesn't just mean your simulation passes when it shouldn't — it means your silicon ships with a bug. The consequences range from a quiet errata notice to a full product recall.

This chapter teaches you how to verify a design the way it's done professionally. Not just "write a testbench and see if it crashes," but building structured verification environments with coverage metrics, assertions, randomized stimulus, and formal proofs of correctness.

---

## What This Chapter Covers

We build the verification skillset in layers. Each chapter introduces a technique that addresses a specific limitation of the one before it. By the end, you'll have built a complete verification environment for a real design — the UART controller from Chapter 2 — using the same methodology used in industry.

| Chapter | Topic | What You'll Learn |
|---------|-------|-------------------|
| [3.01 – Why Verification?](./3.01-Why_Verification/README.md) | Motivation & mental model | Why simulation alone isn't enough, what the coverage problem is, and what the FDIV bug cost Intel $475 million |
| [3.02 – Verilog Testbenches](./3.02-Verilog_Testbenches/README.md) | Directed testing in SystemVerilog | Testbench structure, clock generation, self-checking with `$display` and `$error`, and waveform viewing in GTKWave |
| [3.03 – SystemVerilog Assertions](./3.03-SVAs/README.md) | Embedded correctness properties | Writing immediate and concurrent assertions so the simulator automatically checks protocol behavior on every cycle |
| [3.04 – Introduction to cocotb](./3.04-Intro_Cocotb/README.md) | Python-driven simulation | Using cocotb to write testbenches in Python, coroutine-based stimulus, and why scripted verification scales better than pure SystemVerilog |
| [3.05 – Driving & Sampling DUTs](./3.05-Driving_Sampling_DUTs/README.md) | Interface-level verification | Cleanly separating stimulus generation from response checking, and building reusable driver and monitor components |
| [3.06 – Scoreboards & Reference Models](./3.06-Scoreboards_Reference_Models/README.md) | Automated correctness checking | Building a behavioral reference model and a scoreboard that compares DUT output against it automatically |
| [3.07 – Functional & Code Coverage](./3.07-Functional_Code_Coverage/README.md) | Measuring thoroughness | Defining coverage groups, tracking which scenarios were exercised, and knowing when your testbench is actually done |
| [3.08 – Randomized Testing](./3.08-Randomized_Testing/README.md) | Constrained-random stimulus | Generating inputs you wouldn't think to write by hand, specifically targeting boundary conditions and rare states |
| [3.09 – Formal Verification Intro](./3.09-Formal_Verification_Intro/README.md) | Proving correctness mathematically | Bounded model checking with SymbiYosys — finding bugs that simulation fundamentally cannot, and understanding where formal fits in the flow |
| [3.10 – UART Verification Capstone](./3.10-UART_Verification/README.md) | Full verification environment | Applying every technique from this chapter to the UART controller you built in Chapter 2, from directed tests to a complete cocotb environment with coverage closure |

---

## The Design Under Test

Throughout this chapter, we verify the UART controller you built at the end of Chapter 2.

This choice is intentional. Verification is most meaningful when you already understand the design — when you have intuition about what it's supposed to do, where its edge cases live, and what kinds of failures would be subtle enough to escape a naive test. You built this module. You know its state machine, its baud rate logic, its framing. That familiarity is an asset, and it mirrors how verification works in practice: you don't verify designs you've never seen before. You verify designs your team built, and your understanding of the architecture is part of what makes you effective.

If you haven't completed the UART capstone in Chapter 2, do that first. A reference implementation is provided there for comparison.

---

## Tools Used in This Chapter

| Tool | Purpose |
|------|---------|
| [Icarus Verilog](https://steveicarus.github.io/iverilog/) | Open-source SystemVerilog simulator |
| [GTKWave](https://gtkwave.github.io/gtkwave/) | Waveform viewer for VCD files |
| [cocotb](https://www.cocotb.org/) | Python-based verification framework |
| [SymbiYosys](https://symbiyosys.readthedocs.io/) | Formal verification frontend for open-source solvers |

All tools are free and open source. Installation instructions are covered in 3.02 (Icarus Verilog + GTKWave), 3.04 (cocotb), and 3.09 (SymbiYosys).

---

## Prerequisites

This chapter assumes you've completed Chapters 1 and 2. Specifically:

- You understand combinational and sequential logic from Chapter 1
- You can read and write SystemVerilog modules confidently from Chapter 2
- You have a working UART controller from the Chapter 2 capstone

If you're here specifically for verification methodology and already have an RTL background, you can start at 3.01 — but you'll need a UART implementation (your own or the reference) by 3.10.