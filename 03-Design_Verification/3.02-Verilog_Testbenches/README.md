# 3.02 – Verilog Testbenches

## Overview

You've read about why verification matters. Now we write code.

This chapter introduces the structure of a SystemVerilog testbench — how to instantiate a design under test, generate stimulus, and check outputs. We'll do this twice: first on a **full adder**, where the input space is small enough to test exhaustively, then on a **4-bit counter**, where we have a clock and need to reason about sequential behavior over time.

By the end of this chapter you'll know how to:
- Set up a simulation environment with Icarus Verilog and GTKWave
- Write a self-checking testbench with `$display` and `$error`
- Generate a clock and drive a sequential DUT through reset
- Dump a VCD waveform and inspect it in GTKWave

These are the fundamentals. Every testbench you write for the rest of this chapter — including the UART verification environment — builds on exactly this structure.

---

## Prerequisites

### What you should already know

Before starting this chapter, you should be comfortable with:
- Writing combinational and sequential modules in SystemVerilog (Chapter 2)
- The difference between `wire` and `reg` / `logic`
- `always_ff`, `always_comb`, non-blocking vs blocking assignments
- Module instantiation with named port connections

If any of those feel shaky, review the relevant section of Chapter 2 before continuing.

### Tools you'll need

This chapter uses two tools: **Icarus Verilog** (the simulator) and **GTKWave** (the waveform viewer). Both are free and open source.

---

## Environment Setup

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

---

## How Icarus Verilog Works

Unlike an IDE that hides the build process, Icarus Verilog is a two-stage command-line tool. Understanding this model will make debugging compile errors much easier.

**Stage 1 — Compile:** `iverilog` reads your `.sv` files and produces a compiled simulation binary.

**Stage 2 — Run:** `vvp` executes that binary and runs the simulation.

The commands you'll use throughout this chapter follow this pattern:

```bash
# Compile
iverilog -g2012 -o <output_name> <testbench.sv> <dut.sv>

# Run
vvp <output_name>
```

The `-g2012` flag tells the compiler to use the IEEE 1800-2012 SystemVerilog standard, which supports the language features we use in this chapter. The `-o` flag names the compiled output file.

If your design spans multiple source files:
```bash
iverilog -g2012 -o sim_out file1.sv file2.sv file3.sv testbench.sv
```

---

## Part 1: Testbench Anatomy — Full Adder

### Why start here

A full adder has three 1-bit inputs (`a`, `b`, `cin`) and two 1-bit outputs (`sum`, `cout`). That's 2³ = 8 possible input combinations. We can test every single one. This makes it an ideal first DUT: we can write an **exhaustive** testbench and have complete confidence in the result.

### The DUT

You wrote this in Chapter 2. Here's the reference implementation to compare against:

```systemverilog
// full_adder.sv
module full_adder (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
```

### Testbench structure

A SystemVerilog testbench is itself a module — but one with no ports. It exists only for simulation. Its job is to:
1. Declare signals to drive into and read from the DUT
2. Instantiate the DUT and connect those signals
3. Apply stimulus and check outputs

```systemverilog
// full_adder_tb.sv
`timescale 1ns / 1ps

