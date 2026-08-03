module apb_master(

    input logic PCLK,
    input logic PRESETn,

    output logic PSEL,
    output logic PENABLE,
    output logic PWRITE,

    output logic [31:0] PADDR,
    output logic [31:0] PWDATA,

    input logic [31:0] PRDATA,
    input logic PREADY,
    input logic PSLVERR

);

typedef enum logic [1:0]
{
    IDLE,
    SETUP,
    ACCESS
} state_t;

state_t state;

always_ff @(posedge PCLK or negedge PRESETn)
begin

    if(!PRESETn)
    begin
        state <= IDLE;

        PSEL <= 0;
        PENABLE <= 0;
        PWRITE <= 0;
        PADDR <= 0;
        PWDATA <= 0;
    end

    else
    begin

        case(state)

        IDLE:
        begin
            PSEL <= 1;
            PENABLE <= 0;
            PWRITE <= 1;

            PADDR <= 32'h10;
            PWDATA <= 32'h12345678;

            state <= SETUP;
        end

        SETUP:
        begin
            PENABLE <= 1;
            state <= ACCESS;
        end

        ACCESS:
        begin

            if(PREADY)
            begin
                PSEL <= 0;
                PENABLE <= 0;

                state <= IDLE;
            end

        end

        endcase

    end

end

endmodule
