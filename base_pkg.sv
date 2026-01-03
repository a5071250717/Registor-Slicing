package rv_base_pkg;
typedef bit [63:0] u_64t;
function u_64t mask(int unsigned data_w);
  if(data_w > 64)
    return '1;
  else
    return (u_64t'(1) << data_w) -1;
endfunction
localparam int unsigned data_w = 8;
typedef virtual rv_if#(.data_w(data_w)) rv_vif_t;
typedef virtual rv_if#(.data_w(data_w)).drv   rv_vif_drv_t;
typedef virtual rv_if#(.data_w(data_w)).sink   rv_vif_sink_t;
typedef virtual rv_if#(.data_w(data_w)).mon   rv_vif_mon_t;
endpackage