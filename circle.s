
	AREA circle_construct, CODE, READONLY
	IMPORT get_sinecosine_func
	IMPORT printMsg2p
	EXPORT __main
	ENTRY


centre_x RN 4 ; x input
centre_y RN 5 ; y input
radius RN 6   ; input radius
resolution RN 7 
  
__main FUNCTION
	BL enable_fpu
	
	MOV centre_x, #1000
	MOV centre_y, #1000
	MOV radius, #10
	MOV resolution, #1				
	MOV R8, #360					; max degree to reach to make a circle
	MOV R9, #0						; current theta (in degrees)
	MOV R11, #5
	MOV R10 ,#0
	VLDR.F32 S17,=1.0
	VLDR.F32 S20,=5.0
Loop
	BL deg_to_rad					; subroutine to convert theta from degrees to radians
	BL get_sinecosine_func			
	
	;VMOV.F32 S20, radius
	VCVT.F32.U32 S20, S20				; converting from int to float
	VMUL.F32 S8, S8, S20				;  calculating r * sin(t)
	VMUL.F32 S9, S9, S20				;  calculating r * cos(t)
	
	VMOV.F32 S20, centre_x			; from centre_x
	VCVT.F32.U32 S20, S20				; converting from int to float
	VMOV.F32 S1, centre_y			;from centre_y
	VCVT.F32.U32 S1, S1
	VADD.F32 S20, S20, S9				; calculate  x = x_centre + r * cos(t)
	VADD.F32 S1, S1, S8				;  calculate y = y_centre + r * sin(t)
	
	VCVT.U32.F32 S20, S20				; converting from float to int
	VMOV.F32 R0, S20
	VCVT.U32.F32 S1, S1				; converting from float to int 
	VMOV.F32 R1, S1
	BL printMsg2p					; prints contents of R0 and R1 in debug viewer

	VADD.F32 S20, S20, S17
	ADD R9, R9, resolution
	CMP R9,R8						;for initializing angle to 0
	ITT EQ;
	MOVEQ R9,#0;
	ADDEQ R10, R10, #1

	CMP R10,R11 
	BLT Loop

stop B stop ; stop program
	
	
enable_fpu	

	LDR.W R0, =0xE000ED88 			; Using CPACR register (0xE000ED88) to specify access priviliges for coprocessors
	LDR R1, [R0]					; Read CPACR
	ORR R1, R1, #(0xF << 20)		; Set bits 20-23 to enable CP10 and CP11 coprocessors (Full access)
	STR R1, [R0]					; Write back the modified value to the CPACR
	
	BX LR

deg_to_rad

	VLDR.F32 S1, =3.14159265359		; value of pi is stored
	VLDR.F32 S2, =180
	VMOV.F32 S0, R9
	VCVT.F32.U32 S0, S0				; converting from int to float
	VMUL.F32 S0, S0, S1				
	VDIV.F32 S0, S0, S2				;  calculating x(radians) = (x(degrees) * pi / 180)
	
	BX LR
	
	ENDFUNC
	END 
	