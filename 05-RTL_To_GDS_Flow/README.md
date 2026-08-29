# Chapter 5: RTL to GDS flow

# 05 – RTL to GDS

This chapter covers the full digital ASIC implementation flow used by Tiny Tapeout: taking a synthesizable Verilog design and turning it into a GDS file ready for fabrication, using an open-source toolchain (Yosys → OpenROAD → Magic/KLayout) and Tiny Tapeout's GitHub Actions CI.

## What's Covered

| Chapter | Topic | Summary |
|---|---|---|
| 5.01 – Overview | The RTL-to-GDS pipeline | How the stages fit together, the tools behind each one, and how Tiny Tapeout's CI runs the whole flow |
| 5.02 – Synthesis | RTL to gate-level netlist (Yosys) | Mapping Verilog to sky130 standard cells and writing synthesis-friendly RTL |
| 5.03 – Floorplanning & Placement | Physical layout foundations (OpenROAD) | Defining die area, IO pins, the power grid, and cell placement |
| 5.04 – Clock Tree Synthesis | Balancing clock delivery (OpenROAD / TritonCTS) | Building a buffered clock tree to control skew |
| 5.05 – Routing & DRC | Wiring the design and checking manufacturability | Global routing and catching design rule violations |
| 5.06 – LVS | Confirming layout matches schematic | Extracting a netlist from the layout and comparing it to the gate-level netlist |
| 5.07 – GDS Export | Producing the final manufacturable file | Streaming out GDS and Tiny Tapeout's precheck process |
| 5.08 – Reading Synthesis Reports | Judging synthesis quality | Interpreting Yosys's cell/area statistics |
| 5.09 – Reading Timing Reports | Judging timing closure | Reading setup/hold slack in OpenSTA reports |
| 5.10 – Reading Power Reports | Judging power consumption | Breaking down internal, switching, and leakage power |

## Tools Used in This Chapter

| Tool | Purpose |
|---|---|
| Yosys | RTL synthesis and technology mapping to the sky130 standard cell library |
| OpenROAD | Floorplanning, placement, clock tree synthesis, routing, and static timing analysis |
| Magic | DRC, LVS extraction, and GDS streamout |
| KLayout | Layout viewing, DRC/XOR checks, and GDS merging |
| Netgen | LVS comparison between extracted layout and gate-level netlist |
| OpenLane | Wraps the tools above into a single scripted flow used by Tiny Tapeout's CI |

OpenLane scripts the entire pipeline above as one run, with a single configuration file controlling all of it. Knowing which tool does what is still worth having straight, though, since error messages and reports will refer to them individually.

## Tiny Tapeout's CI

When you push your Verilog to your Tiny Tapeout project repo, a GitHub Actions workflow runs OpenLane against the updated info.yaml and source files, driving Yosys and OpenROAD through every stage above, produces a GDS, runs precheck , and uploads the resulting GDS, reports, and layout renders as CI artifacts.

## Prerequisites




