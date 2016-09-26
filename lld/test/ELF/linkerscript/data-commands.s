# REQUIRES: x86,mips
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t.o
# RUN: echo "SECTIONS                \
# RUN:  {                            \
# RUN:    .foo : {                   \
# RUN:      *(.foo.1)                \
# RUN:      BYTE(0x11)               \
# RUN:      *(.foo.2)                \
# RUN:      SHORT(0x1122)            \
# RUN:      *(.foo.3)                \
# RUN:      LONG(0x11223344)         \
# RUN:      *(.foo.4)                \
# RUN:      QUAD(0x1122334455667788) \
# RUN:    }                          \
# RUN:  }" > %t.script
# RUN: ld.lld -o %t --script %t.script %t.o
# RUN: llvm-objdump -s %t | FileCheck %s

# CHECK:      Contents of section .foo:
# CHECK-NEXT:   ff11ff22 11ff4433 2211ff88 77665544
# CHECK-NEXT:   332211

# RUN: llvm-mc -filetype=obj -triple=mips64-unknown-linux %s -o %tmips64be
# RUN: ld.lld --script %t.script %tmips64be -o %t2
# RUN: llvm-objdump -s %t2 | FileCheck %s --check-prefix=BE
# BE:      Contents of section .foo:
# BE-NEXT:   ff11ff11 22ff1122 3344ff11 22334455
# BE-NEXT:   667788

.section .foo.1, "a"
 .byte 0xFF

.section .foo.2, "a"
 .byte 0xFF

.section .foo.3, "a"
 .byte 0xFF

.section .foo.4, "a"
 .byte 0xFF
