;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : lc4_stdio.asm                          ;
;  author      : 
;  description : LC4 Assembly subroutines that call     ;
;                call the TRAPs in os.asm (the wrappers);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; WRAPPER SUBROUTINES FOLLOW ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
.CODE
.ADDR x0010    ;; this code should be loaded after line 10
               ;; this is done to preserve "USER_START"
               ;; subroutine that calls "main()"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_PUTC Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_putc
;; PROLOGUE ;;
; CIT 593 TODO: write prologue code here
STR R7, R6, #-2      ;store return addr
STR R5, R6, #-3      ;store FP
ADD R6, R6, #-3      ;update pointer
ADD R5, R6, #0       ;update FP

;; FUNCTION BODY ;;
		; CIT 593 TODO: write code to get arguments to the trap from the stack
		;  and copy them to the register file for the TRAP call
LDR R0, R5, #3  ;load char to r0	
TRAP x01        ; R0 must be set before TRAP_PUTC is called
	
;; EPILOGUE ;; 
		; TRAP_PUTC has no return value, so nothing to copy back to stack
ADD R6, R5, #0    ;pop variable
ADD R6, R6, #3    ;decrease stack
LDR R5, R6, #-3   ;load pointer
LDR R7, R6, #-2   ;load R7
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_GETC Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_getc

	;; PROLOGUE ;;
        ; CIT 593 TODO: write prologue code here
STR R7, R6, #-2   ; store return addr
STR R5, R6, #-3   ;store FP
ADD R6, R6, #-3   ;update pointer
ADD R5, R6, #0    ;update FP
ADD R6, R6, #-1   ;allocate space
CONST R7, #0      ;
STR R7, R5, #-1   ;NULL
		
	;; FUNCTION BODY ;;
		; CIT 593 TODO: TRAP_GETC doesn't require arguments!
		
	TRAP x00        ; Call's TRAP_GETC 
                    ; R0 will contain ascii character from keyboard
                    ; you must copy this back to the stack
    STR R0, R5, #-1 
    
	;; EPILOGUE ;; 
		; TRAP_GETC has a return value, so make certain to copy it back to stack
        LDR R7, R5, #-1      ;load c 
        ADD R6, R5, #0       ;pop local val
        STR R7, R6, #-1      ;syore return value
        LDR R5, R6, #-3      ;load pointer
        LDR R7, R6, #-2      ;load R7
	RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_PUTS Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_puts

;;PROLOGUE
STR R7, R6, #02    ;store return addr
ADD R6, R6, #-2    ;update pointer
STR R5, R6, #-2    ;store FP
ADD R5, R6, #0     ;update FP

;;BODY
LDR R0, R5, #3     ;load addr
TRAP x03           ; call TRAP

;;EPILOGUE
ADD R6, R5, #0     ;pop local value
ADD R6, R6, #3     ;decrease
LDR R5, R6, #-2    ;load pointer
LDR R7, R6, #-2    ;load R7 

RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;   TRAP_DRAW_RECT  ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_draw_rect

;;PROLOGUE
CONST R0, x00
HICONST R0, x20    ;set low byte & high byte
STR R7, R6, #-2    ;store return addr
STR R5, R6, #-3    ;store FP
ADD R6, R6, #-3    ;update pointer
ADD R5, R6, #0     ;update FP
STR R5, R0, #0     ;STORE r5
STR R6, R0, #1

;;BODY
LDR R0, R5, #3     ;load R0
LDR R1, R5, #4
LDR R2, R5, #5
LDR R3, R5, #6
LDR R4, R5, #7
TRAP x9            ;call TRAP_DRAW_RECT
STR R5, R0, #0     ;load R5 back
STR R6, R0, #1     ;load R6 back

;;EPILOGUE
ADD R6, R5, #0     ;pop local val
ADD R6, R6, #3     ;DECREASE
LDR R5, R6, #-3  
LDR R7, R6, #-2    ; load R7

RET
