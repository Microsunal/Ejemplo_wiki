;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            
;
; export symbols
;
            XDEF _Startup
            ABSENTRY _Startup

;
; variable/data section
;
            ORG    RAMStart         ; Insert your data definition here
ExampleVar: DS.B   1

;
; code section
;
            ORG    ROMStart
            

_Startup:
            LDHX   #RAMEnd+1        ; initialize the stack pointer
            TXS
            CLI			; enable interrupts
 ;;;;;;;;;Config_GPIO;;;;;;;;;;,
			lda		#$00
			sta		PTADD
			;lda	#$FF
			;sta 	PTAPE
			
			lda		#$FF
			sta		PTBDD
			lda 	#$04
			sta		PTBD
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
			lda 	#$02 ;carga 02 al acumulador 
            sta 	SOPT1 ;almacena el dato en memoria para desactivar el watchdog
;;;;;;;;;;config pwm;;;;;;;;;;;;;

			lda 	#$c3
			sta		TPMMODH
			lda		#$50
			sta		TPMMODL
			lda		#$00
			sta		TPMC0SC
			lda		#$04
			sta		TPMC1SC
			lda		#$13		
			sta		TPMC1VH
			lda		#$e8
			sta	    TPMC1VL      
			lda 	#$2b
			sta     TPMSC   
    
;PTB5 salida pwm
;PTB1 led rojo
;PTB2 led verde
;PTA0 entrada objeto			

mainLoop:
            ; Insert your code here
            
            lda 	PTAD
           	sta		$0060
            lda 	PTBD 
            and		#%00100000
            cbeqa	#%00000000, leer
            jmp 	end
leer:       lda		$0060
            and		#%00000001
            cbeqa	#%00000001, led_verde
            lda 	PTBD
            and		#%11110000
            ora		#$02
            sta		PTBD
         	jmp 	retardo        
led_verde:	
 
			lda 	PTBD
            and		#%11110000
            ora		#$04
            sta		PTBD
            jmp		retardo
            			            
end:        feed_watchdog
            BRA    mainLoop
			
retardo:	
			

			
			jmp end
			
;**************************************************************
;* spurious - Spurious Interrupt Service Routine.             *
;*             (unwanted interrupt)                           *
;**************************************************************

spurious:				; placed here so that security value
			NOP			; does not change all the time.
			RTI

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************

            ORG	$FFFA

			DC.W  spurious			;
			DC.W  spurious			; SWI
			DC.W  _Startup			; Reset
