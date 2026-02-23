package rv_cov_pkg;
covergroup cov with function sample(bit stall,
                                 bit bubble,
                                  int unsigned burst_len);
  option.per_instance = 1;
  
  cp_stall: coverpoint stall{
    bins no = {0};
    bins yes = {1};
  }
  cp_bubble: coverpoint bubble{
    bins no = {0};
    bins yes = {1};
  }
  cp_burst: coverpoint burst_len{
    bins low = {[0:1]};
    bins mid = {[2:3]};
    bins high = {[4:5]};
  }
  cx_stall_burst: cross cp_stall, cp_burst;
endgroup

endpackage