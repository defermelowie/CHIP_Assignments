`ifndef SV_DRV_GBP
`define SV_DRV_GBP

`include "transaction.sv"
`include "gbp_iface.sv"

class gbp_driver;

    virtual gbp_iface ifc;
    mailbox #(opcode) gen2drv;

    function new(virtual gbp_iface ifc, mailbox #(opcode) gen2drv);
        this.ifc = ifc;
        this.gen2drv = gen2drv;
    endfunction : new

    task run;
        opcode opcode;
        $display($sformatf("[%t | DRV] Started driving", $time));

        forever begin
            int data_available = this.gen2drv.try_get(opcode);

            @(negedge this.ifc.clock);

            if(data_available) begin
                this.ifc.opcode <= opcode.opcode;
                this.ifc.valid <= 1;
                $display("[%t | DRV] Drove opcode: %02x", $time, opcode.opcode);
            end else begin
                this.ifc.valid <= 0;
            end
        end
        
    endtask : run

    task reset();
        @(negedge this.ifc.clock);
        this.ifc.reset <= 1;
        @(negedge this.ifc.clock);
        this.ifc.reset <= 0;
        @(negedge this.ifc.clock);
        $display("[%t | DRV] Drove reset", $time);
    endtask : reset

endclass //gbp_driver

`endif