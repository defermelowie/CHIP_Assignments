`ifndef SV_MON_GBP
`define SV_MON_GBP

`include "probe.sv"

class gbp_monitor;

    virtual gbp_iface ifc;
    mailbox #(probe) mon2che;

    function new(virtual gbp_iface ifc, mailbox #(probe) m2c);
        this.ifc = ifc;
        this.mon2che = m2c;
    endfunction : new

    task run();
        probe probe;

        byte A;
        byte prev_A;
        byte flags;

        $display($sformatf("[%t | MON] Started monitoring", $time));

        forever begin
            @(negedge this.ifc.clock);
            prev_A = ifc.probe[15:8];
            flags = ifc.probe[7:0];
            probe = new({A, flags});
            $$display("[%t | MON] Recieved: %s", $time, probe.toString());
            mon2che.put(probe);
        end
    endtask : run

endclass : gbp_monitor

`endif