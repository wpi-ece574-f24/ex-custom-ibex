#include <stdbool.h>
#include "demo_system.h"

volatile int* myreg = (int *) 0x80005000;

int main(void) {

  volatile char* c  = (char *) myreg;
  volatile short* s = (short *) myreg;

  myreg[0] = 0x12345678;
  myreg[1] = 0xabcdffff;
  c[0] = 0xAA;
  c[1] = 0xAA;
  c[2] = 0xAA;
  c[3] = 0xAA;
  c[4] = 0xAA;
  c[5] = 0xAA;
  c[6] = 0xAA;
  c[7] = 0xAA;
  c[8] = 0xAA;
  s[0] = 0xBBCC;
  s[1] = 0xBBCC;
  s[2] = 0xBBCC;
  s[3] = 0xBBCC;

  sim_halt();

  return 0;
}
