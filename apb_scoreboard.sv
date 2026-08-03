`ifndef APB_SCOREBOARD_SV
`define APB_SCOREBOARD_SV

class apb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(apb_scoreboard)

    // Analysis implementation
    uvm_analysis_imp #(apb_transaction, apb_scoreboard) sb_port;

    // Reference Memory
    bit [31:0] mem [256];

    // Constructor
    function new(string name = "apb_scoreboard",
                 uvm_component parent);
        super.new(name, parent);

        sb_port = new("sb_port", this);
    endfunction

    // Write Method
    function void write(apb_transaction tr);

        // WRITE Transaction
        if(tr.pwrite) begin

            mem[tr.paddr] = tr.pwdata;

            `uvm_info("SCOREBOARD",
                      $sformatf("WRITE PASS : ADDR = %0h DATA = %0h",
                                 tr.paddr,
                                 tr.pwdata),
                      UVM_LOW)

        end

        // READ Transaction
        else begin

            if(mem[tr.paddr] == tr.prdata)

                `uvm_info("SCOREBOARD",
                          $sformatf("READ PASS : ADDR = %0h DATA = %0h",
                                     tr.paddr,
                                     tr.prdata),
                          UVM_LOW)

            else

                `uvm_error("SCOREBOARD",
                           $sformatf("READ FAIL : ADDR=%0h Expected=%0h Got=%0h",
                                      tr.paddr,
                                      mem[tr.paddr],
                                      tr.prdata))

        end

    endfunction

endclass

`endif
