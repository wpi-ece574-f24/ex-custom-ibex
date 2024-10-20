// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "custom_ibex_system.h"

int main(int argc, char **argv) {
  DemoSystem demo_system(
      "TOP.top_verilator.u_ibex_demo_system.u_ram.u_ram.gen_generic.u_impl_generic",
      1024 * 1024);

  return demo_system.Main(argc, argv);
}
