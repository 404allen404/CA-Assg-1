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
  int k[3] = {4, 2, 5};
  int nums[3][6] = {
    {7, 12, 9, 8, 9, 15}, // answer is 9
    {13432, 343, 4, 143, 3411, 23}, // answer is 1375
    {533, 5552, 24, 55, 8792, 9889} // answer is 16
  };
  int answer[3] = {9, 1375, 16};

  for (int i = 0; i < 3; ++i) {
    int res = findKOr(nums[i], 6, k[i]);
    if (res == answer[i]) {
      printf("Test case %d passed\n", i + 1);
    } else {
      printf("Test case %d failed. Expected: %d, Got: %d\n", i + 1, answer[i], res);
    }
  }

  return 0;
}
