; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s

define i128 @sub128(i128 %a, i128 %b) nounwind {
; CHECK-LABEL: sub128:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq %rdx, %rdi
; CHECK-NEXT:    sbbq %rcx, %rsi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    retq
entry:
  %0 = sub i128 %a, %b
  ret i128 %0
}

define i256 @sub256(i256 %a, i256 %b) nounwind {
; CHECK-LABEL: sub256:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq %r9, %rsi
; CHECK-NEXT:    sbbq {{[0-9]+}}(%rsp), %rdx
; CHECK-NEXT:    sbbq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    sbbq {{[0-9]+}}(%rsp), %r8
; CHECK-NEXT:    movq %rdx, 8(%rdi)
; CHECK-NEXT:    movq %rsi, (%rdi)
; CHECK-NEXT:    movq %rcx, 16(%rdi)
; CHECK-NEXT:    movq %r8, 24(%rdi)
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
entry:
  %0 = sub i256 %a, %b
  ret i256 %0
}

%S = type { [4 x i64] }

define %S @negate(%S* nocapture readonly %this) {
; CHECK-LABEL: negate:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq (%rsi), %rax
; CHECK-NEXT:    movq 8(%rsi), %rcx
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    addq $1, %rax
; CHECK-NEXT:    notq %rcx
; CHECK-NEXT:    adcq $0, %rcx
; CHECK-NEXT:    movq 16(%rsi), %rdx
; CHECK-NEXT:    notq %rdx
; CHECK-NEXT:    adcq $0, %rdx
; CHECK-NEXT:    movq 24(%rsi), %rsi
; CHECK-NEXT:    notq %rsi
; CHECK-NEXT:    adcq $0, %rsi
; CHECK-NEXT:    movq %rax, (%rdi)
; CHECK-NEXT:    movq %rcx, 8(%rdi)
; CHECK-NEXT:    movq %rdx, 16(%rdi)
; CHECK-NEXT:    movq %rsi, 24(%rdi)
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
entry:
  %0 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 0
  %1 = load i64, i64* %0, align 8
  %2 = xor i64 %1, -1
  %3 = zext i64 %2 to i128
  %4 = add nuw nsw i128 %3, 1
  %5 = trunc i128 %4 to i64
  %6 = lshr i128 %4, 64
  %7 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 1
  %8 = load i64, i64* %7, align 8
  %9 = xor i64 %8, -1
  %10 = zext i64 %9 to i128
  %11 = add nuw nsw i128 %6, %10
  %12 = trunc i128 %11 to i64
  %13 = lshr i128 %11, 64
  %14 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 2
  %15 = load i64, i64* %14, align 8
  %16 = xor i64 %15, -1
  %17 = zext i64 %16 to i128
  %18 = add nuw nsw i128 %13, %17
  %19 = lshr i128 %18, 64
  %20 = trunc i128 %18 to i64
  %21 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 3
  %22 = load i64, i64* %21, align 8
  %23 = xor i64 %22, -1
  %24 = zext i64 %23 to i128
  %25 = add nuw nsw i128 %19, %24
  %26 = trunc i128 %25 to i64
  %27 = insertvalue [4 x i64] undef, i64 %5, 0
  %28 = insertvalue [4 x i64] %27, i64 %12, 1
  %29 = insertvalue [4 x i64] %28, i64 %20, 2
  %30 = insertvalue [4 x i64] %29, i64 %26, 3
  %31 = insertvalue %S undef, [4 x i64] %30, 0
  ret %S %31
}

define %S @sub(%S* nocapture readonly %this, %S %arg.b) local_unnamed_addr {
; CHECK-LABEL: sub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    notq %rdx
; CHECK-NEXT:    xorl %r10d, %r10d
; CHECK-NEXT:    addq (%rsi), %rdx
; CHECK-NEXT:    setb %r10b
; CHECK-NEXT:    addq $1, %rdx
; CHECK-NEXT:    adcq 8(%rsi), %r10
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %r11d
; CHECK-NEXT:    notq %rcx
; CHECK-NEXT:    addq %r10, %rcx
; CHECK-NEXT:    adcq 16(%rsi), %r11
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    notq %r8
; CHECK-NEXT:    addq %r11, %r8
; CHECK-NEXT:    adcq 24(%rsi), %rax
; CHECK-NEXT:    notq %r9
; CHECK-NEXT:    addq %rax, %r9
; CHECK-NEXT:    movq %rdx, (%rdi)
; CHECK-NEXT:    movq %rcx, 8(%rdi)
; CHECK-NEXT:    movq %r8, 16(%rdi)
; CHECK-NEXT:    movq %r9, 24(%rdi)
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
entry:
  %0 = extractvalue %S %arg.b, 0
  %.elt6 = extractvalue [4 x i64] %0, 1
  %.elt8 = extractvalue [4 x i64] %0, 2
  %.elt10 = extractvalue [4 x i64] %0, 3
  %.elt = extractvalue [4 x i64] %0, 0
  %1 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 0
  %2 = load i64, i64* %1, align 8
  %3 = zext i64 %2 to i128
  %4 = add nuw nsw i128 %3, 1
  %5 = xor i64 %.elt, -1
  %6 = zext i64 %5 to i128
  %7 = add nuw nsw i128 %4, %6
  %8 = trunc i128 %7 to i64
  %9 = lshr i128 %7, 64
  %10 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 1
  %11 = load i64, i64* %10, align 8
  %12 = zext i64 %11 to i128
  %13 = add nuw nsw i128 %9, %12
  %14 = xor i64 %.elt6, -1
  %15 = zext i64 %14 to i128
  %16 = add nuw nsw i128 %13, %15
  %17 = trunc i128 %16 to i64
  %18 = lshr i128 %16, 64
  %19 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 2
  %20 = load i64, i64* %19, align 8
  %21 = zext i64 %20 to i128
  %22 = add nuw nsw i128 %18, %21
  %23 = xor i64 %.elt8, -1
  %24 = zext i64 %23 to i128
  %25 = add nuw nsw i128 %22, %24
  %26 = lshr i128 %25, 64
  %27 = trunc i128 %25 to i64
  %28 = getelementptr inbounds %S, %S* %this, i64 0, i32 0, i64 3
  %29 = load i64, i64* %28, align 8
  %30 = zext i64 %29 to i128
  %31 = add nuw nsw i128 %26, %30
  %32 = xor i64 %.elt10, -1
  %33 = zext i64 %32 to i128
  %34 = add nuw nsw i128 %31, %33
  %35 = trunc i128 %34 to i64
  %36 = insertvalue [4 x i64] undef, i64 %8, 0
  %37 = insertvalue [4 x i64] %36, i64 %17, 1
  %38 = insertvalue [4 x i64] %37, i64 %27, 2
  %39 = insertvalue [4 x i64] %38, i64 %35, 3
  %40 = insertvalue %S undef, [4 x i64] %39, 0
  ret %S %40
}
