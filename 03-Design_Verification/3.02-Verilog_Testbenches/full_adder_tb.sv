// full_adder_tb.sv
`timescale 1ns / 1ps

module full_adder_tb;

    // -------------------------------------------------------------------------
    // Signal declarations
    // Inputs to the DUT are driven by the testbench, so they're logic (reg)
    // Outputs from the DUT are read by the testbench, so they're logic (wire)
    // -------------------------------------------------------------------------
    logic a, b, cin;
    logic sum, cout;

    // -------------------------------------------------------------------------
    // DUT instantiation
    // -------------------------------------------------------------------------
    full_adder dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );

    // -------------------------------------------------------------------------
    // Stimulus and checking
    // -------------------------------------------------------------------------
    initial begin
        // Dump waveforms to a VCD file for GTKWave
        $dumpfile("full_adder.vcd");
        $dumpvars(0, full_adder_tb);

        $display("=== Full Adder Exhaustive Test ===");

        // Test all 8 input combinations
        // Format: {a, b, cin} -> expected {cout, sum}
        {a, b, cin} = 3'b000; #10;
        check(2'b00);

        {a, b, cin} = 3'b001; #10;
        check(2'b01);

        {a, b, cin} = 3'b010; #10;
        check(2'b01);

        {a, b, cin} = 3'b011; #10;
        check(2'b10);

        {a, b, cin} = 3'b100; #10;
        check(2'b01);

        {a, b, cin} = 3'b101; #10;
        check(2'b10);

        {a, b, cin} = 3'b110; #10;
        check(2'b10);

        {a, b, cin} = 3'b111; #10;
        check(2'b11);

        $display("=== Test Complete ===");
        $finish;
    end

    // -------------------------------------------------------------------------
    // Self-checking task
    // A task lets us reuse checking logic without repeating it 8 times
    // -------------------------------------------------------------------------
    task check(input logic [1:0] expected);
        // expected[1] = cout, expected[0] = sum
        if ({cout, sum} !== expected) begin
            $error("FAIL: a=%b b=%b cin=%b | got cout=%b sum=%b | expected cout=%b sum=%b",
                    a, b, cin, cout, sum, expected[1], expected[0]);
        end else begin
            $display("PASS: a=%b b=%b cin=%b | cout=%b sum=%b",
                      a, b, cin, cout, sum);
        end
    endtask

endmodule