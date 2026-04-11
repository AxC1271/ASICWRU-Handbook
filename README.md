# ASICWRU Handbook

Welcome to the ASICWRU Handbook — a free, openly written reference for anyone who wants to go from zero to tapeout. This repo covers everything from logic gates at the transistor level to running a full RTL-to-GDS flow and submitting a design to silicon.

A little about me: I'm a computer engineering student at Case Western Reserve University (as of April 2026). I've taped out chips as an undergrad, debugged my way through every layer of the stack from RTL to GDS, and learned most of what's in this handbook the hard way — through trial, error, and a lot of waveform tracing.

Hardware design has a reputation for being inaccessible. Expensive textbooks, paywalled courses, knowledge locked inside companies. That reputation isn't entirely wrong — but it doesn't have to stay that way. Everything here is something I wish had been written down clearly when I was learning it. If you're a CWRU student, a CWRU CHIPS club member, or just someone on the internet curious about how chips actually work — this is for you.

---

## What's covered

| Chapter | Topic |
|---------|-------|
| 01 | Digital Logic — gates, static CMOS, Boolean algebra, FSMs |
| 02 | Verilog / SystemVerilog — HDL fundamentals through UART controllers |
| 03 | Verification with cocotb — testbenches, SVAs, Python-driven simulation |
| 04 | Computer Architecture — RISC-V ISA, single-cycle and pipelined processors |
| 05 | RTL-to-GDS Flow — Yosys, OpenROAD, Tiny Tapeout CI |
| 06 | Timing & Power Constraints — STA, slack, setup/hold, SDC/XDC |
| 07 | Clock Domain Crossings — metastability, synchronizers, MTBF |

Chapters are ordered deliberately. Verification (Ch. 3) comes before architecture (Ch. 4) because you should be writing testbenches from the moment you write RTL — not after you've built a processor.

---

## How to use this

Each chapter lives in its own folder with markdown articles and exercises. Work through them in order if you're starting from scratch, or jump to whatever's relevant to your current project.

Fork the repo. Work through the exercises. If something's wrong or unclear, open an issue.

---

## References

- **Patterson & Hennessy** — *Computer Organization and Design: RISC-V Edition*. The standard architecture reference. Chapters 1–4 map closely to Ch. 4 of this handbook.
- **Weste & Harris** — *CMOS VLSI Design*. The reference for the transistor-level treatment in Ch. 1.
- **Sutherland, Davidmann & Flake** — *SystemVerilog for Design*. Practical reference for the SV constructs in Ch. 2.
- **RISC-V International** — [The RISC-V ISA Manual](https://riscv.org/technical/specifications/). The official spec. Ch. 2 covers RV32I.
- **Tiny Tapeout Docs** — [tinytapeout.com](https://tinytapeout.com). Submission flow, `info.yaml`, CI pipeline.
- **cocotb Docs** — [docs.cocotb.org](https://docs.cocotb.org). The reference for Ch. 3.
- **HDLBits** — [hdlbits.01xz.net](https://hdlbits.01xz.net). 200+ browser-based Verilog exercises. Essential companion to Chs. 2–3.
- **OpenROAD** — [openroad.readthedocs.io](https://openroad.readthedocs.io). Open-source RTL-to-GDS toolchain used in Ch. 5.
- **IHP SG13G2 PDK** — [github.com/IHP-GmbH/IHP-Open-PDK](https://github.com/IHP-GmbH/IHP-Open-PDK). The 130nm process used by Tiny Tapeout.