module full_adder_tb;

    // -------------------------------------------------------------------------
    // Signal declarations
    // Inputs to the DUT are driven by the testbench, so they're logic (reg)
    // Outputs from the DUT are read by the testbench, so they're logic (wire)
    // -------------------------------------------------------------------------
    logic a, b, cin;
    logic sum, cout;

    // -------------------------------------------------------------------------
    // DUT instantiation
    // -------------------------------------------------------------------------
    full_adder dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );

    // -------------------------------------------------------------------------
    // Stimulus and checking
    // -------------------------------------------------------------------------
    initial begin
        // Dump waveforms to a VCD file for GTKWave
        $dumpfile("full_adder.vcd");
        $dumpvars(0, full_adder_tb);

        $display("=== Full Adder Exhaustive Test ===");

        // Test all 8 input combinations
        // Format: {a, b, cin} -> expected {cout, sum}
        {a, b, cin} = 3'b000; #10;
        check(2'b00);

        {a, b, cin} = 3'b001; #10;
        check(2'b01);

        {a, b, cin} = 3'b010; #10;
        check(2'b01);

        {a, b, cin} = 3'b011; #10;
        check(2'b10);

        {a, b, cin} = 3'b100; #10;
        check(2'b01);

        {a, b, cin} = 3'b101; #10;
        check(2'b10);

        {a, b, cin} = 3'b110; #10;
        check(2'b10);

        {a, b, cin} = 3'b111; #10;
        check(2'b11);

        $display("=== Test Complete ===");
        $finish;
    end

    // -------------------------------------------------------------------------
    // Self-checking task
    // A task lets us reuse checking logic without repeating it 8 times
    // -------------------------------------------------------------------------
    task check(input logic [1:0] expected);
        // expected[1] = cout, expected[0] = sum
        if ({cout, sum} !== expected) begin
            $error("FAIL: a=%b b=%b cin=%b | got cout=%b sum=%b | expected cout=%b sum=%b",
                    a, b, cin, cout, sum, expected[1], expected[0]);
        end else begin
            $display("PASS: a=%b b=%b cin=%b | cout=%b sum=%b",
                      a, b, cin, cout, sum);
        end
    endtask

endmodule
```

### Running the simulation

```bash
# Compile
iverilog -g2012 -o full_adder_sim full_adder_tb.sv full_adder.sv

# Run
vvp full_adder_sim
```

Expected output:
```
=== Full Adder Exhaustive Test ===
PASS: a=0 b=0 cin=0 | cout=0 sum=0
PASS: a=0 b=0 cin=1 | cout=0 sum=1
PASS: a=0 b=1 cin=0 | cout=0 sum=1
PASS: a=0 b=1 cin=1 | cout=1 sum=0
PASS: a=1 b=0 cin=0 | cout=0 sum=1
PASS: a=1 b=0 cin=1 | cout=1 sum=0
PASS: a=1 b=1 cin=0 | cout=1 sum=0
PASS: a=1 b=1 cin=1 | cout=1 sum=1
=== Test Complete ===
```

### Viewing waveforms in GTKWave

The `$dumpfile` and `$dumpvars` calls in the testbench told the simulator to record every signal transition into a `.vcd` file. Open it:

```bash
gtkwave full_adder.vcd
```

In GTKWave:
1. Expand the module hierarchy in the left panel
2. Select the signals you want to view (`a`, `b`, `cin`, `sum`, `cout`)
3. Click **Insert** (or drag them) to add them to the waveform view
4. Use the zoom controls to fit the full simulation into view

You should see each input combination applied at 10ns intervals with the correct outputs following immediately (this is combinational logic — there's no clock delay).

---

## Part 2: Sequential Testing — 4-Bit Counter

### Why we need a clock

The full adder testbench was straightforward: apply inputs, wait a bit, check outputs. Sequential designs are different. Outputs depend not just on current inputs but on the history of inputs — specifically, on what happened on previous clock edges. To test a sequential DUT properly, we need to:
1. Generate a free-running clock
2. Apply inputs and check outputs **relative to clock edges**
3. Exercise reset behavior explicitly

The 4-bit counter is the simplest sequential design that requires all three.

### The DUT

```systemverilog
// counter.sv
module counter (
    input  logic       clk,
    input  logic       rst_n,   // active-low synchronous reset
    output logic [3:0] count
);
    always_ff @(posedge clk) begin
        if (!rst_n)
            count <= 4'b0;
        else
            count <= count + 1'b1;
    end
endmodule
```

### Testbench

```systemverilog
// counter_tb.sv
`timescale 1ns / 1ps

module counter_tb;

    // -------------------------------------------------------------------------
    // Signal declarations
    // -------------------------------------------------------------------------
    logic       clk;
    logic       rst_n;
    logic [3:0] count;

    // -------------------------------------------------------------------------
    // DUT instantiation
    // -------------------------------------------------------------------------
    counter dut (
        .clk   (clk),
        .rst_n (rst_n),
        .count (count)
    );

    // -------------------------------------------------------------------------
    // Clock generation
    // A free-running clock toggles forever at a fixed period.
    // Period = 10ns → 100 MHz
    // -------------------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // Stimulus and checking
    // -------------------------------------------------------------------------
    integer i;

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);

        $display("=== 4-Bit Counter Test ===");

        // -----------------------------------------------------------------------
        // Test 1: Reset behavior
        // Hold reset and verify count stays at 0
        // -----------------------------------------------------------------------
        rst_n = 0;
        repeat(3) @(posedge clk);
        #1; // Small delay after clock edge to let outputs settle

        if (count !== 4'b0)
            $error("FAIL: Count should be 0 during reset, got %0d", count);
        else
            $display("PASS: Reset holds count at 0");

        // -----------------------------------------------------------------------
        // Test 2: Count sequence
        // Release reset and verify count increments correctly each cycle
        // -----------------------------------------------------------------------
        rst_n = 1;

        for (i = 0; i < 16; i++) begin
            @(posedge clk);
            #1;
            if (count !== i[3:0])
                $error("FAIL: Expected count=%0d, got count=%0d", i, count);
            else
                $display("PASS: count = %0d", count);
        end

        // -----------------------------------------------------------------------
        // Test 3: Rollover
        // After 15 (4'b1111), count should roll over to 0
        // -----------------------------------------------------------------------
        @(posedge clk);
        #1;
        if (count !== 4'b0)
            $error("FAIL: Expected rollover to 0, got %0d", count);
        else
            $display("PASS: Rollover to 0 after 15");

        // -----------------------------------------------------------------------
        // Test 4: Reset mid-count
        // Assert reset while counting and verify immediate return to 0
        // -----------------------------------------------------------------------
        rst_n = 0;
        @(posedge clk);
        #1;
        if (count !== 4'b0)
            $error("FAIL: Mid-count reset failed, got %0d", count);
        else
            $display("PASS: Mid-count reset returns to 0");

        $display("=== Test Complete ===");
        $finish;
    end

endmodule
```

### The `#1` after the clock edge

You'll notice every output check comes one timestep after the `@(posedge clk)` event, not immediately after it. This is intentional. In a synchronous design, the DUT's outputs update *after* the clock edge — the flip-flops sample their inputs and update their outputs with a small propagation delay. Checking at exactly `posedge clk` means you might be reading the output from the *previous* cycle. The `#1` delay gives the simulation model time to propagate, so you're reading the correct updated value. This is a common source of off-by-one errors in testbenches — keep it in mind.

### Running the simulation

```bash
# Compile
iverilog -g2012 -o counter_sim counter_tb.sv counter.sv

# Run
vvp counter_sim
```

Expected output:
```
=== 4-Bit Counter Test ===
PASS: Reset holds count at 0
PASS: count = 0
PASS: count = 1
PASS: count = 2
...
PASS: count = 15
PASS: Rollover to 0 after 15
PASS: Mid-count reset returns to 0
=== Test Complete ===
```

Open the waveform:
```bash
gtkwave counter.vcd
```

You should see `clk` toggling at a regular 10ns period, `count` incrementing on each rising edge, and the reset holding the count at 0.

---

## What You Just Built

Two testbenches. Let's name what each piece does so the pattern is explicit:

| Component | Purpose |
|-----------|---------|
| `timescale` | Sets the time unit and precision for `#` delays |
| Signal declarations | Wires connecting testbench to DUT |
| DUT instantiation | Puts the design under test into the simulation |
| `$dumpfile` / `$dumpvars` | Records all signal transitions for GTKWave |
| `initial` block | One-shot stimulus sequence — runs once and terminates |
| `always #5 clk = ~clk` | Free-running clock — runs forever |
| `@(posedge clk)` | Synchronizes testbench to the clock |
| `task check(...)` | Reusable self-checking logic |
| `$display` / `$error` | Print results to the terminal |
| `$finish` | Ends the simulation |

This structure — signals, DUT, clock, stimulus, checker — is the skeleton of every testbench in this chapter. The UART testbench you'll write later is more complex, but it uses exactly these same building blocks.

---

## Exercises

These use the modules you wrote in Chapter 2.

1. **Modify the full adder testbench** to use a `for` loop instead of writing out all 8 test cases manually. Use a loop variable to drive `{a, b, cin}` and compute the expected `{cout, sum}` with the same logic as the DUT.

2. **Intentionally break your full adder** — change one gate to something wrong — and confirm the testbench catches it. Restore the correct implementation when done.

3. **Add a parameterized width to the counter** (e.g., `parameter WIDTH = 4`) and update the testbench to verify it counts correctly for `WIDTH = 3` and `WIDTH = 5`. You'll need to pass the parameter during instantiation.

4. **Add a load input to the counter** — a synchronous parallel load that sets `count` to a specific value when asserted. Write the RTL change and add test cases to your testbench to verify it.

---

## What's Next

In [3.03 – SystemVerilog Assertions](../3.03-SVAs/README.md), we embed correctness properties directly into the design so the simulator checks them automatically on every clock cycle — no manual `if/else` checking required.