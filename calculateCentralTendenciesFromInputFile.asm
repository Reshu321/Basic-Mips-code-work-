#homework 3 
#Reshma Muvvala CS2340 section 0W4
#netID: RXM190019 
#open input file, take elements from input file and convert to integers
#sort the values in the input file using selection sort 
#display the mean, median and standard deivation from the values in the input file 
		
		.include	"macro_file.asm"
		.data
arr:		.space 	80
len:		.word	20
byte:		.word	0
mean:		.float	0
median:		.word	0
standardDev:	.float	0
fname:		.asciiz	"input.txt"
		.align	2
buffer:		.space	80

		.text
main:

	la	$a0, fname						#loads the file name in $a0 
	la	$a1, buffer						#loads the buff in in $a1 for the inputfile
	jal 	readFile						#jumps to function to read input file 
	sw	$v0, byte						#stores the bytes in $v0 
	ble	$v0, $0, error						#if the file value is less than zero it will go to the error function
	
	
	
	print_str("\nThe array before: \t")				#prints the string array before
    	la	$t1, arr						#loads the adress of the array in $t1
    	lw	$t2, len						#loads the lentgth og the array in $t2
    	print_array($t1, $t2)						#all the values in the array will print until it reachs the length of $t2
    	
    	
    	la	$a0, arr						#loads adress of array in $a0 
    	la	$a1, len						#loads the length of array in $a1
    	jal	selectionSort						#jumps to the function selection sort 
    	
    	print_str("\nThe array after: \t")				#orint the string array after 
    	la	$t1, arr						#loads the adress of the array in $t1
    	lw	$t2, len						#loads the lentgth og the array in $t2
    	print_array($t1, $t2)						#all the values in the array will print until it reachs the length of $t2
	
	
    	
    	la	$a0, arr						#loads adress of array in $a0 
    	la	$a1, len						#loads the length of array in $a1
    	jal	calcMean						#jumps to the the function mean calculation 
    	s.s	$f1, mean						#stores the mean float in $f1
    	print_str("\nThe mean is: ")					#prints the string the mean is 				
    	print_float($f1)						#displays the value of the mean stored in $f1
    	
	la	$a0, arr						#loads adress of array in $a0 
    	la	$a1, len						#loads the length of array in $a1
    	jal	calcMedian						#jumps to the the function meadian calculation 	
    	move 	$t1, $v1		
    	beq	$t1, 0, printMean 					#moved the check condition to register $t1 and if true it will go to the printmean function 
    	sw	$v0, median						#store median in $v0
    	
    	print_str("\nThe median is: ")					#displays the statement median 
    	li	$v0, 1							#syscall to display int 
    	lw	$a0, median						#loads median in register $a0
    	syscall
    	
    	j	continue						#goes to the continue function 
    	
    	

	
 


printMean:								# printEven function 
	print_str("\nThe mean is: ")					#displays message the mean is 
	print_float($f3)						#prints the mean value stored in $f3
continue:
    	la	$a0, arr						#loads address of array in to $a0 
    	la	$a1, len						#laods adress of the length of the array in $a1
    	l.s	$f1, mean						#loads single value of mean in $f1				
    	jal	calcStandardDev						#jumps to the function calcStandardDev
    	s.d	$f2, standardDev					#stores $the double value of standard deviation in $f2
    	
    	print_str("\nThe standard deviation is: ")			#displays the string the standard devitation
    	print_float($f2)						#prints the standard deviation sotred in $f2

exit:	li	$v0, 10							#exit function 
	syscall

error:									#error function will be called if the input file is not read

	print_str("Could not open file. Program terminated")		#displays the string that the file cant be opened	
	j	exit							#will jump to the exit function 
	


#this function will read the file and have acess to the file contents#
######################################################################

readFile:								
	addi	$sp, $sp, -12						#the stack will store(push) values s1 and s2 and ra		
	sw	$s1, 8($sp)						#pushes s1
	sw	$s2, 4($sp)						#pushes s2
	sw	$ra, ($sp)						#oushes ra
	
	la	$s1, ($a0)						#loads the adress of the file name in s1
	la	$s2, ($a1)						#laods the adress of the input buffer in s2
	
		
	li	$v0, 13							#the syscall to open file 
	la	$a0, ($s1)						#input file name				
	li	$a1, 0							#loads immediate value of 0 into a1
	li	$a2, 0							#loads immediate value of 0 into a2
	syscall				
	move $t1, $v0							# this will save the file descriptor 
	
	
	li	$v0, 14							#the syscall will read from the file 
	move	$a0, $t1						# the file descriptor is moved to a0 
	la	$a1, ($s2)						#loads adress the buffer for the input file
	li	$a2, 80							# loads immediate value of a2 to read a max character values of 80
	syscall
	
	
	la	$a0, arr						#loads the adderess of the array in $a0 				
	lw	$a1, len						#loads the length of the array in $a1
	la	$a2, ($s2)						#loads the adress of buffer 
	jal	extractInts						#jumos to the function extract ints 
	move 	$t0, $v0						#move the byte counter to $t0  	
	
	lw	$ra, ($sp)						#poping values from the stack s1, s2, ra
	lw	$s1, 4($sp)						#popped s1
	lw	$s2, 8($sp)						#popped s2
	addi	$sp, $sp, 12						#popped ra
	
	jr	$ra							#returns back to main function 



 #this function will take string values from file and change them to integers 
