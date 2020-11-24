
	AREA sinecosine_func, CODE, READONLY
	EXPORT get_sinecosine_func
	ENTRY

get_sinecosine_func FUNCTION
	
	VLDR.F32 S0, =2				    ; input
	VLDR.F32 S1, =1					; current loop counter
	VLDR.F32 S2, =23				; maximum loop counter value
	VMOV.F32 S3, S0					; we start with 'x' and  multiply this by 'x' at every loop 
	VLDR.F32 S4, =1					; factorial starts with '1'; as we go on with the subsequent terms, we compute the factorial by multiplying this with my current term index
	VLDR.F32 S5, =1					; sign toggle bit
	VMOV.F32 S8, S0					; sin(x) starting term
	VLDR.F32 S9, =1					; cos(x) starting term
	VLDR.F32 S10, =1				; constant to increment the counter
	VLDR.F32 S11, =1				; factorial counter

LOOP

    VADD.F32 S11, S11, S10			; updating factorial counter
	VNEG.F32 S5, S5					; toggle sign bit
	VMUL.F32 S3, S3, S0				; updating s3 to get next value of 'x'
	VMUL.F32 S4, S4, S11			; updating s4 to get next factorial term 
	VDIV.F32 S7, S3, S4				
	VMUL.F32 S7, S7, S5				; incremental cos(x) term
	VADD.F32 S9, S9, S7				; final cos(x) term
	
	VADD.F32 S11, S11, S10			; updating factorial counter
	
	VMUL.F32 S3, S3, S0				; updating s3 to get next value of 'x'
	VMUL.F32 S4, S4, S11			; updating s4 to get the next factorial term
	VDIV.F32 S6, S3, S4				
	VMUL.F32 S6, S6, S5				; incremental sin(x) term
	VADD.F32 S8, S8, S6				; updating final sin(x) term
	
	VADD.F32 S1, S1, S10 			; update current loop counter
	
	VCMP.F32 S1, S2					; exit condition
	VMRS APSR_nzcv, FPSCR			
	BNE LOOP						
	BX LR
	
	ENDFUNC
	END 