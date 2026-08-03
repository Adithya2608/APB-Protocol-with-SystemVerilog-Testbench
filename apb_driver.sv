`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver extends uvm_driver #(apb_transaction);

    `uvm_component_utils(apb_driver)

    // Virtual interface
    virtual apb_if vif;

    // Transaction handle
    apb_transaction tr;

    // Constructor
    function new(string name = "apb_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(virtual apb_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRIVER", "Virtual Interface not found")
    endfunction

    // Run Phase
    task run_phase(uvm_phase phase);

        forever begin

            seq_item_port.get_next_item(tr);

            drive_transfer(tr);

            seq_item_port.item_done();

        end

    endtask

    // APB Transfer
    task drive_transfer(apb_transaction tr);

        // -------------------------
        // SETUP PHASE
        // -------------------------
        @(posedge vif.PCLK);

        vif.PSEL    <= 1'b1;
        vif.PENABLE <= 1'b0;
        vif.PWRITE  <= tr.pwrite;
        vif.PADDR   <= tr.paddr;
        vif.PWDATA  <= tr.pwdata;

        // -------------------------
        // ACCESS PHASE
        // -------------------------
        @(posedge vif.PCLK);

        vif.PENABLE <= 1'b1;

        // Wait until slave is ready
        while(!vif.PREADY)
            @(posedge vif.PCLK);

        // Read operation
        if(!tr.pwrite)
            tr.prdata = vif.PRDATA;

        // Capture response
        tr.pready  = vif.PREADY;
        tr.pslverr = vif.PSLVERR;

        // -------------------------
        // IDLE
        // -------------------------
        @(posedge vif.PCLK);

        vif.PSEL    <= 0;
        vif.PENABLE <= 0;
        vif.PWRITE  <= 0;
        vif.PADDR   <= 0;
        vif.PWDATA  <= 0;

    endtask

endclass

`endif