######################################################################

extractInts:
	addi	$sp, $sp, -8						#pushed values s1, s2 to the stack 
	sw	$s1, 4($sp)						#pused s1
	sw	$s2, ($sp)						#pused s2
	
	la	$s1, ($a0)						#loads the adress of array in s1
	move    $t1, $a1						#setting t1 equal to the length of the array 				
	la	$s2, ($a2)						#loads adress of length of buffer into s2
	li	$t0, 0							#sets byte count to zero 
	li	$t1, 48							#load immediate values to to ignore asciis characters 
	li	$t2, 57							#values less than 48, or values greater than 57
	li	$t5, 10							#asciis character value for a space is 10 
	li	$t6, 0							# array index 
	
loopExtract:	
	lbu	$t3, ($s2)						#loads byte in t3 with buffer 
	beq	$t3, $0, lastInt					#if the byte is equal to zero go to function last int
	beq	$t3, $t5, nextInt					#if the byte is equal to 1o then a new line, it will go to the function next int
	blt	$t3, $t1, nextByte					#if the byte is less than 48 it will go to the next byte function 
	bgt	$t3, $t2, nextByte					#if the byte is greater than 57 it will go to the next byte function
	mult	$t4, $t5						#mutlipy to make room for space 
	mflo	$t4							#move from low to register t4
	sub	$t3, $t3, $t1						#subtract 48 
	add	$t4, $t4, $t3						#add the value of t4
	
nextByte:
	addi	$s2, $s2, 1						#increments the next byte of the buffer
	addi	$t0, $t0, 1						#increments the byte count 
	j	loopExtract						#jumps to the function loopExtract
nextInt:
	sll	$t7, $t6, 2						#pc counter i*4
	add	$t8, $s1, $t7						# sets array value 
	sw	$t4, ($t8)						#the value will be stored in the array 
	addi	$t6, $t6, 1						#increment array index 
	move	$t4, $0							#sets t4 back to zero 
	j	nextByte						#jumps to the function next byte
	
lastInt:								
	sll	$t7, $t6, 2						#pc counter i*4
	add	$t8, $s1, $t7						# sets array value 
	sw	$t4, ($t8)						#the value will be stored in the array
	addi	$t6, $t6, 1						#increment array index 
	move	$t4, $0							#sets t4 back to zero 	
endFile:
	lw	$s1, 4($sp)						#pops two values from stacks s1 and s2 
	lw	$s2, ($sp)						#popped s2
	addi	$sp, $sp, 8				
	
	move	$v0, $t0						#moves the byte back into register v0
	jr	$ra							#jumps back to main function 

#this function will take the unsorted list and sort them in acceding order
######################################################################

selectionSort:
	la	$t0, ($a0)						#loads the adress of array in register t0
	lw	$t1, ($a1)						#loads the length of array in register t1
	li	$t2, 0							#loads immediate 0 in t2
	li	$t3, 0							#loads immediate 0 in t3
	
outterForLoop:	
	subi	$t1, $t1, 1						#decrement length 
	beq	$t2, $t1, done						#if length equals zero it will jump to the function done
	move	$t4, $t2						#valye of t2 into t4 for minimum index
	addi	$t1, $t1, 1						#increments length 
	addi	$t3, $t2, 1						#k = i+1
	
innerForLoop:			
	sll	$t8, $t3, 2						# k is multiplied by 4 (K*4)	
	add	$t5, $t0, $t8						#sets array value in t5
	sll	$t8, $t4, 2						#gets minimum index 
	add	$t6, $t0, $t8						#minimum index at current element in array 
	lw	$t6, ($t6)						#loads word of array (i) 
	lw	$t5, ($t5)						#loads word of array with minimum element (k)
	bge	$t5, $t6, nextElement					#if array with minimum element is less than array with element k then go to next element
	move	$t4, $t3						#otherwise take j as the minimum element 
		
nextElement:
	addi	$t3, $t3, 1						#increments i 
	blt	$t3, $t1, innerForLoop					#if i is less than length the go the the innerforloop function 

	beq	$t4, $t2, updateI					#will go back into outter loop if minimum index does not equal index 		
	sll	$t8, $t4, 2						#shift to get minimum index 
	add	$t6, $t0, $t8						#adds minimum index to array 
	sll	$t8, $t2, 2						#shifts index to next element 
	add	$t5, $t0, $t8						#adds element to array of index
	
	lw	$t8, ($t5)						#the index of array is in register t8
	lw	$t7, ($t6)						#the minimum index of the array is in t6
	sw	$t8, ($t6)						#stores index 
	sw	$t7, ($t5)						#stores minimum index
	
updateI:
	addi	$t2, $t2, 1						#increments i for outter loop
	j	outterForLoop						#jumps to the function outter loop 
