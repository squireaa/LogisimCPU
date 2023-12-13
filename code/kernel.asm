#This is starter code, so that you know the basic format of this file.
#Use _ in your system labels to decrease the chance that labels in the "main"
#program will conflict

.data
.text
_syscallStart_:
    beq $v0, $0, _syscall0 #jump to syscall 0
    addi $k1, $0, 1
    beq $v0, $k1, _syscall1 #jump to syscall 1
    addi $k1, $0, 4
    beq $v0, $k1, _syscall4 #jump to syscall 4
    addi $k1, $0, 5
    beq $v0, $k1, _syscall5 #jump to syscall 5
    addi $k1, $0, 8
    beq $v0, $k1, _syscall8 #jump to syscall 8
    addi $k1, $0, 9
    beq $v0, $k1, _syscall9 #jump to syscall 9
    addi $k1, $0, 10
    beq $v0, $k1, _syscall10 #jump to syscall 10
    addi $k1, $0, 11
    beq $v0, $k1, _syscall11 #jump to syscall 11
    addi $k1, $0, 12
    beq $v0, $k1, _syscall12 #jump to syscall 12
    addi $k1, $0, 13
    beq $v0, $k1, _syscall13
    addi $k1, $0, 14
    beq $v0, $k1, _syscall14
    addi $k1, $0, 15
    beq $v0, $k1, _syscall15
    addi $k1, $0, 16
    beq $v0, $k1, _syscall16
    addi $k1, $0, 17
    beq $v0, $k1, _syscall17
    addi $k1, $0, 18
    beq $v0, $k1, _syscall18
    #Error state - this should never happen - treat it like an end program
    j _syscall10
    #18 lines

#Do init stuff
_syscall0:
    addi $sp, $sp, -4096
    la $k1, _END_OF_STATIC_MEMORY_ # points at the current value in static memory
    sw $k1, -3840($0)
    j _syscallEnd_

#Print Integer
_syscall1:
    addi $sp, $sp, -24
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)
    sw $t5, 20($sp)
    # Print Integer code goes here
    addi $t0, $a0, 0 # the rest of the numbers to print out
    addi $t5, $0, 10 # 10
    addi $t1, $0, 0 # number of bits to add to stack in future 
toploop1:
    div $t0, $t5
    addi $sp, $sp, -4
    addi $t1, $t1, 4
    mfhi $t2
    sw $t2, 0($sp)
    mflo $t0
    slt $t2, $t0, $t5
    beq $t2, $0, toploop1
    addi $t0, $t0, 48
    sw $t0, -256($0)
toploop2:
    lw $t0, 0($sp)
    addi $t0, $t0, 48
    sw $t0, -256($0)
    addi $t1, $t1, -4
    addi $sp, $sp, 4
    beq $t1, $0, endloop1
    j toploop2
endloop1:
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $t4, 16($sp)
    lw $t5, 20($sp)
    addi $sp, $sp, 24
    jr $k0

#Read Integer
_syscall5:
    addi $sp, $sp, -24
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)
    sw $t5, 20($sp)
    addi $t2, $0, 0
    addi $t3, $0, 10
    addi $t4, $0, 47
    addi $t5, $0, 58
toploop3:
    lw $t0, -240($0) #0xFFFFFF10 = keyboard ready
    beq $t0, $0, toploop3
    lw $t0, -236($0)
    slt $t1, $t4, $t0
    beq $t1, $0, endloop3
    slt $t1, $t0, $t5
    beq $t1, $0, endloop3
    # if it is between 48 and 57
    addi $t0, $t0, -48
    mult $t2, $t3
    mflo $t2
    add $t2, $t2, $t0
    sw $0, -240($0)
    j toploop3
endloop3:
    addi $v0, $t2, 0
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $t4, 16($sp)
    lw $t5, 20($sp)
    addi $sp, $sp, 24
    jr $k0

#Heap allocation
_syscall9:
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    lw $t0, -3840($0)
    addi $v0, $t0, 0
    add $t0, $t0, $a0
    sw $t0, -3840($0)
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    jr $k0

#"End" the program
_syscall10:
    j _syscall10

#print character
_syscall11:
    sw $a0, -256($0)
    jr $k0

#read character
_syscall12:
    addi $sp, $sp, -4
    sw $t0, 0($sp)
loop12:
    lw $t0, -240($0)
    beq $t0, $0, loop12
    lw $v0, -236($0)
    sw $0, -240($0)
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    jr $k0

#extra credit syscalls go here?

# print a string - pointer stored in a0
_syscall4:
    addi $sp, $sp, -4
    sw $t0, 0($sp)
beginPrintString:
    lw $t0, 0($a0) # first character
    beq $t0, $0, endPrintString
    sw $t0, -256($0)
    addi $a0, $a0, 4
    j beginPrintString
endPrintString:
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    jr $k0

# read a string - store it on stack as reading and keep track of how much mem we need to allocate
# then allocate the mem on the heap and copy from the stack to the heap
_syscall8:
    addi $sp, $sp, -24
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)
    sw $a0, 20($sp)
    addi $t2, $0, 10 # new line character ascii
storeStringStackloop:
    lw $t0, -240($0) # check if the keyboard is ready
    beq $t0, $0, storeStringStackloop # if not, back to top
    lw $t1, -236($0) # store the character from keyboard in t1
    sw $0, -240($0) # clear that character
    beq $t1, $t2, stringToHeap # check if character is a new line
    addi $sp, $sp, -4 # allocate the space to store this in static
    addi $t3, $t3, 4 # keep track of amount to allocate on heap
    sw $t1, 0($sp) # store the character on the stack
    j storeStringStackloop
stringToHeap:
    addi $sp, $sp, -4
    sw $k0, 0($sp)
    add $a0, $t3, $0 # amount to allocate on heap
    addi $v0, $0, 9 # heap allocation
    syscall
    lw $k0, 0($sp)
    addi $sp, $sp, 4
    add $t0, $v0, $0 # pointer to heap
    add $t0, $t0, $t3 # starting the heap pointer at the bottom
    addi $t2, $0, 0
    sw $t2, 0($t0) # add the null character to the end
loop8:
    addi $t0, $t0, -4 # move up the heap
    lw $t1, 0($sp) # retrieve stuff from stack
    sw $t1, 0($t0) # store it on the heap
    addi $sp, $sp, 4 # deallocate the static mem
    addi $t3, $t3, -4
    beq $t3, $t2, endReadString # nothing left to move
    j loop8
endReadString:
    add $v0, $t0, $0 # want to return the pointer to the heap
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $t4, 16($sp)
    lw $a0, 20($sp)
    addi $sp, $sp, 24
    jr $k0

_syscall13: # put a0 onto the 7 seg displays
    sw $a0, -208($0)
    jr $k0

_syscall14: # reset 7 segs
    sw $0, -204($0)
    jr $k0

_syscall15: # store x and y from joystick in v0
    lw $v0, -200($0)
    jr $k0

_syscall16: # write x and y from joystick to led matrix
    sw $a0, -196($0)
    jr $k0

_syscall17: # start drawing with gpu
    sw $a0, -192($0)
    sw $a1, -188($0)
    sw $a2, -184($0)
    sw $a3, -180($0)
    sw $0, -168($0)
    jr $k0

_syscall18: # ask gpu if its ready again, if it is, it will be nonzero, else 0
    lw $v0, -176($0)
    beq $v0, $0, noreset
    sw $0, -172($0)
noreset:
    jr $k0


_syscallEnd_: