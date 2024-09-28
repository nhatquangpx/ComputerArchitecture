.data
A: .word 1,2,4,3,3,3
Aend: .word
B: .word 3,2,3,1,4,3
Bend: .word
Similar: .asciiz "The arrays are similar"
Not_similar: .asciiz "The arrays are not similar"
.text
#@check_length: Kiem tra do dai hai mang co bang nhau hay khong
check_length: la $s1, A
	la $s2, Aend
	la $s3, B
	la $s4, Bend
	sub $s2, $s2, $s1
	sub $s4, $s4, $s3
	bne $s2, $s4, Not_equal
#--------------------------------------------------------------   
#@run_sort_A: Sap xep mang A theo thu tu tang dan
run_sort_A: la $a0,A #$a0 = Address(A[0])
la $a1,Aend
addi $a1,$a1,-4 #$a1 = Address(A[n-1])
j sort_A #sort
#--------------------------------------------------------------
#thu tuc sort (sap xep lua chon tang dan su dung con tro)
#$a0 tro den phan tu dau tien cua mang chua sap xep
#$a1 tro den phan tu cuoi cua mang chua sap xep
#$t0 vi tri tam thoi cho gia tri cua phan tu cuoi
#$v0 tro den phan tu lon nhat cua mang chua sap xep
#$v1 gia tri phan tu lon nhat cua mang chua sap xep
#--------------------------------------------------------------
sort_A: beq $a0,$a1,done_A #Neu co 1 phan tu thi da duoc sap xep roi
j max_A #goi thu tuc tim max
after_max_A: lw $t0,0($a1) # Lay phan tu cuoi cung vao $t0
sw $t0,0($v0) # Sao chep phan tu cuoi cung vao vi tri max
sw $v1,0($a1) # Sao chep gia tri max vao phan tu cuoi cung
addi $a1,$a1,-4 # Giam con tro xuong phan tu cuoi
j sort_A # Lap lai qua trinh sap xep cho danh sach nho hon
done_A: j run_sort_B # Ket thuc sap xep mang A, chuyen toi sap xep mang B
#------------------------------------------------------------------------
#Thu tuc max: tim gia tri va dia chi cua phan tu max trong danh sach
#$a0 con tro toi phan tu dau tien
#$a1 con tro toi phan tu cuoi cung
#---------------------------------------------------------------------
max_A: addi $v0,$a0,0 # Khoi tao con tro max toi phan tu dau tien
lw $v1,0($v0) # Khoi tao gia tri max toi gia tri dau tien
addi $t0,$a0,0 # Khoi tao con tro tiep theo toi phan tu dau tien
loop_A: beq $t0,$a1,ret_A # Neu tiep theo la cuoi, tra ve
addi $t0,$t0,4 # Tien toi phan tu tiep theo
lw $t1,0($t0) # Lay phan tu tiep theo vao $t1
slt $t2,$t1,$v1 # (tiep theo)<(max) ?
bne $t2,$zero,loop_A # Neu (tiep theo)<(max), lap lai
addi $v0,$t0,0 # Phan tu tiep theo la phan tu max moi
addi $v1,$t1,0 # Gia tri tiep theo la gia tri max moi
j loop_A # Tiep tuc vong lap
ret_A: j after_max_A # Tra ve
#------------------------------------------------------------------------
#@run_sort_B: Sap xep mang B theo thu tu tang dan - Tuong tu sap xep mang A
run_sort_B:la $a0, B #$a0 = Address(B[0])
la $a1,Bend
addi $a1,$a1,-4 #$a1 = Address(B[n-1])
j sort_B #sort

sort_B: beq $a0,$a1,done_B 
j max_B 
after_max_B: lw $t0,0($a1) 
sw $t0,0($v0)
sw $v1,0($a1) 
addi $a1,$a1,-4 
j sort_B 
done_B: j compare # Ket thuc sap xep mang B, so sanh

max_B: addi $v0,$a0,0 
lw $v1,0($v0) 
addi $t0,$a0,0 
loop_B: beq $t0,$a1,ret_B 
addi $t0,$t0,4 
lw $t1,0($t0)
slt $t2,$t1,$v1 
bne $t2,$zero,loop_B 
addi $v0,$t0,0 
addi $v1,$t1,0 
j loop_B 
ret_B: j after_max_B 
#@compare: So sanh tung phan tu cua mang 
compare: 
la $a0, A
la $a1, B		#Lay dia chi phan tu dau tien cua mang A, B luu vao 2 thanh ghi a0, a1
la $a2, Bend		#Luu dia chi phan tu cuoi mang B vao a2 de xet dieu kien dung vong lap
loop_compare:
lw $s0, 0($a0)
lw $s1, 0($a1)		#Lay gia tri phan tu tuong ung voi dia chi duoc luu o a0, a1
bne $s0, $s1, Not_equal #So sanh, neu khong bang nhau thi nhay den Not_equal, ket luan hai mang khong tuong tu
addi $a0, $a0, 4	#Neu bang nhau, tang dia chi a0, a1 them 4 byte de so sanh gia tri 2 phan tu tiep theo cua moi mang
addi $a1, $a1, 4
slt $t0, $a1, $a2	#Kiem tra dieu kien dung: Dia chi hien tai cua mang B duoc luu o a1 co nho hon Bend khong
bnez $t0, loop_compare	#Neu nho hon, tiep tuc vong lap. Neu lon hon hoac bang, dung vong lap, ket luan 2 mang tuong tu
Equal: la $a0, Similar	#Ket luan 2 mang tuong tu va dua ra man hinh
	li $v0, 4
	syscall
	j Exit
Not_equal: la $a0, Not_similar	#Ket luan 2 mang khong tuong tu va dua ra man hinh
	li $v0, 4
	syscall
	j Exit
Exit: li $v0, 10		#Ket thuc chuong trinh
	syscall
