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

    $display($sformatf("[%t | DRV] I will start driving", $time));
    
    forever begin
      int data_aviable = this.gen2drv.try_get(tra);  // INFO: Blocking function

      @(negedge this.ifc.clock);

      if(data_aviable) begin
        this.ifc.data_a <= tra.A;
        this.ifc.data_b <= tra.B;
        this.ifc.flags_in <= tra.flags_in;
        this.ifc.operation <= tra.operation;
      end else begin
        this.ifc.data_a <= 0;
        this.ifc.data_b <= 0;
        this.ifc.flags_in <= 0;
        this.ifc.operation <= 0;
      end
    end

    $display($sformatf("[%t | DRV] done", $time));
         
  endtask : run_addition

endclass : driver
