`timescale 1ns / 1ps

module not_dataflow (
    input wire a,
    output wire y
);

    assign y = ~a;

endmodule