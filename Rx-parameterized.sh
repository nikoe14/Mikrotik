#!/bin/bash
rx=$(ssh $1@$2 "interface monitor-traffic "$3" once" | grep rx-bits)
rx=${rx//rx-bits-per-second:/}
rx=${rx//.../kbps}
unit=`echo $rx | grep -o "['A-Z''a-z']\+"`
if [[ $unit == "bps" ]]; then
        unitBps=1000000
        bpsToMbps=`echo $rx | grep -o "[0-9.]\+"`
        echo "scale=5; $bpsToMbps/$unitBps" | bc
else
        if [[ $unit == k* ]]; then
                unitKbps=1000
                kbpsToMbps=`echo $rx | grep -o "[0-9.]\+"`
                echo "scale=2; $kbpsToMbps/$unitKbps" | bc
        else
		if [[ $unit == G* ]]; then
                        unitGbps=1000
                        GbpsToMbps=`echo $rx | grep -o "[0-9.]\+"`
                        echo "scale=2; $GbpsToMbps*$unitGbps" | bc
        	else
			echo `echo $rx | grep -o "[0-9.]\+"`
		fi
        fi
fi


