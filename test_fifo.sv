class rv_test_fifo extends uvm_test;
  `uvm_component_utils(rv_test_fifo)
  rv_env env;
  rv_seq seq;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = rv_seq::type_id::create("seq", this);
    if(!seq.randomize())
      `uvm_error("TEST", "Can't randomize seq")
    env = rv_env::type_id::create("env", this);
    uvm_factory::get().set_inst_override_by_type(
      rv_scb::get_type(),
      rv_scb_fifo::get_type(),
      "uvm_test_top.env.scb");
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    env.scb.ntimes = seq.ntimes;
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("TEST", "simulation start", UVM_LOW);
    seq.start(env.agt.sqr);
    wait(env.scb.sink_done.triggered);
    `uvm_info("TEST", "simulation finish", UVM_LOW);
    phase.drop_objection(this);
  endtask
endclass