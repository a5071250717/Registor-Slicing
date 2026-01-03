class rv_subscriber extends uvm_subscriber#(rv_subscriber_txn);
  `uvm_component_utils(rv_subscriber)
  //implicit uvm_analysis_imp#(rv_subscriber_txn, rv_subscriber) analysis_export
  cov cg;
  bit stall;
  bit bubble;
  int unsigned burst_len = 0;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg = new();
    
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //if(!uvm_config_db#(cov)::get(this,"", "cov", cg))
      //`uvm_fatal("SUBSCIBER", "Can't get cg");
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SUBSCRIBER", $sformatf("coverage rate is %f", cg.get_inst_coverage()),
              UVM_LOW)
  endfunction
  // the argument name must be "t"
  function void write(rv_subscriber_txn t);
    stall = t.out_vld && !t.out_rdy;
    bubble = !t.out_vld;
    burst_len = (t.out_vld && t.out_rdy)? burst_len+1: 0;
    if(stall || bubble)
    	`uvm_info("SUBSCRIBER", $sformatf("stall = %b, bubble = %b", stall, bubble),UVM_LOW)
    else
      `uvm_info("SUBSCRIBER", $sformatf("burst_len = %0d", burst_len),UVM_LOW)
        
    cg.sample(stall, bubble, burst_len);
  endfunction
endclass