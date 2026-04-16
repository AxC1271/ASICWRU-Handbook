# 1.01 — The MOS Switch

Every logic gate in your computer, your phone, and every chip you will ever design is built from one primitive: the MOS transistor. Before we talk about gates or circuits, we need to understand this device — not at the physics level, but at the behavioral level. What does it do, and why does it matter?

For our purposes, a MOS transistor is a voltage-controlled switch with three terminals: a gate, a drain, and a source. The voltage at the gate determines whether the switch is open or closed. That's it. We're going to treat these as ideal switches and not worry about what's happening inside the silicon.

There are two types:

**NMOS** — the switch closes when the gate is connected to VDD (logic high). Think of it as active-high. When the gate sees VDD, current can flow from drain to source.

**PMOS** — the switch closes when the gate is connected to GND (logic low). Think of it as active-low. When the gate sees GND, current can flow from source to drain.

When the switch is open, no current flows and the terminal is disconnected. When the switch is closed, the transistor acts as a short circuit between drain and source.

This asymmetry — NMOS closes high, PMOS closes low — is exactly what makes CMOS work. CMOS stands for Complementary MOS, and "complementary" is the key word. By pairing NMOS and PMOS together, we can build circuits that are always driven to a valid logic level and draw near-zero power in steady state. We'll see exactly how in 1.2.

## Simulation

The exercises in this chapter use **Falstad CircuitJS**, a free browser-based circuit simulator. No installation required — it runs entirely in your browser.

→ [falstad.com/circuit](https://falstad.com/circuit)

CircuitJS was created by Paul Falstad. Full credit and source at
[github.com/pfalstad/circuitjs1](https://github.com/pfalstad/circuitjs1).

For each exercise, a reference screenshot of the correct circuit and output is provided. Try building it yourself first before looking.

 ## Exercises

**1.** In Falstad, place an NMOS transistor. Connect the drain to VDD and the source to a test node. Toggle the gate between VDD and GND. When is there a connection between drain and source? When isn't there?

<details>
<summary>Answer</summary>

Gate = VDD: switch closes, drain and source are connected.
Gate = GND: switch opens, no connection.

[screenshot]

</details>

---

**2.** Do the same for a PMOS transistor. Connect the source to VDD and the drain to a test node. Toggle the gate. When does current flow?

<details>
<summary>Answer</summary>

Gate = GND: switch closes, source and drain are connected.
Gate = VDD: switch opens, no connection.

[screenshot]

</details>

---

**3.** Connect an NMOS transistor with its drain tied to VDD and source to your output node. Drive the gate high. Measure the output voltage. Now do the same with a PMOS — source to VDD, drain to output, gate low. Compare the two output voltages. Which transistor passes VDD cleanly?

<details>
<summary>Answer</summary>

PMOS passes VDD cleanly to the output. NMOS struggles to pass a full VDD — the output is slightly degraded. This is why in CMOS we always use PMOS to pull toward VDD.

[screenshot]

</details>

---

**4.** Now repeat the experiment toward GND. PMOS with source to GND, drain to output, gate high. NMOS with drain to output, source to GND, gate high. Which passes GND cleanly?

<details>
<summary>Answer</summary>

NMOS passes GND cleanly. PMOS degrades it. This is why in CMOS we always use NMOS to pull toward GND.

[screenshot]

</details>