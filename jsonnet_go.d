#!/usr/sbin/dtrace -s

// Log and time evaluation of Jsonnet scripts.
// Tweak the function name if needed.

pid$target::github.com?ory?x?jsonnetsecure.(?processPoolVM).EvaluateAnonymousSnippet:entry /progenyof($target)/ {
  ustack();
  printf("filename=%s snippet=%s", stringof(copyin(arg1, arg2)),stringof(copyin(arg3, arg4)));
} 

pid$target::github.com?ory?x?jsonnetsecure.(?processPoolVM).EvaluateAnonymousSnippet:return /progenyof($target)/ {
  ustack();
  
  printf("arg0=%d arg1=%d arg2=%d arg3=%d", arg0, arg1, arg2, arg3);
  printf("result=%s", stringof(copyin(arg1, arg0)));
} 
