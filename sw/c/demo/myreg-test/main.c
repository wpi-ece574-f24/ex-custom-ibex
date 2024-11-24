#include <stdbool.h>
#include "dev_access.h"
#include "demo_system.h"
#include "timer.h"

#define REG1 0x80005000
#define REG2 0x80005004

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
  uint32_t reg1, reg2;

  puthex((overhead = elapsed()));
  putchar('\n');

  DEV_WRITE(REG1, 0x1);   // reg1 = 1; reg2 = 0 (oldreg1) + 0 (oldreg2) = 0
  DEV_WRITE(REG2, 0x2);   // reg2 = 2; reg1 = 0 (oldreg2) + 1 (oldreg1) = 1;

  reg1 = DEV_READ(REG1);  // 1
  reg2 = DEV_READ(REG2);  // 2

  puts("REG1 ");
  puthex(reg1);
  putchar('\n');

  puts("REG2 ");
  puthex(reg2);
  putchar('\n');

  DEV_WRITE(REG1, 0x3);   // reg1 = 3; reg2 = 2 (oldreg2) + 1 (oldreg1) = 3
  DEV_WRITE(REG2, 0x4);   // reg2 = 4; reg1 = 3 (oldreg1) + 3 (oldreg2) = 6;

  reg1 = DEV_READ(REG1);  // 6
  reg2 = DEV_READ(REG2);  // 4

  puts("REG1 ");
  puthex(reg1);
  putchar('\n');

  puts("REG2 ");
  puthex(reg2);
  putchar('\n');

  puthex(elapsed() - overhead);
  putchar('\n');

  // give uart time to flush out
  for (overhead=0; overhead<70000; overhead++) ;

  // exit the simulation
  sim_halt();

  return 0;
}
