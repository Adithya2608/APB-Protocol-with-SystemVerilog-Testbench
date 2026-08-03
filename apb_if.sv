`ifndef APB_IF_SV
`define APB_IF_SV

interface apb_if(input logic PCLK);

    logic PRESETn;

    // APB Signals
    logic        PSEL;
    logic        PENABLE;
    logic        PWRITE;

    logic [31:0] PADDR;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;

    logic        PREADY;
    logic        PSLVERR;

endinterface

`endif
