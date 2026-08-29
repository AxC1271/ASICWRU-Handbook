# 5.02 – Synthesis

Synthesis by Yosys turns Verilog into a gate-level netlist made of standard cells from the sky130 library. 

## What Yosys does

Roughly, a synthesis run looks like this:

```tcl
read_verilog -sv project.v
hierarchy -top tt_um_my_project
proc; opt; fsm; opt; memory; opt
techmap; opt
dfflibmap -liberty sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty sky130_fd_sc_hd__tt_025C_1v80.lib
clean
write_verilog synthesized.v
```

| Step | What it does |
|---|---|
| `read_verilog` | Parses your Verilog |
| `hierarchy -top` | Sets and checks the top module (must match `info.yaml`) |
| `proc` | Converts always blocks into muxes/registers |
| `fsm`, `memory`, `opt` | High-level optimization: FSM encoding, memory inference, cleanup |
| `techmap` | Maps to generic gates |
| `dfflibmap` | Maps flip-flops to sky130 DFF cells |
| `abc` | Maps combinational logic to sky130 standard cells |
| `write_verilog` | Writes out the final gate-level netlist |

You don't normally write this script yourself — OpenLane generates and runs it for you.

## Writing synthesis-friendly Verilog

- Use synchronous resets.
- Make sure every signal in a combinational `always` block is assigned on every path, or you'll get an unintended latch.
- Be explicit about bit widths in arithmetic.
- Don't use vendor-specific primitives — stick to plain, technology-agnostic RTL.

See 5.08 for how to read the synthesis report itself.
