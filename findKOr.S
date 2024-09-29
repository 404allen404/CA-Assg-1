.data
nums: .word 7, 12, 9, 8, 9, 15
numsSize: .word 6
k: .word 4
str_1: .string "res: "
str_2: .string "\n"    

.text
main:
  la a0, nums
  lw a1, numsSize
  lw a2, k
  jal ra, findKOr

  jal ra, printResult

  li a7, 10
  ecall

findKOr:
  addi sp, sp, -144
clear_bit_cnt:
  sw x0, 0(sp)
  sw x0, 4(sp)
  sw x0, 8(sp)
  sw x0, 12(sp)
  sw x0, 16(sp)
  sw x0, 20(sp)
  sw x0, 24(sp)
  sw x0, 28(sp)
  sw x0, 32(sp)
  sw x0, 36(sp)
  sw x0, 40(sp)
  sw x0, 44(sp)
  sw x0, 48(sp)
  sw x0, 52(sp)
  sw x0, 56(sp)
  sw x0, 60(sp)
  sw x0, 64(sp)
  sw x0, 68(sp)
  sw x0, 72(sp)
  sw x0, 76(sp)
  sw x0, 80(sp)
  sw x0, 84(sp)
  sw x0, 88(sp)
  sw x0, 92(sp)
  sw x0, 96(sp)
  sw x0, 100(sp)
  sw x0, 104(sp)
  sw x0, 108(sp)
  sw x0, 112(sp)
  sw x0, 116(sp)
  sw x0, 120(sp)
  sw x0, 124(sp)
store_arg:
  sw ra, 128(sp)
  sw a2, 132(sp) # k
  sw a1, 136(sp) # numsSize
  sw a0, 140(sp) # address of nums

add t0, x0, x0  # t0 = res = 0
add t1, x0, x0  # t1 = n = 0
addi t4, x0, 32 # t4 = 32

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

printResult:
  add t0, a0, x0

  la a0, str_1
  li a7, 4
  ecall

  add a0, t0, x0
  li a7, 1
  ecall

  la a0, str_2
  li a7, 4
  ecall

  ret
  
