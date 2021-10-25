class scoreboard;

  mailbox #(byte) che2scb;

  int no_tests_done;
  int no_tests_ok;
  int no_tests_nok;

  function new(mailbox c2s);
    this.che2scb = c2s;
    no_tests_done = 0;
    no_tests_ok = 0;
    no_tests_nok = 0;
  endfunction : new


  task run(int NOT);  
    byte result;
    int NOT_done = 0;

    while (NOT_done < NOT)
    begin
      this.che2scb.get(result);

      NOT_done++; 
      
      if (result > 0)
      begin 
        no_tests_ok++; 
        //$display("[%t | SCB] successful test registered", $time);
      end else begin
        no_tests_nok++;
        //$display("[%t | SCB] unsuccessful test registered", $time);
      end
    end /* while*/
    no_tests_done = no_tests_done + NOT_done;
  endtask : run


  task showReport;
    $display("\n[%t | SCB] Test report", $time);
    $display("[SCB] ---------------------");
    $display("[SCB] # tests done         : %0d", this.no_tests_done);
    $display("[SCB] # tests ok           : %0d", this.no_tests_ok);
    $display("[SCB] # tests failed       : %0d", this.no_tests_nok);
    $display("[SCB] # tests success rate : %0.2f", this.no_tests_ok*100.0/this.no_tests_done);
  endtask : showReport

  task flush_che2scb;
    byte result;
    while (this.che2scb.try_get(result));
  endtask : flush_che2scb

endclass : scoreboard