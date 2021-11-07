#Reshma Muvvala 
#RXM190019
#CS2340 homework 4

########Homework 4 details##################
#the code displays a box with pixels that demonstrates 
#the marquee effect with a keyboard functionality 
#that when a user inputs w,a,s,d it will shift the box in correspoding direction


.eqv WIDTH 64							# width of the screen pixels is 256/8=32
.eqv HEIGHT 64							# height of screen in pixels


#colors
.eqv	RED 	0x00FF0000
.eqv	GREEN 	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW  0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA 0x00FF00FF
.eqv 	GREY	0x00FFFFF0

.data

colors: .word MAGENTA, CYAN, YELLOW, WHITE, BLUE, GREEN, RED, GREY	#colors array 


.text

main:
	li 	$t4, 0						#index for color array 
	la 	$t3, colors 					#load adress of color array into t3
	addi 	$a0, $0, WIDTH   				#the x value
	sra 	$a0, $a0, 1					
	addi 	$a1, $0, HEIGHT  				#the y value
	sra 	$a1, $a1, 1
	
	li	$s3, 20  #x1 
	li	$s4, 20	 #y1
	li	$s5, 27	 #x2
	li	$s6, 27	 #y2
	j	BIGLOOP						#jumps to the bigloop

zero: 								#function to begin with the first element in the colors array 
	li	$t4, -1						#loads immediate value of -1 into t4
	j	BIGLOOP						#jumps to bigloop
	
BIGLOOP: 							#######This function will allow for the marquee effect and will run the loop infitely until the user enters a space########
	bge	$t4, 8, zero					#if t4 is greater than 8 jump to zero so it can reset back to first element in array 
	addi	$t4, $t4, 1					#increment index 
	li	$t0, 0						#load immdiate t0 =0
	li	$t1, 7						#load immediate t1=7
	
	
	move	$a0, $s3					#updated values from loopkey function 
	move	$a1, $s4					#
	move	$a0, $s5					#
	move	$a1, $s6					#
						
	jal 	loopTopRow					#jumps to loop top row
	bne	$t0, $t1, loopTopRow				#if t0 !=7 then jump to looptoprow
	bge	$t4, 8, StartOver				#if t4 is greater than 8 jump to zero so it can reset back to first element in array 	
	
	li	$t0, 0						#sets t0 = 0 again 
	jal	loopRightColumn					#jumps to loop right column
	bne	$t0, $t1, loopRightColumn			#if t0 !=7 then jump to loopright column
	bge	$t4, 8, StartOver				# if t4 is greater than 8 jump to zero so it can reset back to first element in array 
		
	li	$t0, 0						#sets t0 = 0 again 
	jal	loopBottomRow					#jumps to loop bottom row
	bne	$t0, $t1, loopBottomRow				#if t0 !=7 then jump to loop bottom row
	bge	$t4, 8, StartOver				# if t4 is greater than 8 jump to zero so it can reset back to first element in array 
	
	li	$t0, 0						#sets t0 = 0 again 
	jal	loopLeftColumn					#jumps to loop left column 
	bne	$t0, $t1, loopLeftColumn			#if t0 !=7 then jump to loop left column 
	bge	$t4, 8, StartOver				# if t4 is greater than 8 jump to zero so it can reset back to first element in array 
	
	addi	$t4, $t4, 1					#increments colors array index for next color 
	lw	$t7, 0xffff0000					#loads input value if there is any 
	bne	$t7, 0, loopKey					#if user enters something then jumps to loopkey function 
	j	BIGLOOP						#else it will be an infinte loop and jumps at the top of BIGLOOP
	
loopLeftColumn: 						######### left column of box #########
	addi	$t4, $t4, 1					#increments colors array index for next color 
	bge	$t4, 8, StartOver				#if t4 is greater than 8 jump to zero so it can reset back to first element in array 
	addi	$a1, $a1, -1					#decrements y value to add pixels from bottom to top 
	beq	$s7, 1, black_pixel				#if s7 = 1 then jump to loop key
	sll	$t2, $t4, 2					# t4 * 4 (i*4)
	add	$t2, $t2, $t3					# adds it to colors array 
	lw	$t5, ($t2)					#loads value in t5 
	
	move	$a2,$t5						#moves t5 to a2 
	addi	$t0, $t0, 1					#increments t0 
	
	j	draw_pixel					#jumps to draw pixel


loopBottomRow: 							######### Bottom row of box #########
	addi	$t4, $t4, 1					#increments colors array index for next color 
	bge	$t4, 8, StartOver				#if t4 is greater than 8 jump to zero so it can reset back to first element in array 
	addi	$a0, $a0, -1					#decrements x value to add pixels from right to left 
	beq	$s7, 1, black_pixel				#if s7 = 1 then jump to loop key
	sll	$t2, $t4, 2					# t4 * 4 (i*4)
	add	$t2, $t2, $t3					# adds it to colors array 
	lw	$t5, ($t2)					#loads value in t5 
	
	move	$a2,$t5						#moves t5 to a2 
	addi	$t0, $t0, 1					#increments t0 
	
	j	draw_pixel					#jumps to draw pixel

