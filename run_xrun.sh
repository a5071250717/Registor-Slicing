
#!/usr/bin/env bash
set -euo pipefail

# usage:
#   ./run_xrun.sh                 # default smoke, random seed
#   ./run_xrun.sh rv_test 12345    # fixed seed
#   COV=0 ./run_xrun.sh rv_test 1  # disable coverage
#   VERB=UVM_HIGH ./run_xrun.sh rv_test 1

TEST=${1:-rv_test}
SEED=${2:-random}
VERB=${VERB:-UVM_MEDIUM}
COV=${COV:-1}

COV_OPT=""
if [[ "${COV}" == "1" ]]; then
  COV_OPT="-coverage functional"
fi

xrun -64bit -sv -uvm \
  -access +rw \
  -seed ${SEED} \
  ${COV_OPT} \
  +UVM_TESTNAME=${TEST} \
  +UVM_VERBOSITY=${VERB} \
  -l xrun_${TEST}_${SEED}.log \
  design.sv testbench.sv
