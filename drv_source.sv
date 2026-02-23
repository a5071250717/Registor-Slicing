
class rv_drv_source extends uvm_driver#(rv_txn);
  `uvm_component_utils(rv_drv_source)
  rv_vif_drv_t vif;
  rv_cfg cfg;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(rv_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("DRV", "Can't get cfg");
   //使用typedef就沒辦法用rv_vif_t.drv
    if(!uvm_config_db#(rv_vif_drv_t)::get(this, "", "vif_drv", vif))
      `uvm_fatal("DRV","Can't get vif");
  endfunction

  
  task run_phase(uvm_phase phase);
    rv_txn txn;
    vif.cb_drv.in_vld <= 0;
    vif.cb_drv.data_in <= 0;
    @(posedge vif.rstn);
    //wait(vif.rstn === 1'b1);
    forever begin
      seq_item_port.get_next_item(txn);
      `uvm_info("DRV", $sformatf("get data = %0h, gap = %0d", txn.data&mask(data_w),
                                txn.gap), UVM_LOW);
      @(vif.cb_drv);
      repeat(txn.gap)begin
        @(vif.cb_drv);
        vif.cb_drv.in_vld <= 0;
      end

      vif.cb_drv.in_vld <= 1;
      vif.cb_drv.data_in <= txn.data & mask(cfg.data_w);
      `uvm_info("DRV", $sformatf("drive data = %0h", txn.data&mask(data_w)), UVM_LOW);
      
      do @(vif.cb_drv);
      while(!vif.cb_drv.in_rdy);

      //@(vif.cb_drv);
      vif.cb_drv.in_vld <= 0;
      seq_item_port.item_done();
    end
  endtask
endclass