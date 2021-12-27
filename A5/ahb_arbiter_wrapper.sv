/* 
SOURCE: de cursus
    URL: https://kuleuven-diepenbeek.github.io/cdandverif/600_assertions/

SOURCE: SVA: The Power of Assertions in SystemVerilog
    URL: https://link-springer-com.kuleuven.e-bronnen.be/content/pdf/10.1007%2F978-3-319-07139-8.pdf
*/

`timescale 1ns/1ns 

module ahb_arbiter_wrapper (
    input logic HCLK,
    input logic HRESETn,
    input logic [15:0] HBUSREQx,
    input logic [15:0] HLOCKx,
    output logic [15:0] HGRANTx,
    input logic [15:0] HSPLIT,
    input logic HREADY,
    output [3:0] HMASTER,
    output HMASTLOCK
);

    ahb_arbiter ahb_arbiter_inst00 (
        HCLK, HRESETn, 
        HBUSREQx, HLOCKx, HGRANTx, HSPLIT,
        HREADY, HMASTER, HMASTLOCK
    );

    initial begin
        $timeformat(-9,0," ns" , 7);
    end

    /***************************
    *        Assertions        *
    ***************************/

    /* Concurrent Assertions */

    // There is maximum one HGRANTx high
    // SOURCE: "SVA: The Power of Assertions in SystemVerilog" Section 7.1.4: "Number of 1-Bits"
    only_one_master: assert property (@(posedge HCLK) ($countones(HGRANTx) <= 1)) else   $error("[%t | %m] fail: Granted %d masters", $time, $countones(HGRANTx));

    // Grant goes low after ready
    // TODO: Create error constant in DUT
    grant_low_after_ready: assert property (@(posedge HCLK) (HREADY |=> HGRANTx == 0)) else $error("[%t | %m] fail", $time);

    // SOURCE: "SVA: The Power of Assertions in SystemVerilog" Section 5.4: "S_eventually Property"
    reset_is_eventually_deactivated: assert property (@(posedge HCLK) s_eventually HRESETn) else $error("[%t | %m] fail", $time);

    // SOURCE: "SVA: The Power of Assertions in SystemVerilog" Section 5.4: "S_eventually Property"
    grant_is_eventually_given: assert property (@(posedge HCLK) s_eventually HBUSREQx[2] -> HGRANTx[2]) else $error("[%t | %m] fail", $time);

endmodule : ahb_arbiter_wrapper
