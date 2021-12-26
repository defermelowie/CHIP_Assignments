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
        // There can max be one HGRANTx be high
        only_one_master: assert ($countones(HGRANTx) <= 1) else $error("%m fail: Granted %d masters", $countones(HGRANTx));
    end

    /* Concurrent Assertions */

    // Grant goes low after ready
    grant_low_after_ready: assert property (@(posedge HCLK) (HREADY |=> HGRANTx == 0)) else $error("%m fail");


endmodule : ahb_arbiter_wrapper
