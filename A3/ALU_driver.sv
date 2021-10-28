`include "ALU_iface.sv"
`include "transaction.sv"

class driver;

  virtual ALU_iface ifc;
  mailbox #(transaction) gen2drv;

  function new(virtual ALU_iface ifc, mailbox #(transaction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  
  task run();
    transaction tra;

    $display($sformatf("[%t | DRV] I will start driving", $time));
    
    forever begin
      int data_aviable = this.gen2drv.try_get(tra);  // INFO: Non-blocking function

      @(negedge this.ifc.clock);

      if(data_aviable) begin
        this.ifc.data_a <= tra.A;
        this.ifc.data_b <= tra.B;
        this.ifc.flags_in <= tra.flags_in;
        this.ifc.operation <= tra.operation;
        $display("[%t | DRV] Drove A: %02x, B: %02x, flags_in: %01x, operation: %01x", $time, tra.A, tra.B, tra.flags_in, tra.operation);
      end else begin
        this.ifc.data_a <= 0;
        this.ifc.data_b <= 0;
        this.ifc.flags_in <= 0;
        this.ifc.operation <= 0;
        $display("[%t | DRV] Drove A: 00, B: 00, flags_in: 0, operation: 0", $time);
      end
    end

  endtask : run

  task reset_dut();
    @(negedge this.ifc.clock);
    this.ifc.data_a <= 0;
    this.ifc.data_b <= 0;
    this.ifc.flags_in <= 0;
    this.ifc.operation <= 0;
    $display("[%t | DRV] DUT RESET", $time);
    $display("[%t | DRV] Drove A: 00, B: 00, flags_in: 0, operation: 0", $time);
  endtask

endclass : driver
