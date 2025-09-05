#!/usr/sbin/dtrace -s

/*#pragma D option strsize=16m*/
/*#pragma D option bufsize=1g*/

// Log all read(2)/write(2) data as a string, ignoring stdin/stdout/stderr, following child processes.

syscall::write:entry 
/(pid == $target || pid == progenyof($target)) && arg0 > 2 / 
{ 
  self->ptr = arg1; 
}  

syscall::read:entry 
/(pid == $target || pid == progenyof($target)) && arg0 > 2/
{
    self->ptr = arg1;
}

syscall::write:return 
/(pid == $target || pid == progenyof($target)) && arg0 > 0 && self->ptr!=0 /
{ 
    this->s = stringof(copyin(self->ptr, arg0)); 
    printf("%s\n", this->s); 
    self->ptr = 0; 
}

syscall::read:return 
/(pid == $target || pid == progenyof($target)) && arg0 > 0 && self->ptr != 0 / 
{
    this->s = stringof(copyin(self->ptr, arg0));
    printf("%s\n", this->s);
    self->ptr = 0;
}
