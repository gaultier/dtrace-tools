#!/usr/sbin/dtrace -s

pid$target::std*basic_string*__init*:entry { @=quantize(arg2)}
tick-10s {exit(0);} 
