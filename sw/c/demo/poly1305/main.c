#include "poly1305.h"
#include "demo_system.h"
#include "timer.h"

uint8_t key[32] = {0x85,0xd6,0xbe,0x78,0x57,0x55,0x6d,0x33,0x7f,0x44,0x52,0xfe,0x42,0xd5,0x06,0xa8,
		   0x01,0x03,0x80,0x8a,0xfb,0x0d,0xb2,0xfd,0x4a,0xbf,0xf6,0xaf,0x41,0x49,0xf5,0x1b};

uint8_t block1[16] = {0x43,0x72,0x79,0x70,0x74,0x6f,0x67,0x72,0x61,0x70,0x68,0x69,0x63,0x20,0x46,0x6f};
size_t  block1len  = 16;

uint8_t block2[16] = {0x72,0x75,0x6d,0x20,0x52,0x65,0x73,0x65,0x61,0x72,0x63,0x68,0x20,0x47,0x72,0x6f};
size_t  block2len  = 16;

uint8_t block3[16]  = {0x75,0x70};
size_t  block3len  = 2;

uint8_t tag[16];

void showBlock(const uint8_t *data, size_t length) {
  uint8_t n;
  uint8_t d;
  for (n=0; n<length; n++) {
    d = (data[n] >> 4) & 0xf;
    putchar((d > 9) ? d - 10 + 'A' : d + '0');
    d = data[n] & 0xf;
    putchar((d > 9) ? d - 10 + 'A' : d + '0');
  }
  putchar('\n');
}

void showPoly(const Poly1305Context *p) {
  uint8_t n;

  puts("R  as a number ");
  puthex(p->r[3]); putchar(' ');
  puthex(p->r[2]); putchar(' ');
  puthex(p->r[1]); putchar(' ');
  puthex(p->r[0]); putchar('\n');

  puts("S  as a number ");
  puthex(p->s[3]); putchar(' ');
  puthex(p->s[2]); putchar(' ');
  puthex(p->s[1]); putchar(' ');
  puthex(p->s[0]); putchar('\n');

  puts("A* as a number ");
  puthex((uint32_t) (p->a[4])); putchar(' ');
  puthex((uint32_t) (p->a[3])); putchar(' ');
  puthex((uint32_t) (p->a[2])); putchar(' ');
  puthex((uint32_t) (p->a[1])); putchar(' ');
  puthex((uint32_t) (p->a[0])); putchar('\n');

  puts("Buffer ");
  for (n=0; n<17; n++) {
    char d;
    d = (p->buffer[n] >> 4) & 0xf;
    putchar((d > 9) ? d - 10 + 'A' : d + '0');
    d = p->buffer[n] & 0xf;
    putchar((d > 9) ? d - 10 + 'A' : d + '0');
  }
  putchar(' ');
  putchar('(');
  for (n=0; n<17; n++)
    putchar(p->buffer[n]);
  putchar(')');
  putchar('\n');

}

void main() {

  Poly1305Context c;

  uint64_t init_cycles;
  uint64_t block_cycles;
  uint64_t final_cycles;
  uint64_t stamp;

  timer_init();
  
  puts("--key:\n");
  stamp = timer_read();
  poly1305Init(&c, key);
  init_cycles = timer_read() - stamp;
  showPoly(&c);
  
  puts("--block1:\n");
  stamp = timer_read();
  poly1305Update(&c, block1, block1len);
  block_cycles = timer_read() - stamp;
  showPoly(&c);
  
  puts("--block2:\n");
  poly1305Update(&c, block2, block2len);
  showPoly(&c);
  
  puts("--block3:\n");
  poly1305Update(&c, block3, block3len);
  showPoly(&c);
  
  puts("--final:\n");
  stamp = timer_read();
  poly1305Final(&c, tag);
  final_cycles = timer_read() - stamp;
  showPoly(&c);

  puts("--tag:\n");
  showBlock(tag, 16);

  puts("--poly1305 performance:\n");
  puts("Init:  ");
  puthex((uint32_t) (init_cycles >> 32)); 
  puthex((uint32_t) (init_cycles)); 
  putchar('\n');
  puts("Block: ");
  puthex((uint32_t) (block_cycles >> 32)); 
  puthex((uint32_t) (block_cycles)); 
  putchar('\n');
  puts("Final: ");
  puthex((uint32_t) (final_cycles >> 32)); 
  puthex((uint32_t) (final_cycles)); 
  putchar('\n');

  // delay the simulator before halting so all output is flushed
  stamp = timer_read();
  while ((timer_read() - stamp) < 700000) ;

  sim_halt();
}
