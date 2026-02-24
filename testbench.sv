// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

//data_type, mask_function
`include "base_pkg.sv"
import rv_base_pkg::*;

// package 不能在package內inlucde，所以只能放外面
`include "cov_pkg.sv"

`include "pkg.sv"
import rv_pkg::*;

module top;
  //data_w寫在這會導致get無法寫正確型別，因此寫在base_pkg裡面
  //localparam int unsigned data_w = 8;
  logic clk, rstn;
  always #10 clk = ~clk;
  rv_if #(.data_w(data_w)) top_if(.clk(clk), .rstn(rstn));
  rv_cfg cfg;
  RV_PIPE rv_pipe(.if_(top_if));
  initial begin
   
    //override
    /*uvm_factory::get().set_type_override_by_type(rv_test::get_type(),
                                                 rv_test_fifo::get_type());*/

    //CFG
    cfg = rv_cfg::type_id::create("cfg");
    cfg.data_w = data_w;
    uvm_config_db#(rv_cfg)::set(null, "*", "cfg", cfg);
    
    //IF 
    uvm_config_db#(rv_vif_drv_t)::set(null, "*", "vif_drv", top_if.drv);
    uvm_config_db#(rv_vif_sink_t)::set(null, "*", "vif_sink", top_if.sink);
    uvm_config_db#(rv_vif_mon_t)::set(null, "*", "vif_mon", top_if.mon);

  end
  
  initial begin
    $dumpvars(0);
    $dumpfile("dump.vcd");
    run_test();

  end
  
  initial begin
    clk = 0;
    rstn = 0;
    #100;
    rstn = 1;
  end
  
endmodule

