.data
.text
main:
    addi $t0, $0, 50 # y cord
    sll $t0, $t0, 8
    addi $a0, $t0, 50 # x cord
    addi $a1, $0, 25 # width
    addi $a2, $0, 10 # height
    addi $a3, $0, 255 # color blue
    addi $v0, $0, 17
    syscall
loop:
    addi $v0, $0, 18
    syscall
    bne $v0, $0, draw2
    addi $t1, $t1, 1
    j loop
draw2:
    addi $t0, $0, 50 # y cord
    sll $t0, $t0, 8
    addi $a0, $t0, 150 # x cord
    addi $a1, $0, 15 # width
    addi $a2, $0, 40 # height
    addi $t0, $0, 255 # color red
    sll $a3, $t0, 16
    addi $v0, $0, 17
    syscall
loop2:
    addi $v0, $0, 18
    syscall
    bne $v0, $0, draw2
    addi $t1, $t1, 1
    j end
end:
    addi $v0, $0, 10
    syscall