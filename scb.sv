
class rv_scb extends uvm_scoreboard;
  `uvm_component_utils(rv_scb)
`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)
  uvm_analysis_imp_in#(u_64t, rv_scb) imp_in;
  uvm_analysis_imp_out#(u_64t, rv_scb) imp_out;
  uvm_analysis_export#(u_64t) exp_in;
  uvm_analysis_export#(u_64t) exp_out;
  u_64t data[$];
  event sink_done;
  int unsigned ntimes;
  int unsigned in_cnt = 0;
  int unsigned out_cnt = 0;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    imp_in = new("imp_in", this);
    imp_out = new("imp_out", this);
    exp_in = new("exp_in", this);
    exp_out = new("exp_iut", this);
  endfunction
  
  function void write_in(u_64t t_in);
    data.push_back(t_in);
    in_cnt ++;
    `uvm_info("SCB", $sformatf("push %h", t_in), UVM_LOW);
  endfunction

  function void write_out(u_64t t_out);
	u_64t t_exp;
    if(data.size() == 0)
      //`uvm_error not need ';"
      `uvm_error("SCB", $sformatf("get %0h but exp empty", t_out))
    else begin 
      t_exp = data.pop_front();
      out_cnt ++;
      `uvm_info("SCB", $sformatf("cnt= %d", out_cnt), UVM_LOW);
      // to drop objection in uvm_test
      if(out_cnt == ntimes)begin
        ->sink_done;
        `uvm_info("SCB", "event triggered", UVM_LOW);
      end

      if(t_exp != t_out)
        `uvm_error("SCB", $sformatf("mismatch get = %0h, exp = %0h", t_out, t_exp))
      end
      `uvm_info("SCB", $sformatf("pop %h", t_out), UVM_LOW);
      endfunction

      function void connect_phase(uvm_phase phase);
        // data flow : ap.write()->exp->imp->call write_in/out
        exp_in.connect(imp_in);
        exp_out.connect(imp_out);
      endfunction
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if(data.size()!=0)
      `uvm_error("SCB", "data queue is not empty")
    else if(in_cnt != out_cnt)
      `uvm_error("SCB", $sformatf("misatch in_cnt = %0h, out_cnt = %0h", in_cnt, out_cnt))
  endfunction
endclass