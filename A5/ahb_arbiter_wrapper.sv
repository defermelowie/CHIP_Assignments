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

    /***************************
    *        Assertions        *
    ***************************/

    /* Immediate Assertions */

    initial begin
        // There is maximum one HGRANTx high
        only_one_master: assert ($countones(HGRANTx[15:0]) <= 1) else $error("[%t | %m] fail: Granted %d masters", $time, $countones(HGRANTx[15:0]));
    end

    /* Concurrent Assertions */

    test_m1: assert property (@(posedge HCLK) (HRESETn & ~HGRANTx[1])) else $info("[%t | %m] info: Granted %d masters", $time, $countones(HGRANTx[15:0]));

    // Grant goes low after ready
    grant_low_after_ready: assert property (@(posedge HCLK) (HREADY |=> HGRANTx == 0)) else $error("[%t | %m] fail", $time);

    // SOURCE: "SVA: The Power of Assertions in SystemVerilog" Section 5.4: "S_eventually Property"
    // URL: https://link-springer-com.kuleuven.e-bronnen.be/content/pdf/10.1007%2F978-3-319-07139-8.pdf
    // TODO: Assert grant is always given


endmodule : ahb_arbiter_wrapper
