# Chapter 1: Digital Logic

This chapter builds the foundation everything else in this handbook depends on. Before you write a single line of Verilog, before you think about pipelines or tapeout flows, you need to understand how logic is physically realized in silicon.
That's what this chapter is about.

We start at the transistor level — not because you need to become a device physicist, but because understanding *why* CMOS works the way it does makes everything downstream less mysterious. From there we build upward: primitive gates, Boolean minimization, complex gates, combinational building blocks, and finally sequential logic and finite state machines.

By the end of this chapter you should be able to look at any combinational circuit and derive its transistor-level implementation from scratch, read and write basic FSMs, and understand the timing constraints that govern sequential
logic. All of that will matter when you get to Chapter 2 (writing RTL) and Chapter 4 (building a processor).

## What's covered

| Section | Topic |
|---------|-------|
| 1.1 | The MOS Switch |
| 1.2 | The CMOS Inverter |
| 1.3 | NAND and NOR Gates |
| 1.4 | AND, OR, and NOT |
| 1.5 | Boolean Algebra and Minimization |
| 1.6 | Complex CMOS Gates |
| 1.7 | XOR and XNOR |
| 1.8 | Multiplexers and Demultiplexers |
| 1.9 | Decoders and Encoders |
| 1.10 | Half Adder and Full Adder |
| 1.11 | Latches |
| 1.12 | Flip-Flops |
| 1.13 | Finite State Machines |

## Tools

*Coming soon — installation instructions for the simulation environment used
in the lab exercises.*

## Prerequisites

No prior hardware experience required. A basic understanding of circuits
(voltage, current, what a switch does) is helpful but not assumed.