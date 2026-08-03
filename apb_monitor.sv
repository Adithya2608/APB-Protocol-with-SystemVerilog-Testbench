`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV

class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    // Virtual Interface
    virtual apb_if vif;

    // Analysis Port
    uvm_analysis_port #(apb_transaction) monitor_port;

    // Transaction Handle
    apb_transaction tr;

    // Constructor
    function new(string name = "apb_monitor",
                 uvm_component parent);
        super.new(name,parent);

        monitor_port = new("monitor_port", this);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
            `uvm_fatal("MONITOR","Virtual Interface Not Found");
    endfunction

    // Run Phase
    task run_phase(uvm_phase phase);

        forever begin

            @(posedge vif.PCLK);

            // Detect APB Access Phase
            if(vif.PSEL && vif.PENABLE) begin

                tr = apb_transaction::type_id::create("tr");

                tr.pwrite  = vif.PWRITE;
                tr.paddr   = vif.PADDR;
                tr.pwdata  = vif.PWDATA;
                tr.prdata  = vif.PRDATA;
                tr.pready  = vif.PREADY;
                tr.pslverr = vif.PSLVERR;

                monitor_port.write(tr);

            end

        end

    endtask

endclass

`endif
