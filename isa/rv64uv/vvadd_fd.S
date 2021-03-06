#*****************************************************************************
# vvadd_fd.S
#-----------------------------------------------------------------------------
#
# Test vvadd fd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  li a3,4
  vvcfgivl a3,a3,32,32

  la a3,src1
  la a4,src2
  vfld vf2,a3
  vfld vf3,a4
  lui a0,%hi(vtcode)
  vf %lo(vtcode)(a0)
  la a5,dest
  vfsd vf2,a5
  fence.v.l
  la a5,result
  ld a1,0(a5)
  ld a2,0(a5)
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
  j pass

vtcode:
  fadd.d f2,f2,f3
  stop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .double 0.1
  .double 0.2
  .double 0.3
  .double 0.4
src2:
  .double 0.4
  .double 0.3
  .double 0.2
  .double 0.1
dest:
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
result:
  .double 0.5
  .double 0.5
  .double 0.5
  .double 0.5

RVTEST_DATA_END
