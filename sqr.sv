class rv_sqr extends uvm_sequencer#(rv_txn);
  `uvm_component_utils(rv_sqr)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass