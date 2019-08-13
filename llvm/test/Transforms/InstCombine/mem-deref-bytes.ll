; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine  -S < %s | FileCheck %s

declare i32 @memcmp(i8* nocapture, i8* nocapture, i64)
declare i8* @memcpy(i8* nocapture, i8* nocapture, i64)
declare i8* @memmove(i8* nocapture, i8* nocapture, i64)
declare i8* @memset(i8* nocapture, i8, i64)
declare i8* @memchr(i8* nocapture, i32, i64)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1)
declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1)
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1)

define i32 @memcmp_const_size_set_deref(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcmp_const_size_set_deref(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* dereferenceable(16) [[D:%.*]], i8* dereferenceable(16) [[S:%.*]], i64 16)
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %d, i8* %s, i64 16)
  ret i32 %call
}

define i32 @memcmp_const_size_update_deref(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcmp_const_size_update_deref(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* dereferenceable(16) [[D:%.*]], i8* dereferenceable(16) [[S:%.*]], i64 16)
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* dereferenceable(4) %d, i8* dereferenceable(8) %s, i64 16)
  ret i32 %call
}

define i32 @memcmp_const_size_update_deref2(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcmp_const_size_update_deref2(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* dereferenceable(16) [[D:%.*]], i8* dereferenceable(16) [[S:%.*]], i64 16)
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %d, i8* dereferenceable_or_null(8) %s, i64 16)
  ret i32 %call
}

define i32 @memcmp_const_size_update_deref3(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcmp_const_size_update_deref3(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* dereferenceable(40) [[D:%.*]], i8* dereferenceable(16) [[S:%.*]], i64 16)
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* dereferenceable(40) %d, i8* %s, i64 16)
  ret i32 %call
}

define i32 @memcmp_const_size_update_deref4(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcmp_const_size_update_deref4(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* dereferenceable(16) [[D:%.*]], i8* dereferenceable(16) [[S:%.*]], i64 16)
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* dereferenceable_or_null(16) %d, i8* %s, i64 16)
  ret i32 %call
}

define i32 @memcmp_const_size_update_deref5(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcmp_const_size_update_deref5(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* dereferenceable(40) [[D:%.*]], i8* dereferenceable(16) [[S:%.*]], i64 16)
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* dereferenceable_or_null(40) %d, i8* %s, i64 16)
  ret i32 %call
}

define i32 @memcmp_const_size_no_update_deref(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcmp_const_size_no_update_deref(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* dereferenceable(40) [[D:%.*]], i8* dereferenceable(20) [[S:%.*]], i64 16)
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* dereferenceable(40) %d, i8* dereferenceable(20) %s, i64 16)
  ret i32 %call
}

define i32 @memcmp_nonconst_size(i8* nocapture readonly %d, i8* nocapture readonly %s, i64 %n) {
; CHECK-LABEL: @memcmp_nonconst_size(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[D:%.*]], i8* [[S:%.*]], i64 [[N:%.*]])
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %d, i8* %s, i64 %n)
  ret i32 %call
}

define i8* @memcpy_const_size_set_deref(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memcpy_const_size_set_deref(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 dereferenceable(64) [[D:%.*]], i8* align 1 dereferenceable(64) [[S:%.*]], i64 64, i1 false)
; CHECK-NEXT:    ret i8* [[D]]
;
  %call = tail call i8* @memcpy(i8* %d, i8* %s, i64 64)
  ret i8* %call
}

define i8* @memmove_const_size_set_deref(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @memmove_const_size_set_deref(
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 dereferenceable(64) [[D:%.*]], i8* align 1 dereferenceable(64) [[S:%.*]], i64 64, i1 false)
; CHECK-NEXT:    ret i8* [[D]]
;
  %call = tail call i8* @memmove(i8* %d, i8* %s, i64 64)
  ret i8* %call
}

define i8* @memset_const_size_set_deref(i8* nocapture readonly %s, i8 %c) {
; CHECK-LABEL: @memset_const_size_set_deref(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 dereferenceable(64) [[S:%.*]], i8 [[C:%.*]], i64 64, i1 false)
; CHECK-NEXT:    ret i8* [[S]]
;
  %call = tail call i8* @memset(i8* %s, i8 %c, i64 64)
  ret i8* %call
}

define i8* @memchr_const_size_set_deref(i8* nocapture readonly %s, i32 %c) {
; CHECK-LABEL: @memchr_const_size_set_deref(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @memchr(i8* dereferenceable(64) [[S:%.*]], i32 [[C:%.*]], i64 64)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = tail call i8* @memchr(i8* %s, i32 %c, i64 64)
  ret i8* %call
}

define i8* @llvm_memcpy_const_size_set_deref(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @llvm_memcpy_const_size_set_deref(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 dereferenceable(16) [[D:%.*]], i8* align 1 dereferenceable(16) [[S:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret i8* [[D]]
;
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %d, i8* align 1 %s, i64 16, i1 false)
  ret i8* %d
}

define i8* @llvm_memmove_const_size_set_deref(i8* nocapture readonly %d, i8* nocapture readonly %s) {
; CHECK-LABEL: @llvm_memmove_const_size_set_deref(
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 dereferenceable(16) [[D:%.*]], i8* align 1 dereferenceable(16) [[S:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret i8* [[D]]
;
  call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 %d, i8* align 1 %s, i64 16, i1 false)
  ret i8* %d
}
define i8* @llvm_memset_const_size_set_deref(i8* nocapture readonly %s, i8 %c) {
; CHECK-LABEL: @llvm_memset_const_size_set_deref(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 dereferenceable(16) [[S:%.*]], i8 [[C:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret i8* [[S]]
;
  call void @llvm.memset.p0i8.i64(i8* align 1 %s, i8 %c, i64 16, i1 false)
  ret i8* %s
}
