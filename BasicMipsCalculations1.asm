# homework 1
# Reshma Muvvala 
# This program  gets user's name and three integers 
# then calculates 3 expressions and displays the results
		.data 

a: 		.word 		0	
b: 		.word		0
c: 		.word		0	
out1: 		.word		0
out2: 		.word		0
out3: 		.word		0	
UsersName: 	.space		20
msg1: 		.asciiz		"What is your name? "
msg2:		.asciiz		"Enter a integer 1-100: "
msg3:		.asciiz		"Your response was: "
Final_msg: 	.asciiz 	"Your answers are: \n"

		 .text
main: 	
		# prompt user for name 
		la 	$a0, msg1
		li 	$v0, 4
		syscall 
		
		#get Users name
		li	$v0, 8
		li	$a1, 20
		la	$a0, UsersName
		syscall
		
		
		
		 
		
		#prompt user to enter an int a
		la 	$a0, msg2
		li 	$v0, 4
		syscall 
		
		#get int from user a
		li	$v0, 5			# this allows for user input 
		syscall 
		
		la      $t5, a
       		sw      $v0, 0($t5)     	# int is now in t5

		#prompt user to enter an int b
		la 	$a0, msg2
		li 	$v0, 4
		syscall 
		
		#get int from user  b
		li	$v0, 5
		syscall 
		la      $t6, b
       		sw      $v0, 0($t6)    		# it is now in t6
		
		#prompt user to enter an int c
		la 	$a0, msg2
		li 	$v0, 4
		syscall 
		
		#get int from user c
		li	$v0, 5
		syscall 
		la      $t7, c
       		sw      $v0, 0($t7)     	# int is now in t7
		
		
		lw      $t0, 0($t5)     	# load ints in $t0, $t1, $t2
       		lw      $t1, 0($t6)
		lw	$t2, 0($t7)
		
		
		la	$a0, Final_msg		# displays the message in Final_msg	
		li	$v0, 4			#allows for print statment
		syscall
		
		li	$v0, 4			
		la	$a0, UsersName		#dispays the user's name
		syscall
		
		#calc 1  2a - c + 4
		li      $v0,4           	# displays the first calculation        
       		la      $a0, out1
		syscall
       		 
		add 	$t3, $t0, $t0		# t3= t0+t0
		sub 	$t4, $t3, $t2		# t4= t3-t2
		add	$t4, $t4, 4		# t4= t4+4
		li	$v0, 1			#system call to print the int
		move	$a0, $t4		# a0=t4
		syscall
		
		
		li $a0, 32			# prints space
		li $v0, 11  			# number for printing character
		syscall
		
		#calc 2 b - c +(a-2)
		
		li      $v0,4           	# displays second calculation      
       		la      $a0, out2
		syscall
		sub	$t4, $t0, 2		# t4= t0-2
		sub	$t3, $t1, $t2		# t3= t1-t2
		add	$t3, $t3, $t4		# t3= t3+t4
		li	$v0, 1			#system call to print the int
		move	$a0, $t3		#a0=t3
		syscall
		
		#prints space between ints
		li $a0, 32
		li $v0, 11  
		syscall
		
		#calc 3 (a + 3) - (b - 1) + (c + 3) 
		
		li      $v0,4           	#displays third calculation	       
       		la      $a0, out3
       		syscall 
       		
       		add	$t4, $t0, 3		# t4= t0+3
       		sub 	$t3, $t1, 1		# t3= t1-1
       		add	$t8, $t2, 3		# t8= t2+3
       		sub	$t4, $t4, $t3		# t4= t4-t3
       		add     $t8, $t4, $t8		# t8= t4+t8
       		li	$v0, 1			#system call to print the int
		move	$a0, $t8		#a0=t8
		syscall
       		
       		
		
		
		
		
exit:	
	li	$v0, 10				#end program
	syscall
		
