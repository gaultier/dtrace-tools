#pragma D option strsize=16K

syscall::write:entry
/ pid == $target && arg0 > 2 && arg1 != 0/
{
   printf("size=%d fd=%d: %s\n", arg2, arg0, stringof(copyin(arg1, arg2)));
}


syscall::read:entry
/ pid == $target && arg0 > 2 /
{
  self->read_ptr = arg1;
  self->read_fd = arg0;
}

syscall::read:return
/ pid == $target && self->read_ptr!=0 && arg0>0/
{
  printf("size=%d fd=%d: %s\n", arg0, self->read_fd, stringof(copyin(self->read_ptr, arg0)));
  self->read_ptr = 0;
  self->read_fd = 0;
}

pid$target::crypto?tls.(?halfConn).decrypt:return
{
  printf("%s\n", stringof(copyin(arg1, arg0)));
}

pid$target::crypto?tls.(?halfConn).encrypt:entry
{
  printf("%s\n", stringof(copyin(arg4, arg3)));
}

