.data 
i : .word 0 
n : .word 3
step: .word 1
Max: .word 0 
A:  .word 10,5, -20, 6, 22
.text 
 la $t8, i 
 la $t9, n
 la $k0, step
 la $k1, Max
 la $s2, A
 lw $s1, 0($t8) 
 lw $s3, 0($t9) 
 lw $s5, 0($k1)
 lw $s4, 0($k0)
 negate 
 neg $s5,$t0
loop: 
add $s1,$s1,$s4 
add $t1,$s1,$s1 
add $t1,$t1,$t1 
add $t1,$t1,$s2 
lw $t0,0($t1) 
slt $a1, $zero, $t0
 beq $a1,$zero,negate
 add $a0, $zero, $t0
 j cont
negate: 
 neg $a0,$t0
 cont:
slt $t0,$a0,$s5
bne $t0,$zero,end
add $s5,$zero,$a0
end:
bne $s1,$s3,loop 