#include <stdbool.h>

#include "demo_system.h"
#include "gpio.h"
#include "pwm.h"
#include "timer.h"

int main(void) {

  int i;

  for (i=0; i<8; i++)
    set_outputs(GPIO_OUT, i);

  sim_halt();

}
