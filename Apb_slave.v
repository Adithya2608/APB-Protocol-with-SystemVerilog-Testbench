module apb_slave(
    input  wire        pclk,
    input  wire        preset_n,
    input  wire [31:0] paddr,
    input  wire        pwrite,
    input  wire        psel,
    input  wire        penable,
    input  wire [31:0] pwdata,
    output reg [31:0]  prdata,
    output reg         pready,
    output reg         pslverr
);
    reg [31:0] mem [0:255];
    wire access = psel & penable;
    wire addr_err = (paddr[31:8] != 0);

    always @(posedge pclk or negedge preset_n) begin
        if (!preset_n) begin
            pready  <= 0;
            prdata  <= 0;
            pslverr <= 0;
        end else if (access) begin
            pready  <= 1;
            if (addr_err) begin
                pslverr <= 1;
                prdata  <= 32'h0;
            end else if (pwrite) begin
                mem[paddr[7:2]] <= pwdata;
                pslverr <= 0;
            end else begin
                prdata  <= mem[paddr[7:2]];
                pslverr <= 0;
            end
        end else begin
            pready  <= 0;
            pslverr <= 0;
        end
    end
endmodule
