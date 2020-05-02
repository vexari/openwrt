#!/bin/ash
IFACE2=mon2
IFACE5=mon5
IFACE2_CHAN="1 2 3 4 5 6 7 8 9 10 11 12 14"
IFACE5_CHAN="36 40 44 48 52 56 60 64 100 104 108 112 116 120 124 128 132 136 140 144 149 153 157 161 165 169 173"
DELAY=1
while true ;
do
        for CHAN in $IFACE2_CHAN ;
                do
                echo "Switching to channel $CHAN"
                iw $IFACE2 set channel $CHAN
                sleep $DELAY
                done               
done
