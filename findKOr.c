#include <stdio.h>

int findKOr(int* nums, int numsSize, int k) {
  /* Assume bitwidth of int is 32-bit */
  int res = 0;
  int bit_cnt[32] = {0};
  for (int n = 0; n < numsSize; ++n) {
    int num = nums[n];
    for (int bit_idx = 0; bit_idx < 32; ++bit_idx) {
      if (num & ((unsigned)1 << bit_idx)) {
        if (++bit_cnt[bit_idx] == k) {
          res |= 1 << bit_idx;
        }
      }
    }
  }
  return res;
}

int main (void) {
  int nums[6] = {7, 12, 9, 8, 9, 15};
  int res = findKOr(nums, 6, 4);
  printf("res: %d\n", res);
  return 0;
}
