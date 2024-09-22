#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define N 1024

__global__ void add(int *a, int *b, int *c) {
  int tid = threadIdx.x;
  c[tid] = a[tid] + b[tid];
}

int main() {
  int *a, *b, *c;
  int *d_a, *d_b, *d_c;
  int i;

  a = (int *)malloc(N * sizeof(int));
  b = (int *)malloc(N * sizeof(int));
  c = (int *)malloc(N * sizeof(int));

  for (i = 0; i < N; i++) {
    a[i] = i;
    b[i] = i;
  }

  cudaMalloc((void **)&d_a, N * sizeof(int));
  cudaMalloc((void **)&d_b, N * sizeof(int));
  cudaMalloc((void **)&d_c, N * sizeof(int));

  cudaMemcpy(d_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

  add<<<1, N>>>(d_a, d_b, d_c);

  cudaMemcpy(c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost);

  for (i = 0; i < N; i++) {
    printf("%d\n", c[i]);
  }

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  free(a);
  free(b);
  free(c);

  return 0;
}