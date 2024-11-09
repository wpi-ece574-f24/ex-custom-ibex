#include <stdbool.h>
#include "dev_access.h"
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

  puthex((overhead = elapsed()));
  putchar('\n');

  DEV_WRITE(0x80005000, 0x12345678); 
  DEV_WRITE(0x80005004, 0x12345678); 

  puthex(elapsed() - overhead);
  putchar('\n');

  // give uart time to flush out
  for (overhead=0; overhead<20000; overhead++) ;

  // exit the simulation
  sim_halt();

  return 0;
}
