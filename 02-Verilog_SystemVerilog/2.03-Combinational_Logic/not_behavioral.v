`timescale 1ns / 1ps

module not_behavioral (
    input wire a,
    output reg y
);

    always @(*) begin
        y = a;
    end

endmodule