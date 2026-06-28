# 02 – Verilog / SystemVerilog

## What is an HDL?

You've spent Chapter 1 designing circuits. You understand how a NAND gate is built from MOSFETs, how combinational logic reduces to Boolean algebra, how a D flip-flop stores a bit, and how finite state machines encode sequential behavior. All of that lives on paper — or in your head.

Hardware description languages exist to bridge that gap. A **hardware description language (HDL)** lets you describe the structure and behavior of a digital circuit in code, which can then be simulated to verify correctness and synthesized into actual gates by EDA tools. Verilog and its successor SystemVerilog are the dominant HDLs in industry — if you end up working on RTL at Intel, AMD, Apple, or any major chip company, you will write Verilog or SystemVerilog every day.

The critical thing to internalize early: **you are not writing software.** Verilog looks superficially like C, but it describes hardware that runs in parallel, has no notion of sequential execution by default, and must eventually map to physical gates and wires. Every line you write has a hardware interpretation. Keeping that mental model active while you code is what separates RTL designers from people who write Verilog that simulates correctly but synthesizes into garbage.

This chapter takes everything you built in Chapter 1 and implements it in HDL. The circuits are the same — you're just expressing them in a new language.

---

## What This Chapter Covers

We move through the language progressively, starting from module structure and working up to a complete UART controller. Each section introduces new syntax in the context of a circuit you already understand from Chapter 1, so the language never gets ahead of the concept.

| Chapter | Topic | What You'll Learn |
|---------|-------|-------------------|
| [2.01 – HDLs and the Verilog Model](./2.01-HDLs/README.md) | Language fundamentals | How Verilog models hardware, the simulation-synthesis distinction, `wire` vs `reg` vs `logic`, and the structure of a module |
| [2.02 – Modules and Hierarchy](./2.02-Modules_Hierarchy/README.md) | Design organization | Defining and instantiating modules, named vs positional port connections, and building hierarchy from primitive components |
| [2.03 – Combinational Logic](./2.03-Combinational/README.md) | Gates to `assign` | Translating the CMOS gates and Boolean expressions from Chapter 1 into continuous assignments and `always_comb` blocks |
| [2.04 – Procedural Blocks](./2.04-Procedural/README.md) | `always` and `initial` | Behavioral modeling with procedural blocks, blocking vs non-blocking assignments, and when each is appropriate |
| [2.05 – Parameters and Generics](./2.05-Parameters/README.md) | Parameterized design | Writing width-generic modules with `parameter` and `localparam`, and overriding parameters at instantiation |
| [2.06 – Adders and Arithmetic](./2.06-Adders_Arithmetic/README.md) | Arithmetic in RTL | Implementing the adder circuits from Chapter 1 in Verilog — half adder, full adder, ripple-carry, and carry-lookahead |
| [2.07 – Multiplexers and Encoders](./2.07-Multiplexers/README.md) | Datapath primitives | Describing muxes, decoders, encoders, and priority logic in RTL, and understanding how they synthesize |
| [2.08 – Shift Registers](./2.08-Shift_Registers/README.md) | Sequential datapath | Serial-in/serial-out and parallel-load shift registers, and how registered logic differs from combinational in RTL |
| [2.09 – Finite State Machines](./2.09-FSMs/README.md) | FSMs in HDL | Translating state diagrams directly into SystemVerilog — one-hot vs binary encoding, Mealy vs Moore, and safe reset behavior |
| [2.10 – UART Controller Capstone](./2.10-UART/README.md) | Full design project | Building a complete UART transmitter and receiver from scratch — your first real RTL design, and the module we'll verify throughout Chapter 3 |

---

## The Capstone: UART Controller

Every chapter in this book builds toward something. In Chapter 1, it was understanding how silicon implements logic. In Chapter 2, it's building a real, working serial communication peripheral.

The UART (Universal Asynchronous Receiver-Transmitter) controller is the capstone project of this chapter. It's a non-trivial design that requires combinational logic, sequential state machines, a baud rate generator, and careful attention to timing — everything this chapter covers, applied together. It's also a practical piece of hardware that appears everywhere from microcontrollers to FPGAs to the debug interfaces on modern SoCs.

By the time you finish 2.10, you will have a complete, simulatable UART transmitter and receiver written in SystemVerilog. In Chapter 3, we'll use that design as the target for everything we build in verification — so it's worth building it carefully and understanding it deeply.

A reference implementation is provided at the end of 2.10 for comparison. Work through the design yourself first.

---

## A Note on Verilog vs SystemVerilog

This chapter teaches primarily in **SystemVerilog**, which is a superset of Verilog standardized in IEEE 1800. You may hear both terms used interchangeably in practice — most engineers say "Verilog" when they mean "the RTL subset of SystemVerilog."

The distinction matters for two reasons. First, SystemVerilog adds constructs that make RTL cleaner and safer: `logic` instead of the `wire`/`reg` ambiguity, `always_ff`/`always_comb`/`always_latch` instead of bare `always`, and `interface` for grouping related signals. Second, the verification features of SystemVerilog — assertions, constrained-random, coverage — are what Chapter 3 is built on entirely.

We'll use SystemVerilog throughout. Where a construct is specific to SystemVerilog and not available in plain Verilog, we'll call that out explicitly.

---

## Functions and Tasks

SystemVerilog provides two mechanisms for organizing reusable procedural code: **functions** and **tasks**. We'll introduce both briefly in this chapter, but won't go deep on either — their full value becomes clear in the context of verification, where they're used extensively to structure testbench code. Chapter 3 covers them properly.

For now: a **function** computes and returns a value, executes in zero simulation time, and maps reasonably well to combinational hardware. A **task** can consume simulation time, drive signals, and perform sequences of operations — which makes it a testbench primitive more than a design primitive. You'll use tasks constantly starting in 3.02.

---

## Environment Setup

This chapter includes exercises that require simulation. We use **Icarus Verilog** as the simulator throughout.

### macOS

Install Homebrew if you haven't already:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install Icarus Verilog:
```bash
brew install icarus-verilog
```

Install GTKWave. **Note:** the standard `brew install --cask gtkwave` does not work on modern macOS. Use the community tap instead:
```bash
brew tap randomplum/gtkwave
brew install --HEAD randomplum/gtkwave/gtkwave
```

Verify both installed correctly:
```bash
iverilog -v
gtkwave --version
```

### Linux (Ubuntu / Debian)

```bash
sudo apt update
sudo apt install iverilog gtkwave
```

Verify:
```bash
iverilog -v
gtkwave --version
```

### Windows

Download the Icarus Verilog Windows installer from the [official releases page](https://bleyer.org/icarus/). During installation, check the box to **add executable folders to PATH**, and select the option to install GTKWave at the same time.

After installation, open a new Command Prompt and verify:
```
iverilog -v
gtkwave --version
```

> If `iverilog` isn't recognized after installation, close and reopen your terminal — the PATH update requires a fresh session.

For the first several chapters, testbenches are provided for you. Starting in Chapter 3, you'll write your own — and you'll understand exactly why each piece of the testbench exists because you built the designs they're testing.

---

## Prerequisites

This chapter assumes you've completed Chapter 1. Specifically:

- You understand MOSFET operation and CMOS gate construction
- You can analyze and simplify Boolean expressions
- You understand flip-flops, latches, and basic sequential circuits
- You can draw and interpret a finite state machine diagram

If you're coming in with an existing Verilog background and just want to use this as a reference, the chapter table above links directly to each topic.

---

## References