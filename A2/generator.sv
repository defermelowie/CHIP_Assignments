`include "transaction.sv"

class generator;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che;

  function new(mailbox #(transaction) g2d, mailbox #(transaction) g2c);
    this.gen2drv = g2d;
    this.gen2che = g2c;
  endfunction : new

  task run;
    transaction tra;

    $timeformat(-9,0," ns" , 10);

    forever begin
      tra = this.generateTransaction();
      $display("[%t | GEN] Generated transaction: %s", $time, tra.toString());

      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end
  endtask : run

  function transaction generateTransaction;
    byte A, B, Z;
    bit [2:0] operation;
    bit [3:0] flags_in;
    bit [3:0] flags_out;

    transaction tra;

    /* for now only generate addition w.o. carry */
    A = 20;
    B = 40;
    Z = (A + B) % 256;
    operation = 3'b0;
    flags_in = 4'b0;
    flags_out = (((A+B)>Z) ? 4'b1000 : 4'b0000);  //TODO: Correct this

    tra = new(A, B, flags_in, operation, Z, flags_out);

    return tra;
  endfunction : generateTransaction

endclass : generator
