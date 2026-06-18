# 2.01 - Hardware Description Languages (HDLs)

In Chapter 1, we looked at how digital logic can be implemened through gates, switches, and transistors. Now, we need a way to describe the circuits that we've learned from the previous chapter using code. That's where the Hardware Description Languages (HDLs) come in!

In short, HDLs are used for the design, simulation, and verification of electronic circuits such as Application Specific Integrated Circuits (ASICs) and Field Programmable Gate Arrays (FPGAs). There are three main HDLs that are widely used: **Verilog, SystemVerilog,** and **VHDL**. Verilog has a C-Like syntax which may make it easier to understand if you have previous programming experience. SystemVerilog is the current industry standard HDL and it builds on Verilog by introducing more data types, object oriented programming, and advanced verification features. For this handbook, we will be mostly working with Verilog and writing simple RTL code, with SystemVerilog brought up when it helps compare the two languages.

We will also be referencing HDLBits to guide us for some of the examples and exercises that you will be coming across in this chapter. 
[bits.01xz.net/wiki/Main_Page](bits.01xz.net/wiki/Main_Page)

# Hardware Description Languages vs Programming Languages

While Verilog has similar syntax with the programming language C, they behave differently and for different purposes. Programming languages such as C, Python, and Java execute their lines of code **sequentially** whereas all the lines of code in a HDL execute in **parallel**. 

A good example is seeing how X = A, Y = X behaves between Verilog and C.
