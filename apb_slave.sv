`ifndef APB_SLAVE_SV
`define APB_SLAVE_SV

module apb_slave(

    input  logic        PCLK,
    input  logic        PRESETn,

    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic        PWRITE,

    input  logic [31:0] PADDR,
    input  logic [31:0] PWDATA,

    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic        PSLVERR

);

    // 256 x 32-bit Memory
    logic [31:0] mem [0:255];

    // State Declaration
    typedef enum logic [1:0] {
        IDLE,
        SETUP,
        ACCESS
    } state_t;

    state_t state;

    integer i;

    //----------------------------------------------------
    // State Machine
    //----------------------------------------------------

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if(!PRESETn) begin

            state <= IDLE;

            PREADY  <= 0;
            PRDATA  <= 0;
            PSLVERR <= 0;

            for(i=0;i<256;i=i+1)
                mem[i] <= 0;

        end

        else begin

            case(state)

            //------------------------------------------
            // IDLE
            //------------------------------------------

            IDLE:
            begin
                PREADY  <= 0;
                PSLVERR <= 0;

                if(PSEL)
                    state <= SETUP;
            end

            //------------------------------------------
            // SETUP
            //------------------------------------------

            SETUP:
            begin

                if(PENABLE)
                    state <= ACCESS;

            end

            //------------------------------------------
            // ACCESS
            //------------------------------------------

            ACCESS:
            begin

                PREADY <= 1;

                // Address Range Check
                if(PADDR[31:10] != 0) begin

                    PSLVERR <= 1;

                end

                else begin

                    PSLVERR <= 0;

                    // WRITE
                    if(PWRITE)

                        mem[PADDR[9:2]] <= PWDATA;

                    // READ
                    else

                        PRDATA <= mem[PADDR[9:2]];

                end

                state <= IDLE;

            end

            endcase

        end

    end

endmodule

`endif
