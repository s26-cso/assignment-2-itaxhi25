.data
arr:     .space 800
fmt_in:  .asciz "%lld"
fmt_out: .asciz "%lld"

.text
.globl main

main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s1, 48(sp)
    sd s2, 40(sp)
    sd s3, 32(sp)
    sd s4, 24(sp)
    la a0, fmt_in
    addi a1, sp, 0
    call scanf            # ✅ scanf first
    ld s1, 0(sp)          # ✅ THEN load s1 (the fix)
    la s3, arr
    li s2, 0

input_loop:
    bge s2, s1, initialize
    la a0, fmt_in
    mv a1, s3
    call scanf
    addi s3, s3, 8
    addi s2, s2, 1
    beq x0, x0, input_loop

initialize:
    la s3, arr
    li s2, 0
    li s4, 0
    li t0, 3

fun:
    bge s2, s1, end
    ld t3, 0(s3)
    rem t1, t3, t0
    bne t1, zero, next
    add s4, s4, t3

next:
    addi s2, s2, 1
    addi s3, s3, 8
    beq x0, x0, fun

end:
    la a0, fmt_out
    mv a1, s4
    call printf
    ld ra, 56(sp)
    ld s1, 48(sp)
    ld s2, 40(sp)
    ld s3, 32(sp)
    ld s4, 24(sp)
    addi sp, sp, 64
    ret
