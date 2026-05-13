#!/bin/bash -e

if [[ -z ${ROOTDIR} ]]; then
    echo "ERROR: environment not initialized"
    exit 1
fi

cd ${ROOTDIR}/hw 
git clean -fXd .

RUN_PEAKRDL=""
RUN_QUARTUS=1

while getopts "p:n" opt; do
    case $opt in
        p)
            RUN_PEAKRDL="$OPTARG"
            ;;
        n)
            RUN_QUARTUS=0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [[ -n "$RUN_PEAKRDL" ]]; then
    echo "Running peakrdl regblock generation"
    peakrdl regblock "rdl/$RUN_PEAKRDL.rdl" \
        -o "fpga/rtl/$RUN_PEAKRDL" \
        --peakrdl-cfg rdl/peakrdl.toml \
        --cpuif avalon-mm-flat \
        --addr-width 12
    
    mkdir -p bsp
    peakrdl c-header "rdl/$RUN_PEAKRDL.rdl" \
        -o "bsp/$RUN_PEAKRDL.h" \
        --peakrdl-cfg rdl/peakrdl.toml
else
    echo "Skipping peakrdl regblock generation"
    echo "$RUN_PEAKRDL"
fi

if [[ $RUN_QUARTUS -eq 1 ]]; then
    echo "Running Quartus compilation"
    cd ${ROOTDIR}/hw/fpga
    quartus_sh --flow compile de0_nano_soc
    quartus_cpf -c de0_nano_soc.cof
else
    echo "Skipping Quartus compilation"
fi

