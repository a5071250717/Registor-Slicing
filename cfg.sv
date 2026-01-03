class rv_cfg extends uvm_object;
  `uvm_object_utils(rv_cfg)
  int unsigned data_w;
  function new(string name = "new");
    super.new(name);
  endfunction
endclass

