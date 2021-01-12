sudo dtrace -n 'pid8504::xmalloc:entry {@dist = quantize(arg0)} tick-10s {exit(0)}' -p 8504
