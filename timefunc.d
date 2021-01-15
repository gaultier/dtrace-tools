#!/usr/sbin/dtrace -s

pid$target::doWork:entry {
	self->ts = timestamp
}

pid$target::doWork:return /self->ts/ {
	@["ns"] = quantize(timestamp - self->ts);
	self->ts = 0;
}

profile:::tick-1s
{
	printf("%Y", walltimestamp);
	printa(@);
	trunc(@);
}
