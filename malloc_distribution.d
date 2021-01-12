#!/usr/sbin/dtrace -s
pid$target::malloc:entry {@ = quantize(arg0)} 
 
tick-10s { exit(0) }
