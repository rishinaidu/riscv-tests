#*****************************************************************************
# vmsv.S
#-----------------------------------------------------------------------------
#
# Test vmsv instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  li a2,2048
  vvcfgivl a2,a2,3,0

  li a3,-1
  vmsv vx2,a3
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a4,dest
  vsd vx2,a4
  fence.v.l

  li a1,0
loop:
  ld a0,0(a4)
  addi x28,a1,2
  bne a0,a1,fail
  addi a4,a4,8
  addi a1,a1,1
  bne a1,a2,loop
  j pass

vtcode:
  utidx x1
  addi x1,x1,1
  add x2,x1,x2
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

dest:
  .skip 16384

RVTEST_DATA_END
