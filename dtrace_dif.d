
syscall::open:entry, syscall::open_nocancel:entry
/execname=="dtrace" && pid != $pid && arg0 != 0/
{
  this->p = copyinstr(arg0);
  if (this->p == "/dev/dtrace") {
    self->in_dev_dtrace_open = 1;
  }
}

syscall::open:return, syscall::open_nocancel:return
/execname=="dtrace" && pid != $pid && self->in_dev_dtrace_open != 0/
{
  self->in_dev_dtrace_open = 0;
  dev_dtrace_fd = arg0;
  printf("/dev/dtrace fd: %d\n", arg0);
}

syscall::mmap:entry
/execname=="dtrace" && pid != $pid && arg0 != dev_dtrace_fd/
{
  printf("mmap-ing: %p %d %d %d %d %d\n", arg0, arg1, arg2, arg3, arg4, arg5);
  self->in_mmap = 1;
}

syscall::mmap:return
/execname=="dtrace" && pid != $pid && arg0 != dev_dtrace_fd && self->in_mmap != 0/
{
  self->in_mmap = 0;
  printf("mmap-ed: %p\n", arg0);
}

syscall::mmap:entry
/execname=="dtrace" && pid != $pid && arg0 == dev_dtrace_fd/
{
  printf("/dev/dtrace mmap-ing: %p %d %d %d %d %d\n", arg0, arg1, arg2, arg3, arg4, arg5);
  self->in_dev_dtrace_mmap = 1;
}

syscall::mmap:return
/execname=="dtrace" && pid != $pid && self->in_dev_dtrace_mmap != 0/
{
  self->in_dev_dtrace_mmap = 0;
  printf("/dev/dtrace mmap-ed: %p\n", arg0);
}


typedef struct dtrace_status {
        uint64_t dtst_dyndrops;                 /* dynamic drops */
        uint64_t dtst_dyndrops_rinsing;         /* dyn drops due to rinsing */
        uint64_t dtst_dyndrops_dirty;           /* dyn drops due to dirty */
        uint64_t dtst_specdrops;                /* speculative drops */
        uint64_t dtst_specdrops_busy;           /* spec drops due to busy */
        uint64_t dtst_specdrops_unavail;        /* spec drops due to unavail */
        uint64_t dtst_errors;                   /* total errors */
        uint64_t dtst_filled;                   /* number of filled bufs */
        uint64_t dtst_stkstroverflows;          /* stack string tab overflows */
        uint64_t dtst_dblerrors;                /* errors in ERROR probes */
        char dtst_killed;                       /* non-zero if killed */
        char dtst_exiting;                      /* non-zero if exit() called */
        char dtst_pad[6];                       /* pad out to 64-bit align */
} dtrace_status_t;

typedef struct dof_hdr {
        uint8_t dofh_ident[16]; /* identification bytes (see below) */
        uint32_t dofh_flags;            /* file attribute flags (if any) */
        uint32_t dofh_hdrsize;          /* size of file header in bytes */
        uint32_t dofh_secsize;          /* size of section header in bytes */
        uint32_t dofh_secnum;           /* number of section headers */
        uint64_t dofh_secoff;           /* file offset of section headers */
        uint64_t dofh_loadsz;           /* file size of loadable portion */
        uint64_t dofh_filesz;           /* file size of entire DOF file */
        uint64_t dofh_pad;              /* reserved for future use */
} dof_hdr_t;

syscall::ioctl:entry
/execname=="dtrace" && pid != $pid && arg0 == dev_dtrace_fd/
{
  printf("ioctl: %x %d %p\n", arg0, arg1 - 0x20006400, arg2);

  if (arg1 ==0x2000640b){ // Status
    this->status =*(dtrace_status_t*) copyin(arg2, 88);
    print(this->status);
  }
  if (arg1 ==0x20006406){ // Enable
    this->dof =*(dof_hdr_t*) copyin(arg2, 88);
    print(this->dof);
  }
}
