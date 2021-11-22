`ifndef SV_OPCODE
`define SV_OPCODE

class opcode;
    rand byte opcode;

    /******************
    *   Constraints   *
    *******************/
    // SOURCE: https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html

    // ALU
    constraint ALU_opcode {
        (opcode[7:4] inside {'h8, 'hb});
    }

    // Arithmetic
    constraint arithmetic {
        (opcode[7:4] inside {'h8, 'h9});
    }
    
    // Logical
    constraint logical {
        (opcode[7:4] inside {'ha, 'hb});
    }

    /******************
    *   Constructor   *
    *******************/
    function new();
        this.opcode = 0;
        arithmetic.constraint_mode(0);
        logical.constraint_mode(0);
        ALU_opcode.constraint_mode(1);
    endfunction //new()
endclass //opcode

`endif