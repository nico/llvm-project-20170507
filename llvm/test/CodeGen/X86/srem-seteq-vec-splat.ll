; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+sse2 < %s | FileCheck %s --check-prefixes=CHECK,CHECK-SSE,CHECK-SSE2
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+sse4.1 < %s | FileCheck %s --check-prefixes=CHECK,CHECK-SSE,CHECK-SSE41
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx < %s | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX1
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 < %s | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX2
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+avx512vl < %s | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX512VL

; Odd divisor
define <4 x i32> @test_srem_odd_25(<4 x i32> %X) nounwind {
; CHECK-SSE2-LABEL: test_srem_odd_25:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; CHECK-SSE2-NEXT:    pxor %xmm3, %xmm3
; CHECK-SSE2-NEXT:    pxor %xmm4, %xmm4
; CHECK-SSE2-NEXT:    pcmpgtd %xmm0, %xmm4
; CHECK-SSE2-NEXT:    pand %xmm1, %xmm4
; CHECK-SSE2-NEXT:    psubd %xmm4, %xmm2
; CHECK-SSE2-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE2-NEXT:    psrld $31, %xmm1
; CHECK-SSE2-NEXT:    psrad $3, %xmm2
; CHECK-SSE2-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [25,25,25,25]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm2[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm4
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm4[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_srem_odd_25:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE41-NEXT:    pmuldq %xmm2, %xmm1
; CHECK-SSE41-NEXT:    pmuldq %xmm0, %xmm2
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE41-NEXT:    psrld $31, %xmm1
; CHECK-SSE41-NEXT:    psrad $3, %xmm2
; CHECK-SSE41-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm2
; CHECK-SSE41-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_srem_odd_25:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX1-NEXT:    vpsrad $3, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_srem_odd_25:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX2-NEXT:    vpsrad $3, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [25,25,25,25]
; CHECK-AVX2-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_srem_odd_25:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX512VL-NEXT:    vpsrad $3, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 25, i32 25, i32 25, i32 25>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Even divisors
define <4 x i32> @test_srem_even_100(<4 x i32> %X) nounwind {
; CHECK-SSE2-LABEL: test_srem_even_100:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; CHECK-SSE2-NEXT:    pxor %xmm3, %xmm3
; CHECK-SSE2-NEXT:    pxor %xmm4, %xmm4
; CHECK-SSE2-NEXT:    pcmpgtd %xmm0, %xmm4
; CHECK-SSE2-NEXT:    pand %xmm1, %xmm4
; CHECK-SSE2-NEXT:    psubd %xmm4, %xmm2
; CHECK-SSE2-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE2-NEXT:    psrld $31, %xmm1
; CHECK-SSE2-NEXT:    psrad $5, %xmm2
; CHECK-SSE2-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [100,100,100,100]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm2[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm4
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm4[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_srem_even_100:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE41-NEXT:    pmuldq %xmm2, %xmm1
; CHECK-SSE41-NEXT:    pmuldq %xmm0, %xmm2
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE41-NEXT:    psrld $31, %xmm1
; CHECK-SSE41-NEXT:    psrad $5, %xmm2
; CHECK-SSE41-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm2
; CHECK-SSE41-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_srem_even_100:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX1-NEXT:    vpsrad $5, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_srem_even_100:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX2-NEXT:    vpsrad $5, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [100,100,100,100]
; CHECK-AVX2-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_srem_even_100:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX512VL-NEXT:    vpsrad $5, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 100, i32 100, i32 100, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;
; Comparison constant has undef elements.
;------------------------------------------------------------------------------;

define <4 x i32> @test_srem_odd_undef1(<4 x i32> %X) nounwind {
; CHECK-SSE2-LABEL: test_srem_odd_undef1:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; CHECK-SSE2-NEXT:    pxor %xmm3, %xmm3
; CHECK-SSE2-NEXT:    pxor %xmm4, %xmm4
; CHECK-SSE2-NEXT:    pcmpgtd %xmm0, %xmm4
; CHECK-SSE2-NEXT:    pand %xmm1, %xmm4
; CHECK-SSE2-NEXT:    psubd %xmm4, %xmm2
; CHECK-SSE2-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE2-NEXT:    psrld $31, %xmm1
; CHECK-SSE2-NEXT:    psrad $3, %xmm2
; CHECK-SSE2-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [25,25,25,25]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm2[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm4
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm4[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_srem_odd_undef1:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE41-NEXT:    pmuldq %xmm2, %xmm1
; CHECK-SSE41-NEXT:    pmuldq %xmm0, %xmm2
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE41-NEXT:    psrld $31, %xmm1
; CHECK-SSE41-NEXT:    psrad $3, %xmm2
; CHECK-SSE41-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm2
; CHECK-SSE41-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_srem_odd_undef1:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX1-NEXT:    vpsrad $3, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_srem_odd_undef1:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX2-NEXT:    vpsrad $3, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [25,25,25,25]
; CHECK-AVX2-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_srem_odd_undef1:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX512VL-NEXT:    vpsrad $3, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 25, i32 25, i32 25, i32 25>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 undef, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

define <4 x i32> @test_srem_even_undef1(<4 x i32> %X) nounwind {
; CHECK-SSE2-LABEL: test_srem_even_undef1:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE2-NEXT:    movdqa %xmm0, %xmm2
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm3
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,3,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; CHECK-SSE2-NEXT:    pxor %xmm3, %xmm3
; CHECK-SSE2-NEXT:    pxor %xmm4, %xmm4
; CHECK-SSE2-NEXT:    pcmpgtd %xmm0, %xmm4
; CHECK-SSE2-NEXT:    pand %xmm1, %xmm4
; CHECK-SSE2-NEXT:    psubd %xmm4, %xmm2
; CHECK-SSE2-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE2-NEXT:    psrld $31, %xmm1
; CHECK-SSE2-NEXT:    psrad $5, %xmm2
; CHECK-SSE2-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [100,100,100,100]
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm2[1,1,3,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; CHECK-SSE2-NEXT:    pmuludq %xmm1, %xmm4
; CHECK-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm4[0,2,2,3]
; CHECK-SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-SSE2-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE2-NEXT:    pcmpeqd %xmm3, %xmm0
; CHECK-SSE2-NEXT:    psrld $31, %xmm0
; CHECK-SSE2-NEXT:    retq
;
; CHECK-SSE41-LABEL: test_srem_even_undef1:
; CHECK-SSE41:       # %bb.0:
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-SSE41-NEXT:    pmuldq %xmm2, %xmm1
; CHECK-SSE41-NEXT:    pmuldq %xmm0, %xmm2
; CHECK-SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-SSE41-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-SSE41-NEXT:    movdqa %xmm2, %xmm1
; CHECK-SSE41-NEXT:    psrld $31, %xmm1
; CHECK-SSE41-NEXT:    psrad $5, %xmm2
; CHECK-SSE41-NEXT:    paddd %xmm1, %xmm2
; CHECK-SSE41-NEXT:    pmulld {{.*}}(%rip), %xmm2
; CHECK-SSE41-NEXT:    psubd %xmm2, %xmm0
; CHECK-SSE41-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE41-NEXT:    psrld $31, %xmm0
; CHECK-SSE41-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_srem_even_undef1:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX1-NEXT:    vpsrad $5, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_srem_even_undef1:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX2-NEXT:    vpsrad $5, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [100,100,100,100]
; CHECK-AVX2-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_srem_even_undef1:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [1374389535,1374389535,1374389535,1374389535]
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmuldq %xmm2, %xmm0, %xmm2
; CHECK-AVX512VL-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm1, %xmm2
; CHECK-AVX512VL-NEXT:    vpsrad $5, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpmulld {{.*}}(%rip){1to4}, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 100, i32 100, i32 100, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 undef, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;
; Negative tests
;------------------------------------------------------------------------------;

; We can lower remainder of division by powers of two much better elsewhere.
define <4 x i32> @test_srem_pow2(<4 x i32> %X) nounwind {
; CHECK-SSE-LABEL: test_srem_pow2:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    movdqa %xmm0, %xmm1
; CHECK-SSE-NEXT:    psrad $31, %xmm1
; CHECK-SSE-NEXT:    psrld $28, %xmm1
; CHECK-SSE-NEXT:    paddd %xmm0, %xmm1
; CHECK-SSE-NEXT:    pand {{.*}}(%rip), %xmm1
; CHECK-SSE-NEXT:    psubd %xmm1, %xmm0
; CHECK-SSE-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; CHECK-SSE-NEXT:    psrld $31, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_srem_pow2:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpsrad $31, %xmm0, %xmm1
; CHECK-AVX1-NEXT:    vpsrld $28, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; CHECK-AVX1-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_srem_pow2:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vpsrad $31, %xmm0, %xmm1
; CHECK-AVX2-NEXT:    vpsrld $28, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; CHECK-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [4294967280,4294967280,4294967280,4294967280]
; CHECK-AVX2-NEXT:    vpand %xmm2, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX2-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_srem_pow2:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vpsrad $31, %xmm0, %xmm1
; CHECK-AVX512VL-NEXT:    vpsrld $28, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; CHECK-AVX512VL-NEXT:    vpandd {{.*}}(%rip){1to4}, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512VL-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    vpsrld $31, %xmm0, %xmm0
; CHECK-AVX512VL-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 16, i32 16, i32 16, i32 16>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; We could lower remainder of division by all-ones much better elsewhere.
define <4 x i32> @test_srem_allones(<4 x i32> %X) nounwind {
; CHECK-SSE-LABEL: test_srem_allones:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    movaps {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_srem_allones:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vmovaps {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_srem_allones:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vbroadcastss {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_srem_allones:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vbroadcastss {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX512VL-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; If all divisors are ones, this is constant-folded.
define <4 x i32> @test_srem_one_eq(<4 x i32> %X) nounwind {
; CHECK-SSE-LABEL: test_srem_one_eq:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    movaps {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: test_srem_one_eq:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vmovaps {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX2-LABEL: test_srem_one_eq:
; CHECK-AVX2:       # %bb.0:
; CHECK-AVX2-NEXT:    vbroadcastss {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX2-NEXT:    retq
;
; CHECK-AVX512VL-LABEL: test_srem_one_eq:
; CHECK-AVX512VL:       # %bb.0:
; CHECK-AVX512VL-NEXT:    vbroadcastss {{.*#+}} xmm0 = [1,1,1,1]
; CHECK-AVX512VL-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 1, i32 1, i32 1, i32 1>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
define <4 x i32> @test_srem_one_ne(<4 x i32> %X) nounwind {
; CHECK-SSE-LABEL: test_srem_one_ne:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    xorps %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test_srem_one_ne:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
  %srem = srem <4 x i32> %X, <i32 1, i32 1, i32 1, i32 1>
  %cmp = icmp ne <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
