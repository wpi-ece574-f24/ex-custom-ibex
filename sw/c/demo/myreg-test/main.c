#include <stdbool.h>
#include "demo_system.h"
#include "timer.h"

volatile int* myreg = (int *) 0x80005000;

uint32_t elapsed() {
  uint32_t e;
  static uint64_t last = 0L;

  uint64_t stamp = timer_read();

  e = stamp - last;
  last = stamp;

  return e;
}

int main(void) {
  uint32_t overhead;

  volatile char* c  = (char *) myreg;
  volatile short* s = (short *) myreg;

  puthex((overhead = elapsed()));
  putchar('\n');
  puthex((overhead = elapsed()));
  putchar('\n');
  puthex((overhead = elapsed()));
  putchar('\n');
  puthex((overhead = elapsed()));
  putchar('\n');

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

  puthex(elapsed() - overhead);
  putchar('\n');

  s[0] = 0xBBCC;
  s[1] = 0xBBCC;
  s[2] = 0xBBCC;
  s[3] = 0xBBCC;

  puthex(elapsed() - overhead);
  putchar('\n');

  s[0] = 0xBBCC;
  s[1] = 0xBBCC;

  puthex(elapsed() - overhead);
  putchar('\n');

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

  puthex(elapsed() - overhead);
  putchar('\n');

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

  puthex(elapsed() - overhead);
  putchar('\n');

  while (1) ;

  return 0;
}
