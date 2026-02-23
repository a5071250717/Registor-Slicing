class rv_scb_fifo extends rv_scb;
  `uvm_component_utils(rv_scb_fifo)
  uvm_tlm_analysis_fifo#(u_64t) fifo_in;
  uvm_tlm_analysis_fifo#(u_64t) fifo_out;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    in_cnt = 0;
    out_cnt = 0;
  endfunction
  
  function void build_phase(uvm_phase phase);
    //exp_in/out extend from rv_scb
    exp_in = new("exp_in", this);
    exp_out = new("exp_out", this);
    fifo_in = new("fifo_in", this);
    fifo_out = new("fifo_out", this);
  endfunction
  //ap.write()-> analysis_exp -> fifo_imp -> call fifo build-in write()
  function void connect_phase(uvm_phase phase);
    exp_in.connect(fifo_in.analysis_export);
    exp_out.connect(fifo_out.analysis_export);
  endfunction
  
  task run_phase(uvm_phase phase);
    u_64t t_in, t_out;
   
    forever begin
      fifo_in.get(t_in);
      `uvm_info("SCB", $sformatf("get data_in %h", t_in), UVM_LOW);
      in_cnt++;
      
      fifo_out.get(t_out);
      `uvm_info("SCB", $sformatf("get data_out %h", t_out), UVM_LOW);
      out_cnt++;
      
      if(t_in != t_out)
        `uvm_error("SCB", $sformatf("mismatch get = %0h, exp = %0h", t_in, t_out));
      if(out_cnt == ntimes)begin
        ->sink_done;
      end
    end
  endtask
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if(in_cnt != out_cnt)
      `uvm_error("SCB", $sformatf("misatch in_cnt = %0h, out_cnt = %0h", in_cnt, out_cnt))
  endfunction  
endclass