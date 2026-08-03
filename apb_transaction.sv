`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

class apb_transaction extends uvm_sequence_item;
  
    rand bit        pwrite;
    rand bit [31:0] paddr;
    rand bit [31:0] pwdata;

    bit [31:0] prdata;

    bit pready;
    bit pslverr;

    constraint addr_c {
        paddr[1:0] == 2'b00;
    }

    function new(string name = "apb_transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(apb_transaction)
        `uvm_field_int(pwrite , UVM_ALL_ON)
        `uvm_field_int(paddr  , UVM_ALL_ON)
        `uvm_field_int(pwdata , UVM_ALL_ON)
        `uvm_field_int(prdata , UVM_ALL_ON)
        `uvm_field_int(pready , UVM_ALL_ON)
        `uvm_field_int(pslverr, UVM_ALL_ON)
    `uvm_object_utils_end

endclass

`endif
