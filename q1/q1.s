.text
.globl  make_node
.globl  insert
.globl  get
.globl  getAtMost
make_node:
    addi sp,sp,-16
    sd ra,8(sp) # storing return address
    sd s0,0(sp) 
    mv s0,a0    # saving value in s0
    addi a0,x0,24 # tells malloc how many bytes to allocate
    call malloc
    sd s0,0(a0)     # node->data = saved value
    sd x0,8(a0)     # node->left = NULL
    sd x0,16(a0)    # node->right = NULL
    ld ra,8(sp) # restoring return address
    ld s0,0(sp)
    addi sp,sp,16
    ret
insert:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    mv s0,a0 # saving location of node in s0
    mv s1,a1 # value to be inserted 
    beq s0,x0,create # if node is null, just simply insert value
    ld t0,0(s0) # loading values of current node    
    blt s1,t0,insert_left # if val < root->data, insert in left subtree  
    ld t1,16(s0)    # load right child
    mv a0,t1
    mv a1,s1
    call insert
    sd a0,16(s0)    # store back into right
    mv a0,s0
    beq x0,x0,end
insert_left:
    ld t1,8(s0) # loading left child of current node
    mv a0,t1
    mv a1,s1
    call insert
    sd a0,8(s0) # store back into left
    mv a0,s0
    beq x0,x0,end
create:
    mv a0,s1 # value to be inserted
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
    mv s0,a0 # saving node address in s0
    mv s1,a1 # saving search value in s1
    beq s0,x0,not_found # if node is null
    ld t0,0(s0)
    beq s1,t0,found # if search value == node->data
    blt s1,t0,search_left # if search value < node->data, search left subtree
    ld t1,16(s0)    # load right child
    mv a0,t1
    mv a1,s1
    call get
    beq x0,x0,end_get
not_found:
    addi a0,x0,-1 # return -1 if not found
    beq x0,x0,end_get
search_left:
    ld t1,8(s0) # load left child
    mv a0,t1
    mv a1,s1
    call get
    beq x0,x0,end_get
found:
    addi a0,x0,1 # return 1 if found
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
    mv s0,a0        # saving node address in s0
    mv s1,a1        # saving search value in s1
    beq s0,x0,not_found_atmost  # if node is null
    ld t0,0(s0)     # load node->data
    blt s1,t0,go_left   # if value < node->data, go left only
    ld t1,16(s0)    # load right child
    mv a0,t1
    mv a1,s1
    call getAtMost
    blt a0,x0,use_current   # if right returned -1, use current node's data
    beq x0,x0,end_atmost
use_current:
    mv a0,t0        # return node->data as best candidate
    beq x0,x0,end_atmost
go_left:
    ld t1,8(s0)     # load left child
    mv a0,t1
    mv a1,s1
    call getAtMost
    beq x0,x0,end_atmost
not_found_atmost:
    addi a0,x0,-1   # return -1 if not found
end_atmost:
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret
