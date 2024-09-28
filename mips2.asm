#Laboratory Exercise 2, Assignment 6
.data 
I : .word 3
J : .word 6
m :  .word 2
n: .word 3
.text 
 la $a0, I 
 la $a1, J 
 lw $s1, 0($a0) 
 lw $s2, 0($a1) 
 la $a0, m
 la $a1, n
 lw $s6, 0($a0)
 lw $s7, 0($a1)
 addi $t1, $zero, 5
 addi $t2, $zero, 5
 addi $t3, $zero, 5
 add $s3, $s1, $s2
 add $s4, $s6, $s7
 beq $s3, $s4, endif
slt $t0,$s3,$s4
bne $t0,$zero,else 
addi $t1,$t1,1 
addi $t3,$zero,1 
j endif 
else: addi $t2,$t2,-1 
add $t3,$t3,$t3 
endif: