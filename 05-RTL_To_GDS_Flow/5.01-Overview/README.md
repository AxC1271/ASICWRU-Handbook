# 5.01 – Overview

This subchapter gives a quick tour of the RTL-to-GDS pipeline before we get into the details in later subchapters.

## The pipeline

Verilog(RTL) -> Synthesis(Yosys) -> Gate-level Netlist -> Floorplanning and Placement(OpenRoad) -> Placed Design -> Clock Tree Synthesis(OpenRoad) -> Clocked Design -> Routing & DRC (OpenROAD, Magic/KLayout) -> Routed Layout -> LVS (Magic, Netgen) -> Verified Layout -> GDS Export (Magic/KLayout) -> GDS File

Each stage takes the previous stage's output and makes it more physically real: first a netlist, then a placement, then a clock tree, then actual wires, then a verified layout, then a GDS file. 

## Tools

| Tool | Used for |
|---|---|
| Yosys | Synthesis |
| OpenROAD | Placement, clock tree synthesis, routing, timing |
| Magic | DRC, LVS extraction, GDS export |
| KLayout | Layout viewing, DRC/XOR checks |
| Netgen | LVS comparison |
| OpenLane | Runs all of the above as one flow |

In practice you won't run these tools one by one — OpenLane runs the whole pipeline for you from a single config file.

## Tiny Tapeout's CI

When you push to your Tiny Tapeout repo, GitHub Actions runs OpenLane on your design, produces a GDS, and runs precheck (DRC/LVS/antenna/tap-density checks) to confirm it's ready for the shuttle. You get the GDS, reports, and layout images back as CI artifacts.

The rest of this chapter goes through each stage above in detail, plus how to read the reports each one produces.

