`ifndef SV_GEN
`define SV_GEN

`include "opcode.sv"

class generator;
    mailbox #(opcode) gen2drv;
    mailbox #(opcode) gen2che;

    function new(mailbox #(opcode) g2d, mailbox #(opcode) g2c);
        this.gen2drv = g2d;
        this.gen2che = g2c;
    endfunction

    task run();
        opcode opcode;

        forever begin
            opcode = this.generateOpcode();
            this.gen2drv.put(opcode);
            this.gen2che.put(opcode);
        end
    endtask

    function opcode generateOpcode();
        opcode opcode = new();
        void'(opcode.randomize());
        return opcode;
    endfunction : generateOpcode

endclass : generator
`endif