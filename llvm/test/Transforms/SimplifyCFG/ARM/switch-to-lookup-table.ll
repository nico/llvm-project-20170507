; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=static    < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=pic       < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=ropi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=rwpi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=ropi-rwpi < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE

; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=static    < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=pic       < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=ropi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=rwpi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=ropi-rwpi < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE

; CHECK:       @{{.*}} = private unnamed_addr constant [3 x i32] [i32 1234, i32 5678, i32 15532]
; ENABLE:      @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @c1, i32* @c2, i32* @c3]
; DISABLE-NOT: @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @c1, i32* @c2, i32* @c3]
; ENABLE:      @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @g1, i32* @g2, i32* @g3]
; DISABLE-NOT: @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @g1, i32* @g2, i32* @g3]
; ENABLE:      @{{.*}} = private unnamed_addr constant [3 x i32 (i32, i32)*] [i32 (i32, i32)* @f1, i32 (i32, i32)* @f2, i32 (i32, i32)* @f3]
; DISABLE-NOT: @{{.*}} = private unnamed_addr constant [3 x i32 (i32, i32)*] [i32 (i32, i32)* @f1, i32 (i32, i32)* @f2, i32 (i32, i32)* @f3]

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7a--none-eabi"

define i32 @test1(i32 %n) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[N:%.*]], 3
; CHECK-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[RETURN:%.*]]
; CHECK:       switch.lookup:
; CHECK-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [3 x i32], [3 x i32]* @switch.table.test1, i32 0, i32 [[N]]
; CHECK-NEXT:    [[SWITCH_LOAD:%.*]] = load i32, i32* [[SWITCH_GEP]]
; CHECK-NEXT:    ret i32 [[SWITCH_LOAD]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 15498
;
entry:
  switch i32 %n, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb1
  i32 2, label %sw.bb2
  ]

sw.bb:
  br label %return

sw.bb1:
  br label %return

sw.bb2:
  br label %return

sw.default:
  br label %return

return:
  %retval.0 = phi i32 [ 15498, %sw.default ], [ 15532, %sw.bb2 ], [ 5678, %sw.bb1 ], [ 1234, %sw.bb ]
  ret i32 %retval.0
}

@c1 = external constant i32, align 4
@c2 = external constant i32, align 4
@c3 = external constant i32, align 4
@c4 = external constant i32, align 4


define i32* @test2(i32 %n) {
; ENABLE-LABEL: @test2(
; ENABLE-NEXT:  entry:
; ENABLE-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[N:%.*]], 3
; ENABLE-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[RETURN:%.*]]
; ENABLE:       switch.lookup:
; ENABLE-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [3 x i32*], [3 x i32*]* @switch.table.test2, i32 0, i32 [[N]]
; ENABLE-NEXT:    [[SWITCH_LOAD:%.*]] = load i32*, i32** [[SWITCH_GEP]]
; ENABLE-NEXT:    ret i32* [[SWITCH_LOAD]]
; ENABLE:       return:
; ENABLE-NEXT:    ret i32* @c4
;
; DISABLE-LABEL: @test2(
; DISABLE-NEXT:  entry:
; DISABLE-NEXT:    switch i32 [[N:%.*]], label [[SW_DEFAULT:%.*]] [
; DISABLE-NEXT:    i32 0, label [[RETURN:%.*]]
; DISABLE-NEXT:    i32 1, label [[SW_BB1:%.*]]
; DISABLE-NEXT:    i32 2, label [[SW_BB2:%.*]]
; DISABLE-NEXT:    ]
; DISABLE:       sw.bb1:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.bb2:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.default:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       return:
; DISABLE-NEXT:    [[RETVAL_0:%.*]] = phi i32* [ @c4, [[SW_DEFAULT]] ], [ @c3, [[SW_BB2]] ], [ @c2, [[SW_BB1]] ], [ @c1, [[ENTRY:%.*]] ]
; DISABLE-NEXT:    ret i32* [[RETVAL_0]]
;
entry:
  switch i32 %n, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb1
  i32 2, label %sw.bb2
  ]

sw.bb:
  br label %return

sw.bb1:
  br label %return

sw.bb2:
  br label %return

sw.default:
  br label %return

return:
  %retval.0 = phi i32* [ @c4, %sw.default ], [ @c3, %sw.bb2 ], [ @c2, %sw.bb1 ], [ @c1, %sw.bb ]
  ret i32* %retval.0
}

@g1 = external global i32, align 4
@g2 = external global i32, align 4
@g3 = external global i32, align 4
@g4 = external global i32, align 4

define i32* @test3(i32 %n) {
; ENABLE-LABEL: @test3(
; ENABLE-NEXT:  entry:
; ENABLE-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[N:%.*]], 3
; ENABLE-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[RETURN:%.*]]
; ENABLE:       switch.lookup:
; ENABLE-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [3 x i32*], [3 x i32*]* @switch.table.test3, i32 0, i32 [[N]]
; ENABLE-NEXT:    [[SWITCH_LOAD:%.*]] = load i32*, i32** [[SWITCH_GEP]]
; ENABLE-NEXT:    ret i32* [[SWITCH_LOAD]]
; ENABLE:       return:
; ENABLE-NEXT:    ret i32* @g4
;
; DISABLE-LABEL: @test3(
; DISABLE-NEXT:  entry:
; DISABLE-NEXT:    switch i32 [[N:%.*]], label [[SW_DEFAULT:%.*]] [
; DISABLE-NEXT:    i32 0, label [[RETURN:%.*]]
; DISABLE-NEXT:    i32 1, label [[SW_BB1:%.*]]
; DISABLE-NEXT:    i32 2, label [[SW_BB2:%.*]]
; DISABLE-NEXT:    ]
; DISABLE:       sw.bb1:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.bb2:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.default:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       return:
; DISABLE-NEXT:    [[RETVAL_0:%.*]] = phi i32* [ @g4, [[SW_DEFAULT]] ], [ @g3, [[SW_BB2]] ], [ @g2, [[SW_BB1]] ], [ @g1, [[ENTRY:%.*]] ]
; DISABLE-NEXT:    ret i32* [[RETVAL_0]]
;
entry:
  switch i32 %n, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb1
  i32 2, label %sw.bb2
  ]

