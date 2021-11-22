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
    /*
    // Logical
    constraint logical {
        (opcode[7:4] inside {'ha, 'hb});
    }*/

    /******************
    *   Constructor   *
    *******************/
    function new();
        this.opcode = 0;
    endfunction //new()
endclass //opcode

`endif