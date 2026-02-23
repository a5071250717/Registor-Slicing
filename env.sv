class rv_env extends uvm_env;
  `uvm_component_utils(rv_env)
  rv_agt agt;
  rv_scb scb;
  rv_subscriber subscriber;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    
    agt = rv_agt::type_id::create("agt", this);
    scb = rv_scb::type_id::create("scb", this);
    subscriber = rv_subscriber::type_id::create("subscriber", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    //agt.mon_in.ap.connect(scb.imp_in);
    //agt.mon_out.ap.connect(scb.imp_out);
    agt.mon_in.ap.connect(scb.exp_in);
    agt.mon_out.ap.connect(scb.exp_out);    
    agt.mon_out.ap_subscriber.connect(subscriber.analysis_export);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    uvm_factory::get().print(0);
  endfunction
  
endclass