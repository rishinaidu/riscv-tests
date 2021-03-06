#*****************************************************************************
# wakeup.S
#-----------------------------------------------------------------------------
#
# Test wakeup.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # make sure these don't choke at the beginning
  fence.v.l
  fence.v.l
  fence.v.g
  fence.v.g

  # this shouldn't go through since app vl is zero
  la a3,src1
  la a4,src2
  vld vx2,a3
  vld vx3,a4
  lui a0,%hi(vtcode1)
  vf %lo(vtcode1)(a0)
  la a5,dest
  vsd vx2,a5
  fence.v.l

  ld a1,0(a5)
  li a2,0xdeadbeefcafebabe
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

  # check default hw vector length, which is 32
  li a3, 32
  vsetvl a3, a3
  li a0, 32
  li x28, 6
  bne a3, a0, fail

  li a3, 33
  vsetvl a3, a3
  li a0, 32
  li x28, 7
  bne a3, a0, fail

  li a3, 31
  vsetvl a3, a3
  li a0, 31
  li x28, 8
  bne a3, a0, fail

  # now do some vector stuff without vvcfgivl
  vsetvl x0, x0

  li a3, 4
  la a4,src1
  la a5,src2
  vsetvl a3, a3
  vld vx2,a4
  vld vx3,a5
  lui a0,%hi(vtcode1)
  vf %lo(vtcode1)(a0)
  la a5,dest
  vsd vx2,a5
  fence.v.l

  ld a1,0(a5)
  li a2,5
  li x28,9
  bne a1,a2,fail
  ld a1,8(a5)
  li x28,10
  bne a1,a2,fail
  ld a1,16(a5)
  li x28,11
  bne a1,a2,fail
  ld a1,24(a5)
  li x28,12
  bne a1,a2,fail

  # initialize dest memory
  li a3, 0xdeadbeefcafebabe
  sd a3, 0(a5)
  sd a3, 8(a5)
  sd a3, 16(a5)
  sd a3, 24(a5)

  # test app vl zero again
  li a3, 0
  vsetvl a3, a3

  la a3,src1
  la a4,src2
  vld vx2,a3
  vld vx3,a4
  lui a0,%hi(vtcode1)
  vf %lo(vtcode1)(a0)
  la a5,dest
  vsd vx2,a5
  fence.v.l

  ld a1,0(a5)
  li a2,0xdeadbeefcafebabe
  li x28,13
  bne a1,a2,fail
  ld a1,8(a5)
  li x28,14
  bne a1,a2,fail
  ld a1,16(a5)
  li x28,15
  bne a1,a2,fail
  ld a1,24(a5)
  li x28,16
  bne a1,a2,fail

  j pass

vtcode1:
  add x2,x2,x3
  stop

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
