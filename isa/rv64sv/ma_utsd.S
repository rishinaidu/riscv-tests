#*****************************************************************************
# ma_utsd.S
#-----------------------------------------------------------------------------
#
# Test misaligned ut sd trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  mfpcr a3,cr0
  li a4,1
  slli a5,a4,8
  or a3,a3,a4 # enable traps
  mtpcr a3,cr0

  la a3,handler
  mtpcr a3,cr3 # set exception handler

  li a3,4
  vvcfgivl a3,a3,32,0

  la a3, dest+1
  vmsv vx1, a3
  lui a0,%hi(vtcode1)
  vf %lo(vtcode1)(a0)
  la a3, dest+1
  vsd vx1, a3
  fence.v.l

vtcode1:
  sw x2, 0(x1)
  stop

vtcode2:
  add x2,x2,x3
  stop

handler:
  vxcptkill

  li x28,2

  # check cause
  mfpcr a3,cr6
  li a4,29
  bne a3,a4,fail

  # check vec irq aux
  mfpcr a3,cr2
  la a4, dest+1
  bne a3,a4,fail

  # make sure vector unit has cleared out
  li a3,4
  vvcfgivl a3,a3,32,0

  la a3,src1
  la a4,src2
  vld vx2,a3
  vld vx3,a4
  lui a0,%hi(vtcode2)
  vf %lo(vtcode2)(a0)
  la a5,dest
  vsd vx2,a5
  fence.v.l

  ld a1,0(a5)
  li a2,5
  li x28,2
  bne a1,a2,fail
  ld a1,8(a5)
  li x28,3
  bne a1,a2,fail
  ld a1,16(a5)
  li x28,4
  bne a1,a2,fail
  ld a1,24(a5)
  li x28,5
  bne a1,a2,fail

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
