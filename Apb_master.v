module apb_master(
    input  wire        pclk,
    input  wire        preset_n,
    output reg [31:0]  paddr,
    output reg         pwrite,
    output reg         psel,
    output reg         penable,
    output reg [31:0]  pwdata,
    input  wire [31:0] prdata,
    input  wire        pready,
    input  wire        pslverr,
    input  wire        req,
    input  wire [31:0] addr,
    input  wire        wr,
    input  wire [31:0] wdata,
    output reg [31:0]  rdata,
    output reg         done,
    output reg         error
);

    typedef enum reg [1:0] { IDLE, SETUP, ACCESS } state_t;
    state_t state, nstate;

    always @(posedge pclk or negedge preset_n) begin
        if (!preset_n) state <= IDLE;
        else           state <= nstate;
    end

    always @* begin
        nstate = state;
        case (state)
            IDLE:   if (req)  nstate = SETUP;
            SETUP:          nstate = ACCESS;
            ACCESS: if (pready) nstate = IDLE;
        endcase
    end

    always @(posedge pclk or negedge preset_n) begin
        if (!preset_n) begin
            paddr   <= 0;
            pwrite  <= 0;
            pwdata  <= 0;
            psel    <= 0;
            penable <= 0;
            rdata   <= 0;
            done    <= 0;
            error   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    paddr   <= addr;
                    pwrite  <= wr;
                    pwdata  <= wdata;
                    psel    <= 0;
                    penable <= 0;
                    done    <= 0;
                    error   <= 0;
                end
                SETUP: begin
                    psel    <= 1;
                    penable <= 0;
                end
                ACCESS: begin
                    penable <= 1;
                    if (pready) begin
                        rdata <= prdata;
                        done  <= 1;
                        error <= pslverr;
                        psel  <= 0;
                        penable <= 0;
                    end
                end
            endcase
        end
    end

endmodule
