package rv_pkg;

//config
// pacjage can't be include in a package
import rv_cov_pkg::*;
//import rv_base_pkg::*;
`include "cfg.sv"
`include "subscriber_txn.sv"
`include "txn.sv"
//`include "sample.sv"
`include "seq.sv"
`include "drv_source.sv"
`include "drv_sink.sv"
`include "mon_in.sv"
`include "mon_out.sv"
`include "sqr.sv"
`include "scb.sv"
`include "scb_fifo.sv"
`include "subscriber.sv"
`include "agt.sv"
`include "env.sv"
`include "test.sv"
`include "test_fifo.sv"
endpackage