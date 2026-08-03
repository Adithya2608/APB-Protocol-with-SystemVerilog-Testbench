`ifndef APB_AGENT_SV
`define APB_AGENT_SV

class apb_agent extends uvm_agent;

    `uvm_component_utils(apb_agent)

    // Components
    apb_sequencer seqr;
    apb_driver    drv;
    apb_monitor   mon;

    // Constructor
    function new(string name = "apb_agent",
                 uvm_component parent);
        super.new(name,parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        seqr = apb_sequencer::type_id::create("seqr", this);
        drv  = apb_driver   ::type_id::create("drv", this);
        mon  = apb_monitor  ::type_id::create("mon", this);

    endfunction

    // Connect Phase
    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        drv.seq_item_port.connect(seqr.seq_item_export);

    endfunction

endclass

`endif
