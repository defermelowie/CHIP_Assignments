`include "gbp_iface.sv"
`include "test.sv"

`timescale 1ns/100ps

module top;
  logic clock=0;

  // clock generation
  always #1 clock = ~clock;

  // instantiate an interface
  gbp_iface theInterface (
    .clock(clock)
  );

  // instantiate the DUT and connect it to the interface
  gbprocessor dut (
    .reset(theInterface.reset),
    .clock(theInterface.clock),
    .instruction(theInterface.opcode),
    .valid(theInterface.valid),
    .probe(theInterface.probe)
  );

  // SV testing 
  test tst(theInterface);

endmodule : top
