`ifndef SV_ENV
`define SV_ENV

`include "gbp_iface.sv"
`include "gbp_driver.sv"
`include "gbp_monitor.sv"
`include "generator.sv"
`include "checker.sv"
`include "model.sv"
`include "opcode.sv"
`include "probe.sv"
`include "scoreboard.sv"

class environment;

    virtual gbp_iface ifc;

    generator gen;
    gbp_driver drv;
    gbp_monitor mon;
    checkers che;
    scoreboard scb;
    gameboyprocessor mdl;

    mailbox #(opcode) gen2drv;
    mailbox #(opcode) gen2che;
    mailbox #(probe) mon2che;
    mailbox #(byte) che2scb;

    function new(virtual gbp_iface ifc);
        this.ifc = ifc;

        this.gen2drv = new(100);
        this.gen2che = new(100);
        this.mon2che = new(100);
        this.che2scb = new(100);

        this.mdl = new();

        this.gen = new(this.gen2drv, this.gen2che);
        this.drv = new(ifc, this.gen2drv);
        this.mon = new(ifc, this.mon2che);
        this.che = new(this.gen2che, this.mon2che, this.che2scb, this.mdl);
        this.scb = new(this.che2scb);
    endfunction : new

    task flush_mailboxes();
        byte result;
        opcode code;
        probe prob;

        int g2d = 1;
        int g2c = 1;
        int c2s = 1;
        int m2c = 1;

        while (g2d || g2c || c2s || m2c) begin
            g2d = this.gen2drv.try_get(code);
            //$display("[%t | ENV] g2d: %s",$time, (g2d) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
            g2c = this.gen2che.try_get(code);
            //$display("[%t | ENV] g2c: %s",$time, (g2c) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
            c2s = this.che2scb.try_get(result);
            //$display("[%t | ENV] c2s: %s",$time, (c2s) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
            m2c = this.mon2che.try_get(prob);
            //$display("[%t | ENV] m2c: %s",$time, (m2c) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
        end
    endtask : flush_mailboxes

    task run();
    begin
        fork
            begin
                this.drv.reset();
                flush_mailboxes();

                fork
                    this.drv.run();
                    this.che.run();
                    this.mon.run();
                    this.gen.run();
                    this.scb.run_coverage();
                join_any;

                disable fork;

                $display("[%t | ENV] Done", $time);
            end
        join;

        this.scb.showReport();
        $stop;
    end 
    endtask : run

    covergroup cg1 @(posedge ifc.clock);
        c1: coverpoint ifc.valid;
        c2: coverpoint ifc.opcode[5:0];
    endgroup

    cg1 cg_inst = new();

endclass : environment

`endif