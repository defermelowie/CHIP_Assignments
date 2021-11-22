`ifndef SV_MDL_GAMEBOYPROCESSOR
`define SV_MDL_GAMEBOYPROCESSOR

/* A new class is made for the model :) #DUH */
class gameboyprocessor;

    /* The model contains eight 8-bit registers */
    byte unsigned A;
    byte unsigned B;
    byte unsigned C;
    byte unsigned D;
    byte unsigned E;
    byte unsigned F;
    byte unsigned H;
    byte unsigned L;

    /* Upon creating an object, the registers are initialised. A */
    /* simplication was done, because the LOAD instructions are */
    /* not implemented. Hence, all values are constant (except for */
    /* those of A and F). */
    function new();
        this.A = 0;
        this.B = 1;
        this.C = 2;
        this.D = 3;
        this.E = 4;
        this.F = 0;
        this.H = 5;
        this.L = 6;
    endfunction : new

    /* A simple to string function to consult the internals. */
    task toString();
        $display("REG A : %02X \t\t REG F : %02X", this.A, this.F);
        $display("REG B : %02X \t\t REG C : %02X", this.B, this.C);
        $display("REG D : %02X \t\t REG E : %02X", this.D, this.E);
        $display("REG H : %02X \t\t REG L : %02X", this.H, this.L);
    endtask : toString

    /* This is a getter function to acquire the value of a register. */
    /* Note that the indirect addressing target (HL) is fixed to 0x0 */
    function byte lookup_operand(byte operand);
        byte rv;

        case (operand[3:0])
            3'b000: rv = this.B;
            3'b001: rv = this.C;
            3'b010: rv = this.D;
            3'b011: rv = this.E;
            3'b100: rv = this.H;
            3'b101: rv = this.L;
            3'b110: rv = 0;
            default: rv = this.A;
        endcase

        return rv;
    endfunction : lookup_operand

    /* Here is the bread-and-butter of the model. Similar */
    /* to the DUT, an instruction can be fed to the model. */
    /* The model performs the same operation on its internal */
    /* registers as the DUT. */
    task executeALUInstruction(byte instr);
        shortint a, b, c, z;

        a = unsigned'(this.A);
        b = unsigned'(lookup_operand(instr[2:0]));
        c = unsigned'(this.F[4]);

        case(instr[5:3])
            3'b001: begin
                        z = (a + b + c) % 256;
    					this.F[6] = 1'b0;
    					this.F[5] = ( (((a%16) + (b%16)) + c > 15) ? 1'b1 : 1'b0 );
    					this.F[4] = ( ((a + b + c ) > z) ? 1'b1 : 1'b0);
                    end
            3'b010: begin
                        z = (a - b) % 256;
    					this.F[6] = 1'b1; 
    					this.F[5] = ( ( (b%16) > (a%16) ) ? 1'b1 : 1'b0 ); 
    					this.F[4] = ( ( b > a ) ? 1'b1 : 1'b0 ); 
                    end
            3'b011: begin
                        z = (a - b - c) % 256;
    					this.F[6] = 1'b1; 
    					this.F[5] = ( ( (b%16) + c > (a%16) ) ? 1'b1 : 1'b0 ); 
    					this.F[4] = ( ( b + c > a ) ? 1'b1 : 1'b0 ); 
                    end
            3'b100: begin
                        z = a & b;
    					this.F[6] = 1'b0;
    					this.F[5] = 1'b1;
    					this.F[4] = 1'b0;
                    end
            3'b101: begin
                        z = a ^ b;
    					this.F[6] = 1'b0;
    					this.F[5] = 1'b0;
    					this.F[4] = 1'b0;
                    end
            3'b110: begin
                       z = a | b;
    					this.F[6] = 1'b0;
    					this.F[5] = 1'b0;
    					this.F[4] = 1'b0;
                    end
            3'b111: begin
                        z = (a - b) % 256;
    					this.F[6] = 1'b1;
    					this.F[5] = ( ( (b%16) > (a%16) ) ? 1'b1 : 1'b0 ); 
    					this.F[4] = ( ( b > a ) ? 1'b1 : 1'b0 ); 
                        z = a;
                    end
            default : begin
                        z = (a + b) % 256;
    					this.F[6] = 1'b0; 
    					this.F[5] = ( (((a%16) + (b%16)) > 15) ? 1'b1 : 1'b0 ); 
    					this.F[4] = ( ((a + b) > z) ? 1'b1 : 1'b0); 
                    end
        endcase

        this.F[7] = ((z==0) ? 1'b1 : 1'b0); 

        this.A = byte'(z);

    endtask : executeALUInstruction

    function shortint generate_expected_probe();
        shortint unsigned x;

        x = unsigned'(this.A) * 256;
        x = x + unsigned'(this.F);

        return x;
    endfunction : generate_expected_probe
endclass : gameboyprocessor


/* A small program to test the model */
program test_cpumodel;
    static gameboyprocessor gbmodel;

    initial 
    begin
        /* instantiate model */
        gbmodel = new();

        /* show the initial values of the register file*/
        gbmodel.toString();

        /* ADD  E => A = A + E => A = 0 + 4 = 4 */
        gbmodel.executeALUInstruction(8'h83);

        /* ADD  L => A = A + L => A = 4 + 6 = 10 = 0xA */
        gbmodel.executeALUInstruction(8'h85);

        /* show the final values of the register file*/
        gbmodel.toString();
    end
  
endprogram : test_cpumodel

`endif
