.data
.text
main:
    addi $a0, $0, 147
    addi $v0, $0, 13
    syscall
    addi $v0, $0, 14
    syscall
    addi $a0, $0, 43
    addi $v0, $0, 13
    syscall
    addi $v0, $0, 10
    syscall