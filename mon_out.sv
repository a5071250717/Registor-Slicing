class rv_mon_out extends uvm_monitor;
  `uvm_component_utils(rv_mon_out)
  rv_vif_mon_t vif;
  uvm_analysis_port#(u_64t) ap;
  uvm_analysis_port#(rv_subscriber_txn) ap_subscriber;
  rv_subscriber_txn s;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
    ap_subscriber = new("ap_subscriber", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //使用typedef就沒辦法用rv_vif_t.mon
    if(!uvm_config_db#(rv_vif_mon_t)::get(this, "", "vif_mon", vif))
      `uvm_fatal("Mon_out", "Can't get vif");
  endfunction
  
  task run_phase(uvm_phase phase);
    @(posedge vif.rstn);
    forever begin
      @(vif.cb_mon);
      // for scb
      if(vif.cb_mon.out_rdy && vif.cb_mon.out_vld)begin
        ap.write(vif.cb_mon.data_out);
        //`uvm_info("MON_OUT", $sformatf("mon out %0h", vif.cb_mon.data_out), UVM_LOW);
      end
      // for subscriber
      s = new("s");
      s.out_vld = vif.cb_mon.out_vld;
      s.out_rdy = vif.cb_mon.out_rdy;
      ap_subscriber.write(s);
    end
  endtask
endclass