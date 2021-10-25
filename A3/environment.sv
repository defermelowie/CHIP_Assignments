`include "ALU_driver.sv"
`include "ALU_monitor.sv"
`include "ALU_iface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "checker.sv"
`include "scoreboard.sv"

class environment;

  virtual ALU_iface ifc;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2che;
  mailbox #(transaction) gen2che;
  mailbox #(byte) che2scb;

  generator gen;
  driver drv;
  monitor mon;
  checkers che;
  scoreboard scb;


  function new(virtual ALU_iface ifc);
    this.ifc = ifc;

    this.gen2drv = new(100);
    this.gen2che = new(100);
    this.mon2che = new(100);
    this.che2scb = new(100);

    this.gen = new(this.gen2drv, this.gen2che);
    this.drv = new(ifc, this.gen2drv);
    this.mon = new(ifc, this.mon2che);
    this.che = new(this.gen2che, this.mon2che, this.che2scb);
    this.scb = new(this.che2scb);
  endfunction : new

  task run();
    /* start the upstream **********************/
    fork
      this.drv.run_addition();
      this.che.run();
      this.mon.run();  // runs monitor forever
    join_none;

    repeat (10) @(posedge this.ifc.clock);
    
    // Start generator and scoreboard
    fork
      begin
        // First test
        fork
          this.gen.run(1);
          this.scb.run(100);
        join_any;

        disable fork;

        // Second test
        fork
          this.gen.run(2);
          this.scb.run(100);
        join_any;

        disable fork;

        // Third test
        fork
          this.gen.run(3);
          this.scb.run(100);
        join_any;

        disable fork;

        // Fourth test
        fork
          this.gen.run(4);
          this.scb.run(100);
        join_any;

        disable fork;

        // Fifth test
        fork
          this.gen.run(1);
          this.scb.run(100);
        join_any;

        disable fork;
      end
    join;

    disable fork;

    this.scb.showReport();
    $stop;

  endtask : run

endclass : environment
