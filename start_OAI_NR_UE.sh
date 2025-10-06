#!/bin/bash
#
# This script will start an srsLTE UE process
#
# needs to be called with MODE=IQ_EMULATION or MODE=TESTBED

# For emulation:
#chem_ip_addr=192.168.151.192
chem_ip_addr=$AP_EXPENV_CHEMVM_XE
node_num=$AP_EXPENV_THIS_CONTAINER_EXP_NODE_NUM

if [[ $LAUNCH_MODE == "TESTBED" ]]; then
  bash -c "/opt/openairinterface-AERPAW/cmake_targets/ran_build/build/nr-uesoftmodem -r 51 --numerology 1 --band 78 -C 3309480000 --ssb 238 --ue-fo-compensation -E --uicc0.imsi 001010000000001 --uicc0.key fec86ba6eb707ed08905757b1bb44b8f --uicc0.opc C42449363BBAD02B66D16BC975D77CC1 --uicc0.dnn internet --uicc0.nssai_sst 1"
elif [[ $LAUNCH_MODE == "EMULATION" ]]; then
  bash -c "/opt/openairinterface-AERPAW/cmake_targets/ran_build/build/nr-uesoftmodem -r 51 --numerology 1 --band 78 -C 3309480000 --ssb 238 --ue-fo-compensation -E --uicc0.imsi 001010000000001 --uicc0.key fec86ba6eb707ed08905757b1bb44b8f --uicc0.opc C42449363BBAD02B66D16BC975D77CC1 --uicc0.dnn internet --uicc0.nssai_sst 1 --usrp-args vusrp_force_type=b200"
fi
