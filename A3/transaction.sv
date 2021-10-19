`ifndef ALU_TRAN
`define ALU_TRAN
/*
Transaction class: Should map to interface of DUT
*/
class transaction;

  rand byte A;
  rand byte B;
  byte Z;
  rand bit [2:0] operation;
  rand bit [3:0] flags_in;
  bit [3:0] flags_out;

  function new();
    this.A = 0;
    this.B = 0;
    this.Z = 0;
    this.operation = 3'b0;
    this.flags_in = 4'b0;
    this.flags_out = 4'b0;
  endfunction : new

  function string toString();
    return $sformatf("A: %02x, B: %02x, flags_in: %01x, operation: %01x, Z: %02x, flags_out: %01x", this.A, this.B, this.flags_in, this.operation, this.Z, this.flags_out);
  endfunction : toString

  function updateOutputs;
    shortint a, b, z;
    a = unsigned'(this.A);
    b = unsigned'(this.B);

    case (operation)
      'b000: begin
        z = (a + b) % 256;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b0; // subtract flag (always clear in addition)
        this.flags_out[1] = ( (((a%16) + (b%16)) > 15) ? 1'b1 : 1'b0 ); // half carry flag
        this.flags_out[0] = ( ((a + b) > z) ? 1'b1 : 1'b0); // carry flag
      end
      'b001: begin
        z = (a + b + this.flags_in[0]) % 256;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b0; // subtract flag (always clear in addition)
        this.flags_out[1] = ( (((a%16) + (b%16)) > 15) ? 1'b1 : 1'b0 ); // half carry flag
        this.flags_out[0] = ( ((a + b) > z) ? 1'b1 : 1'b0); // carry flag
      end
      'b010: begin
        z = (a - b) % 256;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b1; // subtract flag (always set in subtraction)
        this.flags_out[1] = ( ((a%16) < (b%16)) ? 1'b1 : 1'b0 ); // half carry flag
        this.flags_out[0] = ( (a < b) ? 1'b1 : 1'b0); // borrow flag
      end
      'b011: begin
        z = (a - b + this.flags_in[0]) % 256;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b1; // subtract flag (always set in subtraction)
        this.flags_out[1] = ( ((a%16) < (b%16)) ? 1'b1 : 1'b0 ); // half carry flag
        this.flags_out[0] = ( (a < b) ? 1'b1 : 1'b0); // borrow flag
      end
      'b100: begin
        z = a && b;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b0; // subtract flag
        this.flags_out[1] = 1'b1; // half carry flag
        this.flags_out[0] = 1'b0) // carry flag
      end
      'b101: begin
        z = (a || b) && !(a && b);
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b0; // subtract flag
        this.flags_out[1] = 1'b0; // half carry flag
        this.flags_out[0] = 1'b0) // carry flag
      end
      'b110: begin
        z = a || b;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b0; // subtract flag
        this.flags_out[1] = 1'b0; // half carry flag
        this.flags_out[0] = 1'b0) // carry flag
      end
      'b111: begin
        z = (a - b) % 256;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b1; // subtract flag (always set in subtraction)
        this.flags_out[1] = ( ((a%16) < (b%16)) ? 1'b1 : 1'b0 ); // half carry flag
        this.flags_out[0] = ( (a < b) ? 1'b1 : 1'b0); // borrow flag
      end
    endcase

    this.Z = byte'(z);
  endfunction

endclass : transaction

`endif