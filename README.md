## Simulator
- Cadence Xcelium 25.03
- Options used: `-access +rw -seed random -coverage functional`

## Run
```bash
cd sim
make TEST=rv_test SEED=random COV=1
# or
./run_xrun.sh rv_test random




### UVM 環境架構圖

```mermaid
graph TD
    %% 定義階層
    subgraph uvm_test_top
        subgraph rv_env[env]
          subgraph agt
              rv_drv_source[drv_source]
              rv_drv_sink[drv_sink]
              rv_mon_in[mon_in]
              rv_mon_out[mon_out]
              rv_sqr[sqr]
          end
          rv_subscriber[subscriber]
          rv_scb[scb]
        end
    end


    %% 定義連線
    drv_source <--> sqr
    mon_in -- "uvm_analysis_port"--> scb
    mon_out -- "seq_item_port"--> scb
```
```mermaid
graph LR
    %% 定義顏色風格
    classDef txn fill:#f1c40f,stroke:#333,stroke-dasharray: 5 5;
    classDef comp fill:#ecf0f1,stroke:#2c3e50,stroke-width:2px;

    %% 1. Sequence 與 Agent 區塊
    subgraph SEQUENCE [uvm_test_top]
        seq[seq]
    end

    subgraph AGT [agt]
        sqr[sqr]
        drv[drv_source]
    end

    subgraph DUT[dut]
    end

    %% 2. Subscriber 與 Coverage 區塊
    subgraph ENV [env]
        sub[subscriber]
        cov((Covergroup))
    end

    %% 3. 資料流連線 (Data Flow)
    
    %% Sequence 產生 txn 丟給 sqr
    seq -- "1. 產生 rv_txn" --> sqr
    
    %% sqr 傳遞給 drv
    sqr -- "2. seq_item_port (rv_txn)" --> drv
    drv -- "3. VIF " --> DUT 
    %% Monitor (隱含) 或其他組件傳給 subscriber
    %% 假設你是從某處傳進 subscriber_txn
    rv_mon[mon_out] -- "4. analysis_port (subscriber_txn)" --> sub
    
    %% Subscriber 餵進 Covergroup
    sub -- "sample()" --> cov

  
    %% 套用風格
    class seq,sqr,drv,sub comp;
    %% 如果想把 txn 特別標註出來，可以用註記方式
```

