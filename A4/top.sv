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
                bins add = {'h10};
                bins adc = {'h11};
                bins sub = {'h12};
                bins sbc = {'h13};
                bins andi = {'h14};
                bins xori = {'h15};
                bins ori = {'h16};
                bins cpi = {'h17};
            }

        register: coverpoint theInterface.opcode[2:0] 
            iff(theInterface.valid){
                bins b = {'h0};
                bins c = {'h1};
                bins d = {'h2};
                bins e = {'h3};
                bins h = {'h4};
                bins l = {'h5};
                bins hl = {'h6};
                bins a = {'h7};
            }

        Z_flag: coverpoint theInterface.probe[7]
            iff(theInterface.valid) {
                bins high = {'b1};
                bins low = {'b0};
            }

        N_flag: coverpoint theInterface.probe[6]
            iff(theInterface.valid) {
                bins high = {'b1};
                bins low = {'b0};
            }

        H_flag: coverpoint theInterface.probe[5]
            iff(theInterface.valid) {
                bins high = {'b1};
                bins low = {'b0};
            }

        C_flag: coverpoint theInterface.probe[4]
            iff(theInterface.valid) {
                bins high = {'b1};
                bins low = {'b0};
            }
            
        cx: cross C_flag, operation{
            bins c_in_adc = binsof(operation.adc) && binsof(C_flag.high)
            bins c_in_sbc = binsof(operation.sbc) && binsof(C_flag.high)
            bins c_in_cpi = binsof(operation.cpi) && binsof(C_flag.high)
        }
    endgroup
  
    cg1 cg_inst = new();

endmodule : top
