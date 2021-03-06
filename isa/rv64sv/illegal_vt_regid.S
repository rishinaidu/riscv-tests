#*****************************************************************************
# xcpt_illegal_vt_regid.S
#-----------------------------------------------------------------------------
#
# Test illegal vt regid trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  mfpcr a0,cr0
  li a1,1
  slli a2,a1,8
  or a0,a0,a1 # enable traps
  mtpcr a0,cr0

  TEST_ILLEGAL_VT_REGID(2, 5, 5, add, x7, x1, x2)
  TEST_ILLEGAL_VT_REGID(3, 5, 5, add, x1, x7, x2)
  TEST_ILLEGAL_VT_REGID(4, 5, 5, add, x1, x2, x7)

  TEST_ILLEGAL_VT_REGID(5, 5, 5, fadd.d, f7, f1, f2)
  TEST_ILLEGAL_VT_REGID(6, 5, 5, fadd.d, f1, f7, f2)
  TEST_ILLEGAL_VT_REGID(7, 5, 5, fadd.d, f1, f2, f7)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .dword 1
  .dword 2
  .dword 3
  .dword 4
src2:
  .dword 4
  .dword 3
  .dword 2
  .dword 1
dest:
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe

RVTEST_DATA_END
