`include "ALU_iface.sv"
`include "transaction.sv"

class monitor;

  virtual ALU_iface ifc;
  mailbox #(transaction) mon2che;

  function new(virtual ALU_iface ifc, mailbox #(transaction) mon2che);
    this.ifc = ifc;
    this.mon2che = mon2che;
  endfunction : new

  task run();
    transaction tra;

    forever begin
      @(negedge this.ifc.clock);
      tra = new(this.ifc.data_a, this.ifc.data_b, this.ifc.flags_in, this.ifc.operation, this.ifc.data_z, this.ifc.flags_out);
      this.mon2che.put(tra);
    end /* forever */
  endtask : run

endclass : monitor
