#*****************************************************************************
# fmovz.S
#-----------------------------------------------------------------------------
#
# Test fmovz instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  li a6,2048
  vvcfgivl a6,a6,4,2

  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a7,dest
  vfsd vf0,a7
  fence.v.l

  li a1,0
  li a2,-1
loop:
  ld a0,0(a7)
  slti a4,a1,10
  slli a4,a4,63
  srai a4,a4,63
  xori a4,a4,-1
  and a5,a2,a4
  addi x28,a1,2
  bne a0,a5,fail
  addi a7,a7,8
  addi a1,a1,1
  bne a1,a6,loop
  j pass

vtcode:
  utidx x1
  slti x2,x1,10
  li x1,-1
  li x3,0
  mxtf.d f0,x3
  mxtf.d f1,x1
  fmovz f0,x2,f1
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

dest:
  .skip 16384

RVTEST_DATA_END
