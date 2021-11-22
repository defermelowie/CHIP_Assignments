`ifndef SV_CHE
`define SV_CHE

`include "probe.sv"
`include "opcode.sv"
`include "model.sv"

class checkers;

    mailbox #(opcode) gen2che;
    mailbox #(probe) mon2che;
    mailbox #(byte) che2scb;
    gameboyprocessor model;

    function new(mailbox #(opcode) g2c, mailbox #(probe) m2c, mailbox #(byte) c2s, gameboyprocessor mdl);
        this.gen2che = g2c;
        this.mon2che = m2c;
        this.che2scb = c2s;
        this.model = mdl;
    endfunction : new

    task run;
        opcode opcode;
        probe probe;

        forever begin
            this.mon2che.get(probe);
            this.gen2che.get(opcode);

            this.model.executeALUInstruction(opcode.get());
            if (this.model.F == probe.F)
            begin
                this.che2scb.put(byte'(1));
            end else begin
                this.che2scb.put(byte'(0));
                $display("[%t | CHE] Unsuccessful test registered", $time);
                $display("[%t | CHE] Probe: %s", $time, probe.toString());
                model.toString();
            end
        end
    endtask

endclass : checkers
`endif