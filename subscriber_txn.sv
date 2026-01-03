class rv_subscriber_txn extends uvm_object;
  bit out_vld;
  bit out_rdy;
  `uvm_object_utils_begin(rv_subscriber_txn)
  `uvm_field_int(out_vld, UVM_ALL_ON)
  `uvm_field_int(out_rdy, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "rv_subscriber_txn");
    super.new(name);
  endfunction
endclass