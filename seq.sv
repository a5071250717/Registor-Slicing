class rv_seq extends uvm_sequence#(rv_txn);
  `uvm_object_utils(rv_seq)
  int unsigned cnt = 0;
  rand int ntimes;
  constraint c_ntims{
    ntimes inside {[1:10]};
  }
  function new(string name = "rv_seq");
    super.new(name);
  endfunction
  
  task body();
    rv_txn txn;
    `uvm_info("SEQ", $sformatf("simulate %0d data", ntimes), UVM_LOW);
    repeat(ntimes)begin
      `uvm_info("SEQ", $sformatf("=====%0d=====", cnt), UVM_LOW);
      `uvm_do(txn);
      //`uvm_info("SEQ", $sformatf("===send %0h, %0d===", txn.data & mask(data_w), txn.gap), UVM_LOW);
      cnt++;
    end
  endtask
endclass