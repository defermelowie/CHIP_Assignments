`ifndef SV_OPCODE
`define SV_OPCODE

class opcode;
    rand byte opcode;

    /******************
    *   Constraints   *
    *******************/
    // SOURCE: https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html

    // Arithmetic
    constraint arithmetic {
        (opcode[7:4] inside {'h8, 'h9});
    }

    constraint add {
        opcode[7:4] == 'h8;
        opcode[3] == 'b0;
    }

    constraint adc {
        opcode[7:4] == 'h8;
        opcode[3] == 'b1;
    }

    constraint sub {
        opcode[7:4] == 'h9;
        opcode[3] == 'b0;
    }

    constraint sbc {
        opcode[7:4] == 'h9;
        opcode[3] == 'b1;
    }
    
    // Logical
    constraint logical {
        (opcode[7:4] inside {'ha, 'hb});
    }


    constraint and {
        opcode[7:4] == 'ha;
        opcode[3] == 'b0;
    }

    constraint xor {
        opcode[7:4] == 'ha;
        opcode[3] == 'b1;
    }

    constraint or {
        opcode[7:4] == 'hb;
        opcode[3] == 'b0;
    }

    constraint cp {
        opcode[7:4] == 'hb;
        opcode[3] == 'b1;
    }

    /******************
    *   Constructor   *
    *******************/
    function new();
        this.opcode = 0;
    endfunction //new()
endclass //opcode

`endif