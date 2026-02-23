// Code your design here
module RV_PIPE(rv_if.dut if_);
  /*input logic clk,
  input logic rstn,
  
  input logic in_vld,
  output logic in_rdy,
  input logic [data_w-1:0] data_in,
  
  output logic out_vld,
  input logic out_rdy,
  output logic [data_w-1:0] data_out);*/
  
  logic full, push, pop;
  assign if_.in_rdy = !full || (full && if_.out_rdy);
  assign if_.out_vld = full;
  assign push = if_.in_rdy && if_.in_vld;
  assign pop = if_.out_rdy && if_.out_vld;
  //push
  always@(posedge if_.clk)begin
    if(!if_.rstn)begin
      full <= 0;
      if_.data_out <=0;
      
    end
    else begin
      case({push, pop})
        2'b00:begin // {push, pop} = 0,0
          {full, if_.data_out} <=	{full, if_.data_out};
        end
        2'b01:begin //{push, pop} = 0,1
          {full, if_.data_out} <= {1'b0, if_.data_out};
        end
        2'b10:begin //{push, pop} = 1,0
          {full, if_.data_out} <= {1'b1, if_.data_in};
          $display("[%0t]DUT push %0h", $time, if_.data_in);
        end

        2'b11:begin //{push, pop} = 1,1
          {full, if_.data_out} <= {1'b1, if_.data_in};      
          $display("[%0t] DUT push %0h", $time, if_.data_in);
        end
      endcase
    end
  end
endmodule

interface rv_if #(parameter data_w = 48)(
  input logic clk,
  input rstn);
  //down stream
  logic in_vld;
  logic in_rdy;
  logic [data_w-1:0] data_in;
  //up stream
  logic out_vld;
  logic out_rdy;
  logic [data_w-1:0] data_out;
  //driver <-> dut
  clocking cb_drv@(posedge clk);
    default input #1step output #0;
    output in_vld, data_in;
    input in_rdy;
  endclocking
  //monitor <->dut
  clocking cb_mon@(posedge clk);
    default input #1step output #0;
    input in_vld, in_rdy, data_in;
    input out_vld, out_rdy, data_out;
  endclocking
  //dut <-> sink
  clocking cb_sink@(posedge clk);
    default input #1step output #0;
    output out_rdy;
    input out_vld, data_out;
  endclocking
  
  modport drv(clocking cb_drv, input clk, input rstn);
  modport mon(clocking cb_mon, input clk, input rstn);
  modport sink(clocking cb_sink, input clk, input rstn);
  modport dut(input clk,
              input rstn,
              //down stream
              input data_in,
              input in_vld,
              output in_rdy,
              //up stream
              output data_out,
              output out_vld,
              input out_rdy);
                
  property data_hold;
    @(posedge clk) disable iff(!rstn)
    (out_vld && !out_rdy) |=> $stable(data_out);
  endproperty   
  DATA_HOLD:assert property(data_hold) else
    $error("[SVA] out_data changed while out_valid && !out_ready");
     
  property out_valid_hold;
    @(posedge clk) disable iff(!rstn)
    (out_vld && !out_rdy) |=> out_vld;
  endproperty
  OUT_VALID_HOLD:assert property(out_valid_hold) else
    $error("[SVA] out valid did not hold until fetch");      
endinterface

