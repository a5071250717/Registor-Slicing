class rv_agt extends uvm_agent;
  `uvm_component_utils(rv_agt)
  rv_drv_source drv_source;
  rv_drv_sink drv_sink;
  rv_mon_in mon_in;
  rv_mon_out mon_out;
  rv_sqr sqr;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGT", $sformatf("build_phase %s", get_full_name()), UVM_NONE)
    `uvm_info("AGT", $sformatf("BUILD %s (%s:%0d)", get_full_name(), `__FILE__, `__LINE__), UVM_NONE)
    drv_source = rv_drv_source::type_id::create("drv_source", this);
    drv_sink = rv_drv_sink::type_id::create("drv_sink", this);
    mon_in = rv_mon_in::type_id::create("mon_in", this);
    mon_out = rv_mon_out::type_id::create("mon_out", this);
    sqr = rv_sqr::type_id::create("sqr", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv_source.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass