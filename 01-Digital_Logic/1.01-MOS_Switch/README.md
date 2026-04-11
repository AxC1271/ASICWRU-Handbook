# 1.1 — The MOS Switch

Every logic gate in your computer, your phone, and every chip you will ever design is built from one primitive: the MOS transistor. Before we talk about gates or circuits, we need to understand this device — not at the physics level, but at the behavioral level. What does it do, and why does it matter?

A MOS transistor is a voltage-controlled switch. There are two types:

- **NMOS**: the switch closes (conducts) when the gate voltage is high
- **PMOS**: the switch closes (conducts) when the gate voltage is low



## Concepts

- NMOS and PMOS as voltage-controlled switches
- Gate, drain, and source terminals
- Pull-up (toward Vdd) vs pull-down (toward Gnd) behavior
- Why complementary pairs eliminate static power dissipation

## Exercises

**1.** An NMOS transistor has its gate connected to VDD. Is it on or off?
What about a PMOS with its gate connected to VDD?

<details>
<summary>Answer</summary>

NMOS: on (conducting). Gate is high, switch closes, path to GND is active.
PMOS: off (not conducting). Gate is high, switch opens, path to VDD is broken.

</details>

---

**2.** If you connect the drain of an NMOS to VDD and the source to GND, with
the gate floating, what is the output? Why is a floating gate dangerous in
a real circuit?

<details>
<summary>Answer</summary>

With a floating gate the transistor is in an undefined state — it may partially
conduct depending on ambient charge. In real circuits a floating gate can lead
to shoot-through current (both NMOS and PMOS partially on simultaneously),
unpredictable logic levels, and latch-up. Gates should always be driven to a
defined voltage.

</details>

---

**3.** [challenge] A single NMOS transistor is sometimes used as a pass
transistor to route a signal. What's the problem with using NMOS alone to
pass a logic high? What about PMOS alone to pass a logic low?

<details>
<summary>Answer</summary>

NMOS passes logic low (GND) well but degrades logic high — it can only pull
the output to VDD minus its threshold voltage (VDD - Vt), not a full VDD.
PMOS has the opposite problem: it passes logic high well but degrades logic
low. This is why transmission gates use both NMOS and PMOS in parallel —
one handles the high, the other handles the low.

</details>