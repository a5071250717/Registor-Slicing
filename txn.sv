class rv_txn extends uvm_sequence_item;
  rand bit [255:0] data;
  rand int unsigned gap;
  int unsigned w;
  constraint c_bubble{
    gap < 10;
  }
  `uvm_object_utils_begin(rv_txn)
    `uvm_field_int(data,UVM_ALL_ON)
    `uvm_field_int(gap, UVM_ALL_ON)
  `uvm_object_utils_end    
  function new(string name = "rv_txn");
    super.new(name);
  endfunction
endclass