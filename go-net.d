#pragma D option strsize=16K

syscall::write:entry
/ (pid == $target) && arg0>2 && arg1 != 0 && arg2 >16 /
{
   printf("action=write pid=%d execname=%s size=%d fd=%d: %s\n", pid, execname, arg2, arg0, stringof(copyin(arg1, arg2)));
}


syscall::read:entry
/ (pid == $target) && arg0>2 /
{
  self->read_ptr = arg1;
  self->read_fd = arg0;
}

syscall::read:return
/ pid == $target && arg0>2 && self->read_ptr!=0 && arg0 > 16 /
{
  printf("action=read pid=%d execname=%s size=%d fd=%d: %s\n", pid, execname, arg0, self->read_fd, stringof(copyin(self->read_ptr, arg0)));
  self->read_ptr = 0;
  self->read_fd = 0;
}

pid$target:kratos:crypto?tls.(?halfConn).decrypt:return
{
  printf("%s\n", stringof(copyin(arg1, arg0)));
}

pid$target:kratos:crypto?tls.(?halfConn).encrypt:entry
{
  printf("%s\n", stringof(copyin(arg4, arg3)));
}
