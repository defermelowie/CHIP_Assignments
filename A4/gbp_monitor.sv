`ifndef SV_MON_GBP
`define SV_MON_GBP

`include "probe.sv"

class gbp_monitor;

    virtual ALU_iface ifc;
    mailbox #(probe) mon2che;

    function new(virtual gbp_iface ifc, mailbox #(probe) m2c);
        this.ifc = ifc;
        this.mon2che = m2c;
    endfunction : new

    task run();
        probe probe;

        $display($sformatf("[%t | MON] Started monitoring", $time));

        forever begin
            @(negedge this.ifc.clock);
            probe = new(ifc.probe);
            mon2che.put(probe);
        end
    endtask : run

endclass : gbp_monitor

`endif