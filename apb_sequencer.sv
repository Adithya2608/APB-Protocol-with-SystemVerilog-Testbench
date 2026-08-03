`ifndef APB_SEQUENCER_SV
`define APB_SEQUENCER_SV

class apb_sequencer extends uvm_sequencer #(apb_transaction);

    `uvm_component_utils(apb_sequencer)

    // Constructor
    function new(string name = "apb_sequencer",
                 uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

`endif
