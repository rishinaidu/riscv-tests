#*****************************************************************************
# structural.S
#-----------------------------------------------------------------------------
#
# This test verifies that the FPU correctly obviates structural hazards on its
# writeback port (e.g. fadd followed by fsgnj)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

li x25, 1

li x2, 0x3FF0000000000000
li x1, 0x3F800000

#define TEST(nops, errcode)     \
  mxtf.d  f4, x0    ;\
  mxtf.s  f3, x0    ;\
  mxtf.d  f2, x2    ;\
  mxtf.s  f1, x1    ;\
  b 1f ;\
  .align 5        ;\
1:fmul.d  f4, f2, f2  ;\
  nops          ;\
  fsgnj.s f3, f1, f1 ;\
  mftx.d  x4, f4    ;\
  mftx.s  x3, f3    ;\
  beq     x1, x3, 2f  ;\
  RVTEST_FAIL ;\
2:beq     x2, x4, 2f  ;\
  RVTEST_FAIL; \
2:mxtf.d  f2, zero    ;\
  mxtf.s  f1, zero    ;\

TEST(;,2)
TEST(nop,4)
TEST(nop;nop,6)
TEST(nop;nop;nop,8)
TEST(nop;nop;nop;nop,10)
TEST(nop;nop;nop;nop;nop,12)
TEST(nop;nop;nop;nop;nop;nop,14)

RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
