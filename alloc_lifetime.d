sudo dtrace -n 'pid8504::xmalloc:return {self->lifetime[arg1]=timestamp} pid8504::xfree:entry {@duration = quantize((timestamp - self->lifetime[arg0])/1000000)}  tick-10s {exit(0)}' -p 8504
