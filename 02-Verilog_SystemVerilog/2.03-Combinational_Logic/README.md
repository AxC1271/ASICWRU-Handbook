# 2.02 - Combinational Logic in Verilog

There are different ways of writing a circuit in Verilog. We will outline these as:

* Structural
* Behavioral
* Dataflow

Let's go over a code snippet of the simple inverter that we've explored deeply in Chapter 1:

```Verilog
module not_structural (
    input wire a,
    output wire y
);

    not (y, a);

endmodule
```

This is a structural implementation of the inverter gate. Notice what structural means in this context: instantiating modules and physically connecting the wires to where they should be. The `not` keyword here is a Verilog primitive; Verilog provides primitive logic gates so you don't have to write one from scratch. 

```Verilog
module not_dataflow (
    input wire a,
    output wire y
);
    assign y = ~a;
endmodule
```

This is the dataflow implementation, which is defined by the `assign` statements. The `~` in this situation is treated as if it were a **!** expression in traditional programming languages. It takes whatever a is and performs a bitwise not (also known as a 1's complement), essentially flipping it.

```Verilog
module not_behavioral (
    input wire a,
    output reg y
);
    always @(*) begin
        y <= a; 
    end

endmodule
```

Notice the `always` block being used here. This is one of the most common constructs that you'll use in Verilog. Let's break down what every part of it means:

```Verilog
always @(*) begin
    // your code runs whenever any input changes
end

always @(posedge clk) begin
    // your code runs only on the posedge of clk
end

always @(a, b, c) begin
    // your code runs only when a, b, or c change
end
```

I personally don't like memorizing specifically what these Verilog coding styles are; 



