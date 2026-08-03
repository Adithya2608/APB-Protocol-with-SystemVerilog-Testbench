`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Interface
`include "apb_if.sv"

// Transaction
`include "apb_transaction.sv"

// Sequence
`include "apb_sequence.sv"

// Sequencer
`include "apb_sequencer.sv"

// Driver
`include "apb_driver.sv"

// Monitor
`include "apb_monitor.sv"

// Agent
`include "apb_agent.sv"

// Scoreboard
`include "apb_scoreboard.sv"

// Environment
`include "apb_env.sv"

// Test
`include "apb_test.sv"

// DUT
`include "apb_slave.sv"

module tb_top;

    //-----------------------------------------
    // Clock
    //-----------------------------------------

    logic PCLK;

    initial
        PCLK = 0;

    always #5 PCLK = ~PCLK;

    //-----------------------------------------
    // Interface
    //-----------------------------------------

    apb_if apb_vif(PCLK);

    //-----------------------------------------
    // DUT
    //-----------------------------------------

    apb_slave dut(

        .PCLK(PCLK),
        .PRESETn(apb_vif.PRESETn),

        .PSEL(apb_vif.PSEL),
        .PENABLE(apb_vif.PENABLE),
        .PWRITE(apb_vif.PWRITE),

        .PADDR(apb_vif.PADDR),
        .PWDATA(apb_vif.PWDATA),

        .PRDATA(apb_vif.PRDATA),
        .PREADY(apb_vif.PREADY),
        .PSLVERR(apb_vif.PSLVERR)

    );

    //-----------------------------------------
    // Reset
    //-----------------------------------------

    initial begin

        apb_vif.PRESETn = 0;

        #20;

        apb_vif.PRESETn = 1;

    end

    //-----------------------------------------
    // Pass Virtual Interface
    //-----------------------------------------

    initial begin

        uvm_config_db #(virtual apb_if)::set(
            null,
            "*",
            "vif",
            apb_vif
        );

    end

    //-----------------------------------------
    // Start UVM
    //-----------------------------------------

    initial begin

        run_test("apb_test");

    end

endmodule
