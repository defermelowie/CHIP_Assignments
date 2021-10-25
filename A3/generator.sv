`include "transaction.sv"

class generator;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che;

  function new(mailbox #(transaction) g2d, mailbox #(transaction) g2c);
    this.gen2drv = g2d;
    this.gen2che = g2c;
  endfunction : new

  task run(int test_case);
    transaction trans;
    $display("[%t | GEN] Started running test %d", $time, test_case);
    forever begin
      trans = this.generateTransaction(test_case);
      //$display("[%t | GEN] Generated transaction: %s", $time, trans.toString());

      this.gen2drv.put(trans);
      this.gen2che.put(trans);
    end
  endtask : run

  function transaction generateTransaction(int test_case);
    // Create transaction
    transaction tra = new(0, 0, 4'b0, 3'b0, 0, 4'b0);
    // Set test case
    tra.setTest(test_case);
    // Randomise
    void'(tra.randomize());
    tra.updateOutputs();

    return tra;
  endfunction : generateTransaction

endclass : generator
