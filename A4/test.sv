`include "gbp_iface.sv"
`include "environment.sv"

module test (gbp_iface ifc);

  environment env = new(ifc);

  initial
  begin
    $timeformat(-9,0," ns" , 7);
    env.run();
  end

endmodule : test
