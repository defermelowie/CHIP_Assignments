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

  // Define constraints
  constraint illegal_state {
    A || B || Z || flags_in || flags_out || operation == 1;
  }
  constraint test_1 {
    operation dist {[0:7]:=1};
  }
  constraint test_2 {
    operation == 'b010;
    unsigned'(A) < unsigned'(B);
  }
  constraint test_3 {
    B == 'h55;
    operation == 'b101;
  }
  constraint test_4 {
    flags_in[0] == 'b1;
    operation == 'b001;
  }
  constraint test_5 {
    operation dist {7 := 1, [0:6] :/ 4};
  }

function new(byte A, byte B, bit[3:0] flags_in, bit[2:0] operation, byte Z, bit[3:0] flags_out);
    this.A = A;
    this.B = B;
    this.Z = Z;
    this.operation = operation;
    this.flags_in = flags_in;
    this.flags_out = flags_out;
  endfunction : new

  function setTest(int test_case);
    // Turn off all constraints
    test_1.constraint_mode(0);
    test_2.constraint_mode(0);
    test_3.constraint_mode(0);
    test_4.constraint_mode(0);
    test_5.constraint_mode(0);

    // Turn on the desired constraint
    case (test_case)
      1: test_1.constraint_mode(1);
      2: test_2.constraint_mode(1);
      3: test_3.constraint_mode(1);
      4: test_4.constraint_mode(1);
      5: test_5.constraint_mode(1);
    endcase    
  endfunction

  function string toString();
    return $sformatf("A: %02x, B: %02x, flags_in: %01x, operation: %01x, Z: %02x, flags_out: %01x", this.A, this.B, this.flags_in, this.operation, this.Z, this.flags_out);
  endfunction : toString

  function updateOutputs();
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
        this.flags_out[0] = 1'b0; // carry flag
      end
      'b101: begin
        z = (a || b) && !(a && b);
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b0; // subtract flag
        this.flags_out[1] = 1'b0; // half carry flag
        this.flags_out[0] = 1'b0; // carry flag
      end
      'b110: begin
        z = a || b;
        this.flags_out[3] = ((z==0) ? 1'b1 : 1'b0); // zero flag
        this.flags_out[2] = 1'b0; // subtract flag
        this.flags_out[1] = 1'b0; // half carry flag
        this.flags_out[0] = 1'b0; // carry flag
      end
      'b111: begin
        z = a;
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