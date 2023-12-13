main:
    addi $t0, $0, 0 # t0 stores the current row in the array
    addi $t1, $0, 0 # t1 stores the current column in the row of the array
    addi $t3, $0, 0 # t3 stores the address in array im on
    addi $t5, $0, 256
outerloop:
    beq $t0, $t5, end
innerloop:
    beq $t1, $t5, endinner
    lw $t2, 0($t3) # t2 now contains rgb value

    sw $t1, -224($0) #0xFFFFFF20 = monitor x coordinate
    sw $t0, -220($0) #0xFFFFFF24 = monitor y coordinate
    sw $t2, -216($0) #0xFFFFFF28 = monitor color
    sw $0, -212($0)  #0xFFFFFF2C = write pixel
    addi $t1, $t1, 1
    addi $t3, $t3, 4
    j innerloop
endinner:
    addi $t1, $0, 0
    addi $t0, $t0, 1
    j outerloop
end:
    j end