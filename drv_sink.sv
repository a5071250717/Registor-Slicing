class rv_drv_sink extends uvm_driver;
  `uvm_component_utils(rv_drv_sink)
  rv_vif_sink_t vif;
  rv_cfg cfg;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(rv_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("DRV", "Can't get cfg"); 
    //使用typedef就沒辦法用rv_vif_t.dink，要用::
    if(!uvm_config_db#(rv_vif_sink_t)::get(this, "", "vif_sink", vif))
      `uvm_fatal("DRV_SINK", "Can't get vif");
  endfunction
  
  task run_phase(uvm_phase phase);
    @(posedge vif.rstn);
    forever begin
      @(vif.cb_sink);
      vif.cb_sink.out_rdy <= ($urandom_range(1,100) < 50);
    end
  endtask
endclass