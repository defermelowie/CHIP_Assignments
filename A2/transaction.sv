`ifndef ALU_TRAN
`define ALU_TRAN

class transaction;

  byte A;
  byte B;
  byte Z;
  bit [2:0] operation;
  bit [3:0] flags_in;
  bit [3:0] flags_out;

  function new(byte A, byte B, bit[3:0] flags_in, bit[2:0] operation, byte Z, bit[3:0] flags_out);
    this.A = A;
    this.B = B;
    this.Z = Z;
    this.operation = operation;
    this.flags_in = flags_in;
    this.flags_out = flags_out;
  endfunction : new

  function string toString();
    return $sformatf("A: %02x, B: %02x, flags_in: %01x, operation: %01x, Z: %02x, flags_out: %01x", this.A, this.B, this.flags_in, this.operation, this.Z, this.flags_out);
  endfunction : toString

endclass : transaction

`endif