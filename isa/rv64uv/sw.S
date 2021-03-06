#*****************************************************************************
# sw.S
#-----------------------------------------------------------------------------
#
# Test sw instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  li a4,512
  vvcfgivl a4,a4,16,0

  la a6,dest
  li a2,0

initloop:
  sd x0,0(a6)
  addi a6,a6,8
  addi a2,a2,1
  bne a2,a4,initloop
  fence

  la a5,src
  vld vx1,a5
  la a6,dest
  vmsv vx2,a6
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  fence.v.l

  li a2,0
loop:
  ld a0,0(a6)
  ld a1,0(a5)
  sll a3,a1,32
  srl a3,a3,32
  addi x28,a2,2
  bne a0,a3,fail
  addi a6,a6,8
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a4,loop
  j pass

vtcode:
  utidx x3
  slli x3,x3,3
  add x2,x2,x3
  sw x1,0(x2)
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src:
#include "data_d.h"

dest:
  .skip 16384

RVTEST_DATA_END
