.data
ask_str1: .asciiz "Enter a number PLEASE: "
result_str: .asciiz "\nBinary equilvalent: "
.align 2

.text
.globl __start

__start:
# ask and store the first number
li $v0, 4
la $a0, ask_str1
syscall
li $v0, 5
syscall
move $a0, $v0

jal print_bin

# New Line
li $v0, 11
li $a0, 10
syscall

li $v0, 10
syscall

print_bin:

add $t0, $zero, $a0 # put our input ($a0) into $t0
add $t1, $zero, $zero # Zero out $t1
addi $t3, $zero, 1 # load 1 as a mask
sll $t3, $t3, 31 # move the mask to appropriate position
addi $t4, $zero, 32 # loop counter
loop:

and $t1, $t0, $t3 # and the input with the mask
beq $t1, $zero, print # Branch to print if its 0

add $t1, $zero, $zero # Zero out $t1
addi $t1, $zero, 1 # Put a 1 in $t1
j print


print: li $v0, 1
move $a0, $t1
syscall

srl $t3, $t3, 1
addi $t4, $t4, -1
bne $t4, $zero, loop

jr $ra