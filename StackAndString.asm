# homework number 3 
# take the user inputed string and display the number of words and characters 
# demonstate the usage of a stack 
# NETID: rxm190019 Reshma Muvvala 

		.data	
msg1: 		.asciiz	"Enter some text:"
msg2:		.asciiz "Thank you, goodbye."	
msgChar:	.asciiz " characters "
msgWord:	.asciiz " words "
space: 		.asciiz	" "
userInput: 	.space 300
wordCount: 	.word 	0
charCount: 	.word	0


		
		.text
main: 
		
		
   		
		li 	$s1, -1			#used to check if s1 is pushed and poped
		
		
		addi	$sp, $sp, -4		# used to push the resgistar s1
		sw	$s1, ($sp)
		sw	$ra, ($sp)
		
		lw	$s1, ($sp) 		#used to pop the registar s1 and restore it
		lw	$ra, ($sp) 
		addi	$sp, $sp, 4
		
		
		
		
						# displays the first messge 
		la	$a0, msg1
		la	$a1, userInput
		li	$a2, 300
		li	$v0, 54	
		syscall
	
       		
		la 	$a0, userInput		# displays input from message one 
		li 	$v0 4
		syscall
		
		
		
		

		
		
		la 	$s2, space		#loading adress into s2 for space character
   		lb 	$t1, 0($s2)		#loading byte for the space character
   		
    		lb 	$t0, 0($a0)		#for the user input loop
		
		jal	loop			#loop for the couting the words
		sw	$t3, wordCount		#stores word count in t3 
		
   		 
   		jal	displayWord		# display the count of the word
   		
   		
   		la	$a0, userInput		#loads user input back into adress a0
   		
   		jal	loop2			#goes to second loop to get character count
   		sw 	$t2, charCount		#stores char count in t2
   		jal	displayChar		#displays the character count 
   
  				
   		li 	$v0, 10			# exits the program 
    		syscall
   		
   		
   		
 displayWord: 
 		lw	$a0, wordCount		#loads word into a0 to the value can print
 		li	$v0, 1			#syscall to print integer					
   		syscall  	
   		
 		li	$v0, 4			#syscall to print string
   		la	$a0, msgWord		#displays the message word
   		syscall
 
	 	jr	$ra			#returns to the main function 
		
displayChar: 
		lw	$a0, charCount	 
		li	$v0, 1			#displays the character count
		
		
   		syscall
   		
		la	$a0, msgChar		# display the word character 	
		li	$v0, 4
		syscall 
		
		la 	$a1, space		#loads the adress of space in a1 because syscall 54 takes in a0, and a1
		la	$a0, msg2		#dialoge message pop up saying good bye
   		li	$v0, 59
   		syscall
		
   		jr	$ra			#returns to the main function 

 		
loop: 
		lb 	$t0, 0($a0)		#begains with the initial adress of user input
 		beq 	$t0, $zero, return1   	#if the adress is zero it will go to return call 
    		beq 	$t0, $t1, increment 	# checks to see if the adress is equal to the space character if true it will go to increment call	
    		addi 	$a0, $a0, 1        	#increments address to next address value	
    		j loop				#iterates through the loop
return1: 
		
		
		add	$t3, $t3, 1		#need to add one more count beacuse space is one less
  		jr 	$ra			#goes back to main function 

increment:              
   		addi 	$t3, $t3, 1 		#increments the word count
   		addi 	$a0, $a0, 1  		#increments address for the input
   		j 	loop 
   		  
loop2: 
		lb 	$t0, 0($a0)		#begains with the initial adress of user input
		beq	$t0, $0, return2	#if the adress is zero it will go to return call 
		addi	$a0, $a0, 1		#increments address to next address value
		addi	$t2, $t2, 1		#increments character count
		j	loop2			#iterates through loop2



return2: 
		sub 	$t2, $t2, 1		#character count is more more due to enter so minus one count
		jr	$ra			#goes back to main function 


		
	
		
		
		
