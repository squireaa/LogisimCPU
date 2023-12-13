.data
.text
main:
    addi $v0, $0, 15
    syscall
    addi $a0, $v0, 0
    addi $v0, $0, 16
    syscall
    j main
