#!/bin/sh -x

dtrace -n 'pid$target::malloc:return {self->lifetime[arg1]=timestamp} pid$target::free:entry {@duration = quantize((timestamp - self->lifetime[arg0])/1000000)}  tick-10s {exit(0)}' $@
