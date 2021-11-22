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
  
  
    covergroup cg1 @(posedge clock);
        option.at_least = 100;

        operation: coverpoint theInterface.opcode[7:3]
            iff(theInterface.valid) {
                bins add = {'h10}
                bins adc = {'h11}
                bins sub = {'h12}
                bins sbc = {'h13}
            }

        c2: coverpoint theInterface.opcode[3:0] iff(theInterface.valid);
    endgroup
  
    cg1 cg_inst = new();

endmodule : top
