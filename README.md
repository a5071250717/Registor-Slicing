## Simulator
- Cadence Xcelium 25.03
- Options used: `-access +rw -seed random -coverage functional

## Run
- ./run_xrun.sh rv_test random
- 選用 rv_test (scb 用 兩個analysis_imp 去收data_in/out, 需定義write_in/write_out)
- 選用 rv_test_fifo (scb 用兩個uvm_tlm_analysis_fifo 去收data_in/out, 用內建write)
  - 可以將top module 中set_type_override de-command，自動替換成rv_test_fifo


## UVM 環境架構圖

```mermaid
flowchart TD
  subgraph uvm_test_top["uvm_test_top (test)"]
    subgraph rv_env["rv_env (env)"]
      subgraph rv_agt["rv_agt (agt)"]
        rv_sqr["rv_sqr (sqr)"]
        rv_drv_source["rv_drv_source (drv_source)"]
        rv_drv_sink["rv_drv_sink (drv_sink)"]
        rv_mon_in["rv_mon_in (mon_in)"]
        rv_mon_out["rv_mon_out (mon_out)"]
      end
      rv_subscriber["rv_subscriber (subscriber)"]
      rv_scb["rv_scb (scb)"]
    end
  end
```
## 訊號
```mermaid
flowchart LR
  %% Sequencer -> Drivers
  rv_sqr["sqr"] -->|txn| rv_drv_source["drv_source"]

  %% Drivers -> IF 
  rv_drv_source["drv_source"] -->|in_vld data_in| rv_if.drv["if_.drv"]
  rv_drv_sink   -->|out_rdy| rv_if.drv["if_.drv"]

  %% DUT block
  rv_if.drv --> RV_PIPE["rv_pipe"]
  RV_PIPE["rv_pipe"] --> rv_if.mon

  %% IF to mon
  rv_if.mon["if_.mon"]  --> |in_rdy in_vld data_in|rv_mon_in["mon_in"]
  rv_if.mon["if_.mon"]  --> |out_rdy out_vld data_out|rv_mon_out["mon_out"]

  %% MON to SCB
  rv_mon_in  -->|data_in| rv_scb["scb"]
  rv_mon_out -->|data_out| rv_scb["scb"]
  %% MON to SUBSCRIBER
  rv_mon_out  -->|out_rdy out_vld data_out| rv_subscriber["subscriber"]

```
## port connection(when xrun test.sv)
```mermaid
flowchart LR
rv_sqr["sqr"] --> |seq_item_port|rv_drv_source["drv_source"]
rv_mon_in["mon_in"] -->|uvm_analysis_port|rv_scb["scb"]
rv_mon_out["mon_out"] -->|uvm_analysis_port|rv_scb["scb"]
rv_mon_out["mon_out"] -->|uvm_analysis_port|rv_subscriber["subscriber"]
```
## port connection (when xrun rv_test_fifo)

```mermaid
flowchart LR
rv_sqr["sqr"] --> |seq_item_port|rv_drv_source["drv_source"]
rv_mon_in["mon_in"] -->|uvm_tlm_analysis_fifo|rv_scb["scb"]
rv_mon_out["mon_out"] -->|uvm_tlm_analysis_fifo|rv_scb["scb"]
rv_mon_out["mon_out"] -->|uvm_analysis_port|rv_subscriber["subscriber"]
```

