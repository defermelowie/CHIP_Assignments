`include "ALU_iface.sv"
`include "transaction.sv"

class driver;

  virtual ALU_iface ifc;
  mailbox #(transaction) gen2drv;

  function new(virtual ALU_iface ifc, mailbox #(transaction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  
  task run_addition();
    transaction tra;

    $timeformat(-9,0," ns" , 10);

    $display($sformatf("[%t | DRV] I will start driving for addition", $time));
    
    forever begin
      this.gen2drv.get(tra);  // INFO: Blocking function

      @(negedge this.ifc.clock);
      this.ifc.data_a <= tra.A;
      this.ifc.data_b <= tra.B;
      this.ifc.flags_in <= tra.flags_in;
      this.ifc.operation <= tra.operation;
    end

    $display($sformatf("[%t | DRV] done", $time));
         
  endtask : run_addition

endclass : driver
