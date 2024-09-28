.data
prompt: .asciiz "Enter the decimal number: " 
hex: .asciiz "\nHexadecimal equivalent: "    
bin: .asciiz "\nBinary equivalent: "
resulthex: .space 8                            #Khoang trong luu ket qua hexa
resultbin: .space 32
.text
#@Hexadicimal: Thuc hien viec chuyen doi he thap phan sang he hexa
Hexadecimal:
    la $a0, prompt     
    li $v0, 4          
    syscall		# Thuc hien syscall in ra chuoi yeu cau nhap so thap phan
    li $v0, 5         
    syscall           # Thuc hien syscall nhap so nguyen tu nguoi dung
    
    move $t2, $v0      # Di chuyen gia tri so nguyen vua nhap vao thanh t2 (thuc hien chuyen sang he hexa)
    move $s1, $v0      # Di chuyen gia tri so nguyen vua nhap vao thanh s1 (thuc hien chuyen sang he nhi phan)
    
    la $a0, hex        
    li $v0, 4          
    syscall            # Thuc hien syscall in ra chuoi thong bao ket qua hexa
    
    li $t0, 16          # Khoi tao bien dem = 8
    la $t3, resulthex     # Load dia chi vung nho resulthex vao thanh t3
Loop_hex:
    beqz $t0, Print_hex    # Neu t0 = 0, thoat vong lap
    rol $t2, $t2, 2    # Dich vong sang trai t2 4 bit
    and $t4, $t2, 0x3  # Lay 4 bit cuoi cua t2 bang cach AND t2 voi 0xf (mask voi 1111).
    #ble $t4, 9, Sum    # Neu gia tri duoc luu o t4 <= 9, nhay den Sum
    #addi $t4, $t4, 55  
   #j End              # Neu t4 > 9, cong t4 voi 55 va nhay den End 
Sum:
    addi $t4, $t4, 48  # Neu t4 < 9, cong t4 voi 48
End:
    sb $t4, 0($t3)     # Luu gia tri t4 vào vung nho resulthex
    addi $t3, $t3, 1   # Tang dia chi luu ket qua chu so tiep theo
    addi $t0, $t0, -1  # Giam bot bien dem cua vong lap
    j Loop_hex             # Tiep tuc vong lap
Print_hex:
    la $a0, resulthex     # Load dia chi vung nho resulthex vào thanh ghi $a0.
    li $v0, 4         
    syscall           # Thuc hien syscall in chuoi ket qua da chuyen sang he hexa 
#@Binary: Thuc hien viec chuyen doi he thap phan sang he nhi phan
Binary:	la $a0, bin
	li $v0, 4
	syscall			# Thuc hien syscall in ra chuoi thong bao ket qua binary
	move $a0, $s1		# Di chuyen ket qua so thap phan tu s1 vao a0
	jal Print_bin

Exit: li $v0, 10	#Ket thuc chuong trinh
      syscall

Print_bin: 
	add $t0, $zero, $a0 			# Luu so thap phan vao t0
	add $t1, $zero, $zero 			# Khoi tao t1 = 0
	addi $t3, $zero, 1 			# Khoi tao t3 = 1
	sll $t3, $t3, 31 			# Dich trai t3 31 bit 
	addi $t4, $zero, 32 			# Khoi tao bien dem vong lap t4 = 32
Loop_bin:and $t1, $t0, $t3 			# AND t0 voi t3
	beq $t1, $zero, print 			# Nhay den nhan print neu ket qua phep AND = 0
	add $t1, $zero, $zero 			# Dua t1 ve = 0
	addi $t1, $zero, 1 			# t1 = 1
	j print

print: li $v0, 1
	move $a0, $t1
	syscall					# Thuc hien syscall in ra t1

	srl $t3, $t3, 1				# Dich phai t3 1 bit
	addi $t4, $t4, -1			# Giam bien dem xuong 1 don vi
	bne $t4, $zero, Loop_bin		# Kiem tra dieu kien dung: t4 = 0 ?
	jr $ra					# Sau khi ket thuc vong lap, nhay den nhan Exit, ket thuc chuong trinh
