#*****************************************************************************
# fcvt.S
#-----------------------------------------------------------------------------
#
# Test fcvt instruction in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  li a3,4
  vvcfgivl a3,a3,32,32

  la a3,src
  vld vx2,a3
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a4,dest
  vfsd vf0,a4
  fence.v.l
  la a5,result
  ld a1,0(a4)
  ld a2,0(a5)
  li x28,2
  bne a1,a2,fail
  ld a1,8(a4)
  ld a2,8(a5)
  li x28,3
  bne a1,a2,fail
  ld a1,16(a4)
  ld a2,16(a5)
  li x28,4
  bne a1,a2,fail
  ld a1,24(a4)
  ld a2,24(a5)
  li x28,5
  bne a1,a2,fail
  j pass

vtcode:
  fcvt.d.l f0,x2
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src:
  .dword 1
  .dword 2
  .dword 3
  .dword 4
dest:
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
result:
  .double 1.0
  .double 2.0
  .double 3.0
  .double 4.0

RVTEST_DATA_END