sw.bb:
  br label %return

sw.bb1:
  br label %return

sw.bb2:
  br label %return

sw.default:
  br label %return

return:
  %retval.0 = phi i32* [ @g4, %sw.default ], [ @g3, %sw.bb2 ], [ @g2, %sw.bb1 ], [ @g1, %sw.bb ]
  ret i32* %retval.0
}

declare i32 @f1(i32, i32)
declare i32 @f2(i32, i32)
declare i32 @f3(i32, i32)
declare i32 @f4(i32, i32)
declare i32 @f5(i32, i32)

define i32 @test4(i32 %a, i32 %b, i32 %c) {
; ENABLE-LABEL: @test4(
; ENABLE-NEXT:  entry:
; ENABLE-NEXT:    [[SWITCH_TABLEIDX:%.*]] = sub i32 [[A:%.*]], 1
; ENABLE-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[SWITCH_TABLEIDX]], 3
; ENABLE-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[COND_FALSE6:%.*]]
; ENABLE:       cond.false6:
; ENABLE-NEXT:    [[CMP7:%.*]] = icmp eq i32 [[A]], 4
; ENABLE-NEXT:    [[COND:%.*]] = select i1 [[CMP7]], i32 (i32, i32)* @f4, i32 (i32, i32)* @f5
; ENABLE-NEXT:    br label [[COND_END11:%.*]]
; ENABLE:       switch.lookup:
; ENABLE-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [3 x i32 (i32, i32)*], [3 x i32 (i32, i32)*]* @switch.table.test4, i32 0, i32 [[SWITCH_TABLEIDX]]
; ENABLE-NEXT:    [[SWITCH_LOAD:%.*]] = load i32 (i32, i32)*, i32 (i32, i32)** [[SWITCH_GEP]]
; ENABLE-NEXT:    br label [[COND_END11]]
; ENABLE:       cond.end11:
; ENABLE-NEXT:    [[COND12:%.*]] = phi i32 (i32, i32)* [ [[COND]], [[COND_FALSE6]] ], [ [[SWITCH_LOAD]], [[SWITCH_LOOKUP]] ]
; ENABLE-NEXT:    [[CALL:%.*]] = call i32 [[COND12]](i32 [[B:%.*]], i32 [[C:%.*]])
; ENABLE-NEXT:    ret i32 [[CALL]]
;
; DISABLE-LABEL: @test4(
; DISABLE-NEXT:  entry:
; DISABLE-NEXT:    switch i32 [[A:%.*]], label [[COND_FALSE6:%.*]] [
; DISABLE-NEXT:    i32 1, label [[COND_END11:%.*]]
; DISABLE-NEXT:    i32 2, label [[COND_END11_FOLD_SPLIT:%.*]]
; DISABLE-NEXT:    i32 3, label [[COND_END11_FOLD_SPLIT1:%.*]]
; DISABLE-NEXT:    ]
; DISABLE:       cond.false6:
; DISABLE-NEXT:    [[CMP7:%.*]] = icmp eq i32 [[A]], 4
; DISABLE-NEXT:    [[COND:%.*]] = select i1 [[CMP7]], i32 (i32, i32)* @f4, i32 (i32, i32)* @f5
; DISABLE-NEXT:    br label [[COND_END11]]
; DISABLE:       cond.end11.fold.split:
; DISABLE-NEXT:    br label [[COND_END11]]
; DISABLE:       cond.end11.fold.split1:
; DISABLE-NEXT:    br label [[COND_END11]]
; DISABLE:       cond.end11:
; DISABLE-NEXT:    [[COND12:%.*]] = phi i32 (i32, i32)* [ @f1, [[ENTRY:%.*]] ], [ [[COND]], [[COND_FALSE6]] ], [ @f2, [[COND_END11_FOLD_SPLIT]] ], [ @f3, [[COND_END11_FOLD_SPLIT1]] ]
; DISABLE-NEXT:    [[CALL:%.*]] = call i32 [[COND12]](i32 [[B:%.*]], i32 [[C:%.*]])
; DISABLE-NEXT:    ret i32 [[CALL]]
;
entry:
  %cmp = icmp eq i32 %a, 1
  br i1 %cmp, label %cond.end11, label %cond.false

cond.false:
  %cmp1 = icmp eq i32 %a, 2
  br i1 %cmp1, label %cond.end11, label %cond.false3

cond.false3:
  %cmp4 = icmp eq i32 %a, 3
  br i1 %cmp4, label %cond.end11, label %cond.false6

cond.false6:
  %cmp7 = icmp eq i32 %a, 4
  %cond = select i1 %cmp7, i32 (i32, i32)* @f4, i32 (i32, i32)* @f5
  br label %cond.end11

cond.end11:
  %cond12 = phi i32 (i32, i32)* [ @f1, %entry ], [ @f2, %cond.false ], [ %cond, %cond.false6 ], [ @f3, %cond.false3 ]
  %call = call i32 %cond12(i32 %b, i32 %c) #2
  ret i32 %call
}
