# LogisimCPU
Built a CPU from scratch that can run most MIPS assembly programs

# Features:
## MIPS execution:
Compile MIPS assembly code with "assembler.cpp."
Usage:
- "make" to compile the assembler
- ./assemble kernel.asm sourcefile.asm static_mem_encoding.bin instruction_encoding.bin

## Controllers
This circuit has three separate controllers, all with tests that can be found in the "tests" folder.
- Joystick: joystick controls the LED matrix
- 7-segment displays: can display up to a 3 digit number
- LED Matrix: 15x15 single color LED matrix

## Graphics Card:
GPU can be used to draw rectangles extremely efficiently.
Drawing rectangles:
- Syscall 17 draws the rectangle
  - store the (x, y) the rectangle should start at in a0
  - store the width of the rectangle in a1
  - store the height of the rectangle in a2
  - store the RGB hex (in decimal) of the rectangle in a3
- Syscall 18 checks to see if the GPU has finished drawing (see gputest.asm for exact usage)

## Static memory:
Two types of static memory are able to be used in MIPS programs: .word, and .asciiz

## Syscalls:
Basic syscalls have been implemented. These include:
- Syscall 1: Prints integer in a0
- Syscall 4: Prints a string from static memory with first character at the value of a0
- Syscall 5: Reads integer, stores it in v0
- Syscall 8: Reads a string, stores the pointer to the location of that string in v0
- Syscall 9: Allocates memory on the heap, stores pointer to that memory in v0
- Syscall 10: Ends the program
- Syscall 11: Prints a character in a0
- Syscall 12: Reads a character, stores it in v0
- Syscall 13: Puts value in a0 onto the 7 segment displays
- Syscall 14: Resets the 7 segment displays
- Syscall 15: Stores the X and Y values from the joystick in v0
- Syscall 16: Puts the value in a0 onto the cordinate a0 represents on the LED matrix
- Syscall 17: Starts drawing with the GPU, with the information about the rectangle in a0-a3
- Syscall 18: Checks if the GPU is ready to draw again, with the bool representation of yes or no stored in v0

