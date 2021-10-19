`include "transaction.sv"

class generator;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2che;

  // Define transaction
    transaction tra;

  // Define constraints
  constraint test_1 {
    tra.operation dist {[0:7]:=1};
  }
  constraint test_2 {
    tra.operation == 'b010;
    'unsigned(tra.A) < 'unsigned(tra.B);
  }
  constraint test_3 {
    tra.B == 'h55;
    tra.operation == 'b101;
  }
  constraint test_4 {
    tra.flags_in[0] == 'b1;
    tra.operation == 'b001;
  }
  constraint test_5 {
    tra.operation dist {7 := 1, [0:6] :/ 4};
  }

  function new(mailbox #(transaction) g2d, mailbox #(transaction) g2c);
    this.gen2drv = g2d;
    this.gen2che = g2c;
  endfunction : new

  task run(int test_case);
    transaction tra;

    $timeformat(-9,0," ns" , 10);

    forever begin
      tra = this.generateTransaction(test_case);
      $display("[%t | GEN] Generated transaction: %s", $time, tra.toString());

      this.gen2drv.put(tra);
      this.gen2che.put(tra);
    end
  endtask : run

  function transaction generateTransaction(int test_case);
    // Create transaction
    tra = new();

    // Turn off all constraints
    test_1.constraint_mode(0);
    test_2.constraint_mode(0);
    test_3.constraint_mode(0);
    test_4.constraint_mode(0);
    test_5.constraint_mode(0);

    // Turn on the desired constraint
    case (test_case):
      1: test_1.constraint_mode(1);
      2: test_2.constraint_mode(1);
      3: test_3.constraint_mode(1);
      4: test_4.constraint_mode(1);
      5: test_5.constraint_mode(1);
    endcase

    // Randomise
    void'(tra.randomise());
    tra.updateOutputs();

    return tra;
  endfunction : generateTransaction

endclass : generator
