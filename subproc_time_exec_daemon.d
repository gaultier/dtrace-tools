#!/usr/sbin/dtrace -s

// Log all OS child processes invocations as JSON in the Chrome Trace Format.
// Useful to see a Gantt-like chart of all subcommands executed by the root process.
//
// Note: Some processes e.g. `npm run test` submit all their work to a daemon process which runs indefinitely, 
// in which case running dtrace with `-p` or `-c` would stop dtrace automatically when the target process terminates.
// Thus, this script must run forever as well and filter processes by some criteria e.g. `execname == "node"`,
// and be terminated manually e.g. with Ctrl-C.


#pragma D option quiet

pid_t parent;
uint64_t pid_to_id[pid_t];
uint64_t myid;

proc:::start / basename(execname) == "make" && parent == 0 / {
    parent = pid;
    printf("kind|id|ppid|pid|tid|ts|basename|execname|argc|argv\n");
}

proc:::start
/ parent != 0 && progenyof(parent) /
{
    myid = myid + 1;
    pid_to_id[pid] = myid;

    this->now = timestamp;
    this->argc = curpsinfo->pr_argc;
    this->s = "B|";
    this->s = strjoin(this->s, lltostr(myid));
    this->s = strjoin(this->s, "|");
    this->s = strjoin(this->s, lltostr(ppid));
    this->s = strjoin(this->s, "|");
    this->s = strjoin(this->s, lltostr(pid));
    this->s = strjoin(this->s, "|");
    this->s = strjoin(this->s, lltostr(tid));
    this->s = strjoin(this->s, "|");
    this->s = strjoin(this->s, lltostr(this->now));
    this->s = strjoin(this->s, "|");
    this->s = strjoin(this->s, basename(execname));
    this->s = strjoin(this->s, "|");
    this->s = strjoin(this->s, execname);
    this->s = strjoin(this->s, "|");
    this->s = strjoin(this->s, lltostr(this->argc));
    this->s = strjoin(this->s, "|");

    if (this->argc && curpsinfo->pr_argv) {
      this->argv = curpsinfo->pr_argv ? (char**)copyin(curpsinfo->pr_argv, this->argc * sizeof(char*)) : 0;
      this->s = (this->argv && this->argc > 0) ? strjoin(this->s, basename(copyinstr((user_addr_t)this->argv[0]))) : this->s;
      this->s = (this->argv && this->argc > 1) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[1]))) : this->s;
      this->s = (this->argv && this->argc > 2) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[2]))) : this->s;
      this->s = (this->argv && this->argc > 3) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[3]))) : this->s;
      this->s = (this->argv && this->argc > 4) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[4]))) : this->s;
      this->s = (this->argv && this->argc > 5) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[5]))) : this->s;
      this->s = (this->argv && this->argc > 6) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[6]))) : this->s;
      this->s = (this->argv && this->argc > 7) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[7]))) : this->s;
      this->s = (this->argv && this->argc > 8) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[8]))) : this->s;
      this->s = (this->argv && this->argc > 9) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[9]))) : this->s;
      this->s = (this->argv && this->argc > 10) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[10]))) : this->s;
      this->s = (this->argv && this->argc > 11) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[11]))) : this->s;
      this->s = (this->argv && this->argc > 12) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[12]))) : this->s;
      this->s = (this->argv && this->argc > 13) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[13]))) : this->s;
      this->s = (this->argv && this->argc > 14) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[14]))) : this->s;
      this->s = (this->argv && this->argc > 15) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[15]))) : this->s;
      this->s = (this->argv && this->argc > 16) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[16]))) : this->s;
      this->s = (this->argv && this->argc > 17) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[17]))) : this->s;
      this->s = (this->argv && this->argc > 18) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[18]))) : this->s;
      this->s = (this->argv && this->argc > 19) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[19]))) : this->s;
      this->s = (this->argv && this->argc > 20) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[20]))) : this->s;
      this->s = (this->argv && this->argc > 21) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[21]))) : this->s;
      this->s = (this->argv && this->argc > 22) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[22]))) : this->s;
      this->s = (this->argv && this->argc > 23) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[23]))) : this->s;
      this->s = (this->argv && this->argc > 24) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[24]))) : this->s;
      this->s = (this->argv && this->argc > 25) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[25]))) : this->s;
      this->s = (this->argv && this->argc > 26) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[26]))) : this->s;
      this->s = (this->argv && this->argc > 27) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[27]))) : this->s;
      this->s = (this->argv && this->argc > 28) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[28]))) : this->s;
      this->s = (this->argv && this->argc > 29) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[29]))) : this->s;
      this->s = (this->argv && this->argc > 30) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[30]))) : this->s;
      this->s = (this->argv && this->argc > 31) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[31]))) : this->s;
    }
    printf("%s\n", this->s);
}

proc:::exit
/parent != 0 && progenyof(parent)/
{
    this->id = pid_to_id[pid];
    printf("E|%d|%d|%d|%d|%d||||\n",
            this->id,
            ppid,
            pid,
            tid,
            timestamp); 
    pid_to_id[pid] = 0;

    if (pid == parent) {
      exit(0);
    }
}
