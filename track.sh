#!/bin/bash
if [ -z $1 ]; then
    echo "USAGE: track.sh (stock symbol)";
    exit 1;
fi
APIKey=$(cat ./APIKey.cfg);
baseURL=$(cat ./URL.cfg);
constructedURL=${baseURL//"[:tickerSym]"/$1}
constructedURL=${constructedURL//"[:APIKey]"/$APIKey}
data=($(curl $constructedURL));
keys=${data[0]};
vals=${data[1]};
keys=(${keys//","/" "});
vals=(${vals//","/" "});
x=0;
m="[:sym]  \$[:price]  [:sts]  \$[:chg]";
s=0;
while [ $x -lt ${#vals[@]} ];
do
    if [ ${keys[$x]} == "symbol" ]; then
	m=${m//"[:sym]"/${vals[$x]}};
	s=${vals[$x]};
    elif [ ${keys[$x]} == "price" ]; then
	m=${m//"[:price]"/${vals[$x]}};
    elif [ ${keys[$x]} == "change" ]; then
	m=${m//"[:chg]"/${vals[$x]}};
	s="/\\";
	if [ ${vals[$x]} -lt 0 ]; then
	    s="\\/";
	fi;
	m=${m//"[:sts]"/$s};
    fi
    x=$(($x+1));
done;
if [ ! $s == 0 ]; then
    notify-send "$m" "$(date)"
else
    exit 1;
fi;
