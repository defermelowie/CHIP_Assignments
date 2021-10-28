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

  task flush_mailboxes();
    transaction result;
    int g2d = 1;
    int g2c = 1;
    int c2s = 1;
    int m2c = 1;

    while (g2d || g2c || c2s || m2c) begin
        g2d = this.gen2drv.try_get(result);
        $display("[ENV] g2d: %s", (g2d) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
        g2c = this.gen2che.try_get(result);
        $display("[ENV] g2c: %s", (g2c) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
        c2s = this.che2scb.try_get(result);
        $display("[ENV] c2s: %s", (c2s) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
        m2c = this.mon2che.try_get(result);
        $display("[ENV] m2c: %s", (m2c) ? $sformatf("Not empty: %s", result.toString()) : "Empty");
      end
  endtask : flush_mailboxes

  task run();
    begin      
      // First test
      fork
        begin
          flush_mailboxes();

          fork
            this.drv.run_addition();
            this.che.run();
            this.mon.run();
          join_none;

          repeat (10) @(posedge this.ifc.clock);

          fork
            this.gen.run(1);
            this.scb.run(100);
          join_any;

          disable fork;

          $display("[ENV] test 1: done");
        end
      join;

      // Second test
      fork
        begin
          flush_mailboxes();

          fork
            this.drv.run_addition();
            this.che.run();
            this.mon.run();
          join_none;

          repeat (10) @(posedge this.ifc.clock);

          fork
            this.gen.run(2);
            this.scb.run(100);
          join_any;

          disable fork;

          $display("[ENV] test 2: done");
        end
      join;
      /*
      // Third test
      fork
        begin
          flush_mailboxes();

          fork
            this.drv.run_addition();
            this.che.run();
            this.mon.run();
          join_none;

          repeat (10) @(posedge this.ifc.clock);

          fork
            this.gen.run(3);
            this.scb.run(100);
          join_any;

          disable fork;

          $display("[ENV] test 3: done");
        end
      join;

      // Fourth test
      fork
        begin
          flush_mailboxes();

          fork
            this.drv.run_addition();
            this.che.run();
            this.mon.run();
          join_none;

          repeat (10) @(posedge this.ifc.clock);

          fork
            this.gen.run(4);
            this.scb.run(100);
          join_any;

          disable fork;

          $display("[ENV] test 4: done");
        end
      join;
*/
      repeat (10) @(posedge this.ifc.clock);

      this.scb.showReport();
      $stop;
    end
  endtask : run

endclass : environment
