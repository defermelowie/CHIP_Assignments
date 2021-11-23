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

        byte valid;
        byte prev_valid;

        $display($sformatf("[%t | MON] Started monitoring", $time));

        forever begin
            prev_valid = valid;
            @(posedge this.ifc.clock);
            valid = ifc.valid;
            if (prev_valid) begin
                probe = new(ifc.probe);
                //$display("[%t | MON] Recieved: Opcode: %02x", $time, ifc.opcode);
                //$display("[%t | MON] Recieved: %s opcode: %02x", $time, probe.toString(), ifc.opcode);
                mon2che.put(probe);
            end
        end
    endtask : run

endclass : gbp_monitor

`endif