#!/bin/bash
tx=$(ssh $1@$2 "interface monitor-traffic "$3" once" | grep tx-bits)
tx=${tx//tx-bits-per-second:/}
tx=${tx//.../kbps}
unit=`echo $tx | grep -o "['A-Z''a-z']\+"`
if [[ $unit == "bps" ]]; then
        unitBps=1000000
        bpsToMbps=`echo $tx | grep -o "[0-9.]\+"`
        echo "scale=5; $bpsToMbps/$unitBps" | bc
else
        if [[ $unit == k* ]]; then
                unitKbps=1000
                kbpsToMbps=`echo $tx | grep -o "[0-9.]\+"`
                echo "scale=2; $kbpsToMbps/$unitKbps" | bc
        else
                if [[ $unit == G* ]]; then
                        unitGbps=1000
                        GbpsToMbps=`echo $tx | grep -o "[0-9.]\+"`
                        echo "scale=2; $GbpsToMbps*$unitGbps" | bc
        	else
                	echo `echo $tx | grep -o "[0-9.]\+"`
                fi
        fi
fi


