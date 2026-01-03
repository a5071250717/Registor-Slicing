class rv_mon_in extends uvm_monitor;
  `uvm_component_utils(rv_mon_in)
  rv_vif_mon_t vif;
  uvm_analysis_port#(u_64t) ap;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  function void build_phase(uvm_phase phase);
    //使用typedef就沒辦法用rv_vif_t.mon，要用::
    if(!uvm_config_db#(rv_vif_mon_t)::get(this, "", "vif_mon", vif))
      `uvm_fatal("Mon", "can't get vif");
  endfunction
  

  task run_phase(uvm_phase phase);
    @(posedge vif.rstn);
    forever begin
      @(vif.cb_mon);
      if(vif.cb_mon.in_rdy && vif.cb_mon.in_vld)begin
        ap.write( u_64t'(vif.cb_mon.data_in) );
      end
    end
  endtask
  
endclass