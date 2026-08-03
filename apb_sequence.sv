`ifndef APB_SEQUENCE_SV
`define APB_SEQUENCE_SV

class apb_sequence extends uvm_sequence #(apb_transaction);

    `uvm_object_utils(apb_sequence)

    apb_transaction tr;

    function new(string name = "apb_sequence");
        super.new(name);
    endfunction

    virtual task body();

        repeat(20) begin

            tr = apb_transaction::type_id::create("tr");

            start_item(tr);

            assert(tr.randomize());

            finish_item(tr);

        end

    endtask

endclass

`endif
