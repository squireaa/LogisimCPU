.data
    barray: .word 4 f
    string: .asciiz "Hello, world."
    array: .word 3 4 5 #This comment must be ignored
    string2: .asciiz "Almost finished."
.text
main:
    la $a0, string
    addi $v0, $0, 4 # print a string
    syscall

    addi $a0, $0, 10
    addi $v0, $0, 11
    syscall

    la $a0, string2
    addi $v0, $0, 4 # print a string
    syscall

    addi $a0, $0, 10
    addi $v0, $0, 11
    syscall

    addi $v0, $0, 8 # read a string 
    syscall

    add $a0, $v0, $0 # print a string
    addi $v0, $0, 4
    syscall

    addi $v0, $0, 10
    syscall