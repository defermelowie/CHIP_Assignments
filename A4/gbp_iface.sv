`ifndef SV_IFC_GBP
`define SV_IFC_GBP

interface gbp_iface ( 
  input logic clock
);

  logic reset;
  logic [7:0] opcode;
  logic valid;

  logic [2*8-1:0] probe;

endinterface

`endif