done:							
	jr	$ra							# onces sorted will jump back to the main function 
#this function will calculate the mean from the givien numbers from the inputfile#
######################################################################
calcMean:
	addi	$sp, $sp, -8						#pushes two values into stack s1 and s2
	sw	$s1, 4($sp)						#pushed s1
	sw	$s2, ($sp)						#pushed s2
	
	la	$s1, ($a0)						#loads the addresss of the array in s1
	lw	$s2, ($a1)						#loads the buffer into s2
	li	$t0, 0							#loads immediate value of 0 into t0 
	li	$t4, 0							#loads immediate value of 0 into t4
	
returnMean:
	sll	$t1, $t0, 2						#i*4
	add	$t2, $s1, $t1						#array is added to register t2 
	lw	$t2, ($t2)						#loads array element
	add	$t4, $t4, $t2						#addes array element to t4
	addi	$t0, $t0, 1						#increments counter i++
	blt	$t0, $s2, returnMean					#if counter is less than the elements in the array it will loop again to return Mean 
	
	mtc1	$t4, $f1						#convert from from float pointer to register
	cvt.s.w $f1, $f1						#this will convert the sum to a float 	
	mtc1	$s2, $f3						#converts  from float pointer to register 		
	cvt.s.w $f3, $f3						#the is convert length to a float 
	div.s	$f1, $f1, $f3						#divide the sum by the length to get mean 
	
	lw	$s2, ($sp)						#pops values froms stack 
	lw	$s1, 4($sp)						#popped s1
	addi	$sp, $sp, 8						#popped s2
	jr	$ra							#return to main function 



#this function will calculate the median from the givien numbers from the inputfile#
######################################################################
calcMedian:

	la	$t1, ($a0)						#loads the array in register t1
	lw	$t2, ($a1)						#loads the buffer of array in s2
	li	$t0, 2							#loads immediate value of 2 into t0

	div	$t2, $t0						#length of array divided by 2 			
	mfhi	$t5							#move from hi into register t5
	bne	$t5, $0, Median						#if the quotenct does not equal zero it will go to the median function 
	
	mflo	$t3							#moves from low to register t3 to get minimum index on the right
	addi	$t4, $t3, -1						#get minimum index on left
	sll	$t3, $t3, 2						#shift array right index 
	sll	$t4, $t4, 2						#shift array left index 

	add	$t3, $t1, $t3						#gets the right element from array 	
	add	$t4, $t1, $t4						#gets the left element from the array 
	lw	$t3, ($t3)						#load right element
	lw	$t4, ($t4)						#load left element 
	add	$t3, $t3, $t4						# summation 
	li	$t4, 2							#load immediate 2 into t4
	
	mtc1 	$t3, $f3						#convert float pointer to register for right element
	mtc1 	$t4, $f4						#convert float pointer to register fro left element 
	cvt.s.w $f4, $f4						#convert right element to float 
	cvt.s.w $f3, $f3						#convert left element to float
	div.s 	$f3, $f3, $f4						#divide the summation by 2

	li	$v1, 0							#loads immediate value of v1 as zero for even check 
	jr	$ra							#jumps back to the main function 
Median:
	mflo	$t3							#move right element from low					
	sll	$t3, $t3, 2						#index
	add	$t3, $t1, $t3						#array with middle index
	lw	$t3, ($t3)						#loads middle index 
	
	li	$v1, 1							#laods immediate value of v2 as 1 for odd check 
	move	$v0, $t3						#sets vo equal to the middle index 					
	jr	$ra							#jumps back to main function 

#this function will calculate the SD from the givien numbers from the inputfile#
######################################################################
calcStandardDev:
	la	$t1, ($a0)						#loads the address of array in t1
	lw	$t2, ($a1)						#loads the buffer of array in t1
	li	$t0, 0							#loads immediate value 0 in t0 
	
	li	$t8, 0							#loads immediate value 0 into t8	
	mtc1	$t8, $f2						#converts from float point to register
	cvt.s.w $f2, $f2						#converts back into float 
	
	addi	$t8, $t2, -1 						#length minus 1 
	mtc1 	$t8, $f7						#converts from float point to register
	cvt.s.w $f7, $f7						#converts back into float 
	
	
standardLoop:
	sll	$t3, $t0, 2						#i*4	
	add	$t3, $t1, $t3						#element at array 
	lw	$t3, ($t3)						#loads element from array 
	mtc1 	$t3, $f0						#converts from float pointer to register 	
	cvt.s.w $f0, $f0						#converts back to float pointer
	
	sub.s 	$f0, $f0, $f1						#subtracts to get negitive mean (element - mean)
	mul.s	$f0, $f0, $f0						#mutlplies (element -mean)^2
	add.s 	$f2, $f2, $f0						#summation 
	addi	$t0, $t0, 1						#increment array i++
	blt	$t0, $t2, standardLoop					#if i is less than the length then loop back to standard loop function 

	div.s 	$f2, $f2, $f7						#summation divided by elements -1
	sqrt.s	$f2, $f2						# squarroots the entire fraction 
	jr	$ra							#jumps back to the main function 
