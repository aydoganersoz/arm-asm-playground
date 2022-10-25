.global _start

_start:
  // simple addition
  mov r1, #4              // move 4 to r1
  mov r2, #2              // move 2 to r2
  add r0, r1, r2          // add r1 and r2 and store the result in r0
  cmp r0, #6              // compare r0 with 6
  mov r0, #1              // store the error value
  bne end                 // branch if the comparison fails

  // addition without overflow
  mov r1, #0x7ffffffe     // move 0x7ffffffe to r1
  mov r2, #0x01           // move 0x01 to r2
  adds r0, r1, r2         // add r1 and r2 and store the result in r0 and update condition flags
  mov r0, #2              // store the error value
  bvs end                 // branch if overflow bit (v) is set

  // addition with overflow
  mov r1, #0x7fffffff     // move 0x7fffffff to r1
  mov r2, #0x01           // move 0x01 to r2
  adds r0, r1, r2         // add r1 and r2 and store the result in r0 and update condition flags
  mov r0, #3              // store the error value
  bvc end                 // branch if overflow bit (v) is clear
  
  // addition resulting negative
  mov r1, #0x7fffffff     // move 0x7fffffff to r1
  mov r2, #0x01           // move 0x01 to r2
  adds r0, r1, r2         // add r1 and r2 and store the result in r0 and update condition flags
  mov r0, #3              // store the error value
  bpl end                 // branch if negative bit (n) is clear
  
  // clear n, z, c and v bits
  mrs r0, cpsr            // move cpsr register value to r0
  bic r0, r0, #0xf0000000 // clear the four highest bits
  msr cpsr_f, r0          // move the content of r0 to coprocessor register
  
  // addition resulting negative but cpsr flags are not updated
  mov r1, #0x7fffffff     // move 0x7fffffff to r1
  mov r2, #0x01           // move 0x01 to r2
  add r0, r1, r2          // add r1 and r2 and store the result in r0 and do not update condition flags
  mov r0, #4              // store the error value
  bmi end                 // branch if negative bit (n) is set

  // addition with carry and zero bits set
  mov r1, #0xffffffff     // move 0xffffffff to r1
  mov r2, #0x01           // move 0x01 to r2
  adds r0, r1, r2         // add r1 and r2 and store the result in r0 and do not update condition flags
  mov r0, #5              // store the error value
  bcc end                 // branch if carry bit (n) is clear
  mov r0, #6              // store the error value
  bne end                 // branch if zero bit (n) is clear

  // clear n, z, c and v bits
  mrs r0, cpsr            // move cpsr register value to r0
  bic r0, r0, #0xf0000000 // clear the four highest bits
  msr cpsr_f, r0          // move the content of r0 to coprocessor register

  // add if zero flag is set
  mov r0, #0              // move 0 to r0
  mov r1, #1              // move 1 to r1
  mov r2, #2              // move 2 to r2
  addeqs r0, r1, r2       // if zero flag is set then add r1 and r2 and store the result in r0 and update condition flags
  cmp r0, #0              // compare r0 with 0
  mov r0, #7              // store the error value
  bne end                 // branch if the comparison fails

  // return
  mov r0, #0              // store success value

end:                      // end condition
  b end                   // endless loop