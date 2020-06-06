#!/bin/bash
if [ -z $2 ]; then
    echo "USAGE: launch.sh (message interval in seconds) (1st stock ticker symbol) [2nd symbol..] [3rd symbol..]";
fi
tickers=()
c=0
for arg
do
    if [ $c -gt 0 ]; then
	tickers+=" $arg "
    fi
    c+=1;
done
zz=600;
if [ ! -z $1 ]; then
    zz=$1;
fi
for ticker in $tickers
do
    nohup ./stockDmon.sh $zz $ticker &> /dev/null &
done;
