.text
.globl  make_node
.globl  insert
.globl  get
.globl  getAtMost
make_node:
    addi sp,sp,-16
    sd ra,8(sp)
    sd s0,0(sp) 
    mv s0,a0
    addi a0,x0,24
    call malloc
    sw s0,0(a0)
    sd x0,8(a0)
    sd x0,16(a0)
    ld ra,8(sp)
    ld s0,0(sp)
    addi sp,sp,16
    ret

insert:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    mv s0,a0
    mv s1,a1
    beq s0,x0,create
    lw t0,0(s0)
    blt s1,t0,insert_left
    ld t1,16(s0)
    mv a0,t1
    mv a1,s1
    call insert
    sd a0,16(s0)
    mv a0,s0
    beq x0,x0,end

insert_left:
    ld t1,8(s0)
    mv a0,t1
    mv a1,s1
    call insert
    sd a0,8(s0)
    mv a0,s0
    beq x0,x0,end

create:
    mv a0,s1
    call make_node
    beq x0,x0,end

end:
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

get:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    mv s0,a0
    mv s1,a1
    beq s0,x0,not_found
    lw t0,0(s0)
    beq s1,t0,found
    blt s1,t0,search_left
    ld t1,16(s0)
    mv a0,t1
    mv a1,s1
    call get
    beq x0,x0,end_get

not_found:
    addi a0,x0,-1
    beq x0,x0,end_get

search_left:
    ld t1,8(s0)
    mv a0,t1
    mv a1,s1
    call get
    beq x0,x0,end_get

found:
    addi a0,x0,1
    beq x0,x0,end_get

end_get:
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

getAtMost:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    mv s0,a0
    mv s1,a1
    beq s0,x0,not_found_atmost
    lw t0,0(s0)
    blt s1,t0,go_left
    ld t1,16(s0)
    mv a0,t1
    mv a1,s1
    call getAtMost
    blt a0,x0,use_current
    beq x0,x0,end_atmost

use_current:
    lw a0,0(s0)
    beq x0,x0,end_atmost

go_left:
    ld t1,8(s0)
    mv a0,t1
    mv a1,s1
    call getAtMost
    beq x0,x0,end_atmost

not_found_atmost:
    addi a0,x0,-1

end_atmost:
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret
