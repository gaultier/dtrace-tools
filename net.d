//#pragma D option quiet
#pragma D option strsize=16K

// syscall::socket:return /

syscall::write:entry, syscall::sendto_nocancel:entry, syscall::sendto:entry 
/ (pid == $target) && arg0>2 && arg1 != 0 && arg2 >16 /
{
   printf("action=write pid=%d execname=%s size=%d fd=%d: %s\n", pid, execname, arg2, arg0, stringof(copyin(arg1, arg2)));
}


syscall::read:entry, syscall::recvfrom_nocancel:entry, syscall::recvfrom:entry 
/ (pid == $target) && arg0>2 /
{
  self->read_ptr = arg1;
  self->read_fd = arg0;
}

syscall::read:return, syscall::recvfrom_nocancel:return, syscall::recvfrom:return 
/ pid == $target && arg0>2 && self->read_ptr!=0 /
{
  printf("action=read pid=%d execname=%s size=%d fd=%d: %s\n", pid, execname, arg0, self->read_fd, stringof(copyin(self->read_ptr, arg0)));
  self->read_ptr = 0;
  self->read_fd = 0;
}
