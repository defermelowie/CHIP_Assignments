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
        byte A;
        byte prev_A;
        byte flags;
        byte prev_flags;

        $display($sformatf("[%t | MON] Started monitoring", $time));

        forever begin
            prev_A = A;
            prev_valid = valid;
            prev_flags = flags;
            @(negedge this.ifc.clock);
            valid = ifc.valid;
            A = ifc.probe[15:8];
            flags = ifc.probe[7:0];
            probe = new({prev_A, flags});
            if (valid) begin
                $display("[%t | MON] Recieved: Opcode: %02x", $time, ifc.opcode);
                $display("[%t | MON] Recieved: %s", $time, probe.toString());
                mon2che.put(probe);
            end
        end
    endtask : run

endclass : gbp_monitor

`endif