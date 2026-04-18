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
    beq x0,x0,insert_end
insert_left:
    ld t1,8(s0)
    mv a0,t1
    mv a1,s1
    call insert
    sd a0,8(s0)
    mv a0,s0
    beq x0,x0,insert_end
create:
    mv a0,s1
    call make_node
insert_end:
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
    beq s0,x0,get_not_found
    lw t0,0(s0)
    beq s1,t0,get_found
    blt s1,t0,get_search_left
    ld t1,16(s0)
    mv a0,t1
    mv a1,s1
    call get
    beq x0,x0,get_end
get_not_found:
    mv a0,x0
    beq x0,x0,get_end
get_search_left:
    ld t1,8(s0)
    mv a0,t1
    mv a1,s1
    call get
    beq x0,x0,get_end
get_found:
    mv a0,s0
get_end:
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
    beq s0,x0,atmost_not_found
    lw t0,0(s0)           # t0 = root->val
    blt s1,t0,atmost_go_left      # val < root->val → go left
    # root->val <= val: candidate found, try right for closer value
    ld a0,16(s0)        
    mv a1,s1             
    call getAtMost
    bge a0,x0,atmost_end          # right returned valid value, use it
atmost_use_current:
    lw a0,0(s0)           # right had nothing better, return root->val
    beq x0,x0,atmost_end
atmost_go_left:
    ld a0,8(s0)           
    mv a1,s1             
    call getAtMost
    beq x0,x0,atmost_end
atmost_not_found:
    addi a0,x0,-1         # return -1
atmost_end:
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret
