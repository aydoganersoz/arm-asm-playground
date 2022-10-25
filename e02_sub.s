.global _start

_start:
  // return
  mov r0, #0              // store success value

end:                      // end condition
  b end                   // endless loop