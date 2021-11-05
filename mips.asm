# Chuong trinh: Selection sort day so thuc chinh xac don co 10 pt
# Data segment
	.data
# Cac dinh nghia bien
flo_a:		.space		40	# day so thuc 10 phan tu
int_n:		.word		10	# so phan tu (spt)
# Cac cau nhac nhap du lieu
file:		.asciiz 	"D:/MIPS Code/FLOAT10.BIN"	# duong dan file
xuat_day:	.asciiz 	"Day da doc:\t"
xuat_kq:	.asciiz		"Day da duoc sap xep:\t"
buoc:		.asciiz		"Buoc "
colon:		.asciiz 	": "
#----------------------------------------
# Code segment
	.text
	.globl	main
#----------------------------------------
# Chuong trinh chinh
#-main-----------------------------------
main:
# Doc du lieu (syscall)
  # open file FLOAT10.BIN
	addi	$v0,$zero,13	
	la	$a0,file
	addi	$a1,$zero,0
	addi	$a2,$zero,0
	syscall
	add	$s6,$v0,$zero
  # read file FLOAT10.BIN
	addi	$v0,$zero,14	
	add	$a0,$s6,$zero
	la	$a1,flo_a
	addi	$a2,$zero,40
	syscall	
  # close file FLOAT10.BIN	
	addi	$v0,$zero,16	
	add	$a0,$s6,$zero
	syscall
  # xuat cau nhac 
	la	$a0,xuat_day	
	addi	$v0,$zero,4
	syscall	
  # xuat day doc duoc tu file	
	la	$a0,flo_a
	lw	$a1,int_n
	jal	print		
# Xu ly
  # goi ham sap xep sort
	la	$a0,flo_a	
	lw	$a1,int_n
	jal	sort
# Xuat ket qua (syscall)
  # xuat cau nhac in kq
	la	$a0,xuat_kq
	addi	$v0,$zero,4
	syscall
  # xuat day da duoc sap xep
	la	$a0,flo_a	
	lw	$a1,int_n
	jal 	print
# Ket thuc chuong trinh (syscall)
Kthuc:	addi	$v0,$zero,10
	syscall
#-end main-------------------------------

#----------------------------------------
# Chuong trinh con sort: sap xep cac phan tu trong day
# Input: $a0 = addr(a[]), $a1 = spt n
# Output: cac buoc co thay doi thu tu trong day
# Reserved: $ra, $s2, $s1, $s0
#----------------------------------------
sort:
	addi	$sp,$sp,-16
	sw	$ra,12($sp)
	sw	$s2,8($sp)
	sw	$s1,4($sp)
	sw	$s0,0($sp)
	
	add	$s1,$a0,$zero	# $s1 = $a0 = addr(arr[])
	add	$s2,$a1,$zero	# $s2 = $a1 = n
	addi	$s0,$zero,0	# $s0 = i = 0 (for - init)
sort_cond:
	addi	$t0,$s2,-1	# $t0 = $s2 - 1 = n - 1
  # if (i < n - 1) then continue
	slt	$t1,$s0,$t0
	beq	$t1,$zero,sort_exit
  # goi ham tim vi tri phan tu nho nhat	minIndex
	add	$a0,$s1,$zero	
	add	$a1,$s2,$zero
	add	$a2,$s0,$zero
	jal	minIndex
	add	$t2,$v0,$zero	# $t2 = $v0 = kq cua ham minIndex 
  # if (minIndex == i) ket thuc	
	beq	$t2,$s0,sort_loop
  # if (minIndex != i) swap arr[minIndex] va arr[i]
    # temp = $f4 = arr[i]
	sll	$t1,$s0,2
	add	$t1,$s1,$t1
	lwc1	$f4,0($t1)
    # $f5 = arr[minIndex]	
	sll	$t2,$t2,2
	add	$t2,$s1,$t2
	lwc1	$f5,0($t2)	
    # swap arr[minIndex] va arr[i]
	swc1	$f5,0($t1)
	swc1	$f4,0($t2)	
    # in buoc co thu tu thay doi trong day
      # xuat cau nhac buoc
	la	$a0,buoc	
	addi	$v0,$zero,4
	syscall
      # xuat thu tu buoc
	addi	$a0,$s0,1	
	addi	$v0,$zero,1
	syscall
      # xuat dau hai cham	
	la	$a0,colon	
	addi	$v0,$zero,4
	syscall
      # goi ham in phan tu print	
	add	$a0,$s1,$zero	
	add	$a1,$s2,$zero
	jal 	print		
sort_loop:
	addi	$s0,$s0,1	# $s0 = i += 1 
	j	sort_cond
sort_exit:
	lw	$s0,0($sp)
	lw	$s1,4($sp)
	lw	$s2,8($sp)
	lw	$ra,12($sp)
	addi	$sp,$sp,16
	jr	$ra
#----------------------------------------

#----------------------------------------
# Chuong trinh con print: in cac phan tu trong day
# Input: $a0 = addr(a[]), $a1 = spt n
# Output: cac phan tu trong day
# Reserved: $s0
#----------------------------------------
print:
	addi	$sp,$sp,-4
	sw	$s0,0($sp)
	addi	$s0,$zero,0	# $s0 = i = 0 (for - init)
print_loop:
  # if (i < n) then continue
	slt	$t0,$s0,$a1
	beq	$t0,$zero,print_exit
	la	$a0,flo_a
	sll	$t1,$s0,2
	add	$t1,$a0,$t1
  # in phan tu arr[i]	
	lwc1	$f12,0($t1)	
	addi	$v0,$zero,2
	syscall
  # in tab
	addi	$a0,$zero,'\t'	
	addi	$v0,$zero,11
	syscall
  # lap lai vong lap	
	addi 	$s0,$s0,1
	j	print_loop
print_exit:
  # xuong dong
	addi	$a0,$zero,'\n'
	addi	$v0,$zero,11
	syscall
  # ket thuc ham
	lw	$s0,0($sp)
	addi	$sp,$sp,4
	jr	$ra
#----------------------------------------

#----------------------------------------
# Chuong trinh con minIndex: tim vi tri pt nho nhat trong day
# Input: $a0 = addr(a[]), $a1 = spt n, $a2 = vi tri bat dau tim
# Output: $v0 = vi tri pt nho nhat
# Reserved: $s1, $s0
#----------------------------------------
minIndex:
	addi	$sp,$sp,-8
	sw	$s1,4($sp)	# $s1 = i
	sw	$s0,0($sp)	# $s0 = vi tri min = vi tri dau de xet
	add	$s0,$a2,$zero	# $s0 = vi tri dau de xet
	addi	$s1,$s0,1	# $s1 = i = $s0 + 1 (for - init)
min_cond:
  # if (i < n) then continue
	slt	$t0,$s1,$a1
	beq	$t0,$zero,min_exit
  # $f4 = arr[dau] = arr[minIndex] = min
	sll	$t1,$s0,2
	add	$t1,$a0,$t1
	lwc1 	$f4,0($t1)	
  # $f5 = arr[i]
	sll	$t2,$s1,2
	add	$t2,$a0,$t2
	lwc1	$f5,0($t2)	
  # if (arr[i] < arr[minIndex]) minIndex = i
	c.lt.s	$f5,$f4
	bc1f	min_loop
  # then minIndex = i)
	add	$s0,$s1,$zero
min_loop:
	addi	$s1,$s1,1
	j	min_cond
min_exit:	
	add	$v0,$s0,$zero
	lw	$s0,0($sp)
	lw	$s1,4($sp)
	addi	$sp,$sp,8
	jr	$ra
#----------------------------------------
