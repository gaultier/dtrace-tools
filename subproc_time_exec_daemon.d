#!/usr/sbin/dtrace -s

// Log all OS child processes invocations as JSON in the Chrome Trace Format.
// Useful to see a Gantt-like chart of all subcommands executed by the root process.
//
// Note: Some processes e.g. `npm run test` submit all their work to a daemon process which runs indefinitely, 
// in which case running dtrace with `-p` or `-c` would stop dtrace automatically when the target process terminates.
// Thus, this script must run forever as well and filter processes by some criteria e.g. `execname == "nodejs"`,
// and be terminated manually e.g. with Ctrl-C.


#pragma D option quiet

pid_t parent;
uint64_t start[pid_t];
string process_name[pid_t];
int trailing_semicolon;

proc:::start / basename(execname) == "make" && parent == 0 / {
    parent = pid;
    printf("[\n");
}

proc:::start
/ parent != 0 && progenyof(parent) /
{
    this->now = timestamp;
    this->argc = curpsinfo->pr_argc;
    if (trailing_semicolon == 1) {
      this->s = ",";
    } else {
      this->s = "";
      trailing_semicolon = 1;
    }
    this->s = strjoin(this->s, "{\"ph\": \"B\", \"ppid\":");
    this->s = strjoin(this->s, lltostr(ppid));
    this->s = strjoin(this->s, ", \"pid\":");
    this->s = strjoin(this->s, lltostr(pid));
    this->s = strjoin(this->s, ", \"tid\":");
    this->s = strjoin(this->s, lltostr(tid));
    this->s = strjoin(this->s, ", \"ts\":");
    this->s = strjoin(this->s, lltostr(this->now / 1000)); // us.
    this->s = strjoin(this->s, ", \"name\":\"");
    this->s = strjoin(this->s, basename(execname));
    this->s = strjoin(this->s, "\"");

    start[pid] = this->now;
    process_name[pid] = basename(execname);

    if (this->argc && curpsinfo->pr_argv) {
      this->argv = curpsinfo->pr_argv ? (char**)copyin(curpsinfo->pr_argv, this->argc * sizeof(char*)) : 0;
      this->s = strjoin(this->s, ",\"args\":\"");
      this->s = (this->argv && this->argc > 0) ? strjoin(this->s, basename(copyinstr((user_addr_t)this->argv[0]))) : this->s;
      this->s = (this->argv && this->argc > 1) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[1]))) : this->s;
      this->s = (this->argv && this->argc > 2) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[2]))) : this->s;
      this->s = (this->argv && this->argc > 3) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[3]))) : this->s;
      this->s = (this->argv && this->argc > 4) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[4]))) : this->s;
      this->s = (this->argv && this->argc > 5) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[5]))) : this->s;
      this->s = (this->argv && this->argc > 6) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[6]))) : this->s;
      this->s = (this->argv && this->argc > 7) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[7]))) : this->s;
      this->s = (this->argv && this->argc > 8) ? strjoin(this->s, strjoin(" ", copyinstr((user_addr_t)this->argv[8]))) : this->s;
      this->s = strjoin(this->s, "\"");
    }
    this->s = strjoin(this->s, "}\n");
    printf("%s", this->s);


    this->s = 0;
}

proc:::exit
/parent != 0 && progenyof(parent)/
{
    this->now = timestamp;
    this->elapsed = this->now - start[pid];

    // Print the process name and the elapsed time in milliseconds.
    printf(",{\"ph\":\"E\", \"ppid\":%d, \"pid\":%d, \"tid\": %d, \"ts\":%d, \"name\":\"%s\", \"elapsed\":%d}\n",
            ppid,
            pid,
            tid,
            this->now/1000, // us.
        process_name[pid] == "" ? "" : process_name[pid],
        this->elapsed / 1000000); // ms.

    process_name[pid] = 0;
    start[pid]=0;
}

END {
  printf("]\n");
}