loopRightColumn: 						######### Right column of box #########
	addi	$t4, $t4, 1					#increments colors array index for next color 
	bge	$t4, 8, StartOver				#if t4 is greater than 8 jump to zero so it can reset back to first element in array 
	addi	$a1, $a1, 1					#increments y value to add pixels from top to bottom
	beq	$s7, 1, black_pixel				#if s7 = 1 then jump to loop key
	sll	$t2, $t4, 2					# t4 * 4 (i*4)
	add	$t2, $t2, $t3					# adds it to colors array 
	lw	$t5, ($t2)					#loads value in t5 
	
	move	$a2,$t5						#moves t5 to a2 
	addi	$t0, $t0, 1					#increments t0 
	
	j	draw_pixel					#jumps to draw pixel


loopTopRow: 							######### Top row of box #########
	addi	$t4, $t4, 1					#increments colors array index for next color 
	bge	$t4, 8, StartOver				#if t4 is greater than 8 jump to zero so it can reset back to first element in array 
	addi	$a0, $a0, 1					#increments x value to add pixels from left to right
	beq	$s7, 1, black_pixel				#if s7 = 1 then jump to loop key
	sll	$t2, $t4, 2					# t4 * 4 (i*4)
	add	$t2, $t2, $t3					# adds it to colors array 
	lw	$t5, ($t2)					#loads value in t5 
	
	move	$a2,$t5						#moves t5 to a2 
	addi	$t0, $t0, 1					#increments t0 
	
	j	draw_pixel					#jumps to draw pixel
	
black_pixel: 							######### pixels of the box will turn balck #########						
	li	$a2, 0						#loads the pixel color as black 
	addi	$t0, $t0, 1					#incremnts t0 
	j	draw_pixel					#jumps to draw pixel 
	
	
draw_pixel: 							######### Function to draw pixels for the box #########
								#s1 = address = GP + 4*(x + y*width)
	mul	$s1, $a1, WIDTH   				# y * WIDTH	
	add	$s1, $s1, $a0	  				# add X
	mul	$s1, $s1, 4	  				# multiply by 4 to get word offset
	add	$s1, $s1, $gp					# add to base address
	sw	$a2, ($s1)					# store color at memory location
	
	move	$t8, $a0					#store value of a0 in temp register so value wont be lost
	j	pause
	
						
pause: 								####### pause function######
	li	$v0, 32						#syscall to create a delay 	
	li	$a0, 5						#pauses for 5 milli seconds
	syscall
	
	move	$a0, $t8					#restores original value back into a0
	jr 	$ra	
exit: 								######### Function only used when user enters space #########					
	li	$v0, 10
	syscall	
	
StartOver: 							######### Function reset array back to first element#########
	li	$t4, -1
	jr	$ra

loopKey: 							############ KEY BOARD FUNCTIONALITY ###############
	lw	$s2, 0xffff0004					#loads input in s2							
	li	$s7, 1						#check condition so it can enter the black pixel function 
	li	$t0, 0						# t0 = 0
	
	jal	loopTopRow					#jumps to loop top row
	bne	$t0, $t1, loopTopRow				#if t0 !=7 then jump to loop top row
	li	$t0, 0						#set t0 = 0 
	jal	loopRightColumn					#jumps to loop right column 
	bne	$t0, $t1, loopRightColumn			#if t0 !=7 then jump to loopright column
	li	$t0, 0						#sets t0 = 0
	jal	loopBottomRow					#jumps to loop bottom row
	bne	$t0, $t1, loopBottomRow				#if t0 !=7 then jump to loop bottom row
	li	$t0, 0						#sets t0 = 0
	jal	loopLeftColumn					#jumps to loop left column
	bne	$t0, $t1, loopLeftColumn			#if t0 !=7 then jump to loopleft column
	li	$s7, 9						#once the box is black it will set the condition to another value to skip the check condidtion for black pixel
	
	beq	$s2, 32, exit					# input space
	beq	$s2, 119, up 					# input w
	beq	$s2, 115, down 					# input s
	beq	$s2, 97, left  					# input a
	beq	$s2, 100, right					# input d

up:								#shits the box up 
	addi	$s4, $s4, -1					#the right two y values get decremented
	addi	$s6, $s6, -1					#the left two y values get decremented
	j	BIGLOOP						# jumps to bigloop 
	
down:								#shift the box down			
	addi	$s4, $s4, 1					#the right two y values get incremented
	addi	$s6, $s6, 1					#the left two y values get incremented
	j	BIGLOOP						#jumps to bigloop
	
left:								#shift the box left 
	addi	$s3, $s3, -1					#the right two x values get decremented
	addi	$s5, $s5, -1					#the left two x values get decremented
	j	BIGLOOP
right:								#shifts the box right 
	addi	$s3, $s3, 1					#the right two x values get incremented
	addi	$s5, $s5, 1					#the left two x values get incremented
	j	BIGLOOP						#jumps to bigloop
		









