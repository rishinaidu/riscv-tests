#*****************************************************************************
# vvadd_fw.S
#-----------------------------------------------------------------------------
#
# Test vvadd fw.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  li a3,4
  vvcfgivl a3,a3,32,32

  la a3,src1
  la a4,src2
  vflw vf2,a3
  vflw vf3,a4
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a5,dest
  vfsw vf2,a5
  fence.v.l
  la a6,result
  lw a1,0(a5)
  lw a2,0(a6)
  li x28,2
  bne a1,a2,fail
  lw a1,8(a5)
  li x28,3
  bne a1,a2,fail
  lw a1,16(a5)
  li x28,4
  bne a1,a2,fail
  lw a1,24(a5)
  li x28,5
  bne a1,a2,fail
  j pass

vtcode:
  fadd.s f2,f2,f3
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .single 0.1
  .single 0.2
  .single 0.3
  .single 0.4
src2:
  .single 0.4
  .single 0.3
  .single 0.2
  .single 0.1
dest:
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
  .word 0xdeadbeef
result:
  .single 0.5
  .single 0.5
  .single 0.5
  .single 0.5

RVTEST_DATA_END
