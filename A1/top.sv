`timescale 1ns/10ps

`include "ALU_interface.sv"

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("%t: TEST FAILED: 0x%0h != 0x%0h", $time, signal, value); \
            $stop; \
        end

module top;
  logic clock=0;

  // Clock generation - 100 MHz
  always #5 clock = ~clock;

  // Instantiate the interface
  ALU_iface ALU_interface (
    .clock(clock)
  );

  // Instantiate the DUT and connect it to the interface
  ALU dut (
    .A(ALU_interface.data_a),
    .B(ALU_interface.data_b),
    .Z(ALU_interface.data_z),
    .flags_in(ALU_interface.flags_in),
    .flags_out(ALU_interface.flags_out),
    .operation(ALU_interface.operation)
  );

  // Provide stimuli
  initial begin
    $timeformat(-9,0," ns" , 5);
    $display("%t: START TEST: add", $time);
    ALU_interface.operation <= 3'b0; // operation mode is addition
    ALU_interface.flags_in <= 4'b0; // operation mode is addition
    ALU_interface.data_b <= 8'h01;    // keep one operand at 0x01
    for (int a = 8'h00; a <= 8'hff; a = a + 1) begin
      ALU_interface.data_a <= a;
      @(posedge clock);
      `assert(ALU_interface.data_z, ALU_interface.data_a + ALU_interface.data_b)
    end
    $display("%t: TEST DONE: add", $time);
  end

endmodule : top