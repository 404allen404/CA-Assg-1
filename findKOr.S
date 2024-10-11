.data
# Number arrays
nums1: .word 7, 12, 9, 8, 9, 15
nums2: .word 13432, 343, 4, 143, 3411, 23
nums3: .word 533, 5552, 24, 55, 8792, 9889

# Test case structure: address of array, size of array, k, expected result
test_cases:
  .word nums1, 6, 4, 9
  .word nums2, 6, 2, 1375
  .word nums3, 6, 5, 16
  .word 0 # End marker

str_test: .string "Test case "
str_pass: .string " passed\n"
str_fail: .string " failed. Expected: "
str_got:  .string ", Got: "
str_nl:   .string "\n" 

.text
main:
  la s0, test_cases      # s0 points to the current test case
  addi s1, x0, 1         # s1 is the test case counter
run_tests:
  lw t0, 0(s0)           # Load address of nums
  beq t0, x0, end_tests  # If address is 0, end tests

  lw a0, 0(s0)           # Load address of nums
  lw a1, 4(s0)           # Load size
  lw a2, 8(s0)           # Load k
  lw a3, 12(s0)          # Load expected result

  jal ra, findKOr
  # Check result
  beq a0, a3, test_passed

  # Test failed
  la a0, str_test
  li a7, 4
  ecall
  add a0, x0, s1
  li a7, 1
  ecall
  la a0, str_fail
  li a7, 4
  ecall
  add a0, x0, a3 # Expected result
  li a7, 1
  ecall
  la a0, str_got
  li a7, 4
  ecall
  add a0, x0, t0 # Actual result
  li a7, 1
  ecall
  la a0, str_nl
  li a7, 4
  ecall
  jal x0, next_test

test_passed:
  la a0, str_test
  li a7, 4
  ecall
  mv a0, s1
  li a7, 1
  ecall
  la a0, str_pass
  li a7, 4
  ecall

next_test:
  addi s0, s0, 16 # Move to next test case
  addi s1, s1, 1  # Increment test case counter
  jal x0, run_tests

end_tests:
  li a7, 10
  ecall 

findKOr:
  addi sp, sp, -144
  sw ra, 128(sp)
  sw a2, 132(sp) # k
  sw a1, 136(sp) # numsSize
  sw a0, 140(sp) # address of nums

  add t0, x0, x0  # t0 = res = 0
  add t1, x0, x0  # t1 = n = 0
  addi t4, x0, 32 # t4 = 32

clear_bit_cnt_init:
  add t2, x0, x0
  addi t3, x0, 32
  add t5, sp, x0 # t5 = sp
clear_bit_cnt:
  bge t2, t3, findKOr_loop_0
  sw x0, 0(t5)
  addi t5, t5, 4
  addi t2, t2, 1
  jal x0, clear_bit_cnt

findKOr_loop_0:
  bge t1, a1, findKOr_end # n >= numsSize
  slli t3, t1, 2          # t3 = 4 * n 
  add t3, t3, a0          # t3 = a0 + 4 * n
  lw t2, 0(t3)            # t2 = num
  add t3, x0, x0          # t3 = bit_idx = 0

findKOr_loop_1:
  bge t3, t4, findKOr_loop_0_pre # bit_idx >= 32

  addi t5, x0, 1 # t5 = 1
  sll t5, t5, t3 # t5 = 1 << bit_idx
  and t5, t5, t2 # t5 = num & (1 << bit_idx)

  beq t5, x0, findKOr_loop_1_pre

  slli t5, t3, 2  # t5 = bit_idx * 4
  add t5, t5, sp  
  lw t6, 0(t5)    # t6 = bit_cnt[bit_idx]
  addi t6, t6, 1  # t6 = t6 + 1
  sw t6, 0(t5)
  bne t6, a2, findKOr_loop_1_pre
  
  addi t5, x0, 1 # t5 = 1
  sll t5, t5, t3 # t5 = 1 << bit_idx
  or t0, t0, t5  # res |= 1 << bit_idx

findKOr_loop_1_pre:
  addi t3, t3, 1 # ++bit_idx
  j findKOr_loop_1

findKOr_loop_0_pre:
  addi t1, t1, 1 # ++n
  j findKOr_loop_0

findKOr_end:
  lw ra, 128(sp)
  lw a2, 132(sp)
  lw a1, 136(sp)
  lw a0, 140(sp)
  addi sp, sp, 144
  add a0, t0, x0
  ret

  
