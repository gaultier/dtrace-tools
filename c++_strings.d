#!/usr/sbin/dtrace -s

pid$target::std*basic_string*__init*:entry {printf("`%.*s`", arg1, stringof(copyin(arg1, arg2)))}
