bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;signed multiplication, division; a,b-byte; c-word; e-doubleword; x-qword
;9.(a-b+c*128)/(a+b)+e-x;
segment data use32 class=data
    a db 20
    b db 10
    c dw 1030
    e dd -123
    x dq 1230
segment code use32 class=code
    start:
        mov AX, [c]    ;AX=c
        mov DX, 128    ;moving 128 in DX for multiplying it by c.
        imul DX        ;DX:AX=c*128
        mov CX,DX  
        mov BX,AX      ;moving DX:AX to CX:BX to free the EAX register, so that we can do other conversions. CX:BX=c*128
        
        mov AL, [a]   ;AL=a
        sub AL, [b]   ;AL=a-b
        cbw           ;converting AL to AX. AX=a-b
        cwd           ;converting AX to DX:AX so that we can perform later the division. Now DX:AX=a-b.
        
        add DX,CX     ;adding CX:BX to DX:AX.
        adc AX,BX     ;DX:AX=a-b+c*128
    
        mov BL,[a]    ;BL=a
        add BL,[b]    ;BL=a+b
        cbw           ;converting BL to BX. BX=a+b 
        idiv BX       ;AX=DX:AX /BX = (a-b+c*128)/(a+b)
                      ;DX=DX:AX %BX
                      ;the quotient of the division is in AX and the remainder in DX, but we only use the quotient in the further computations.
        
        cwde          ;converting AX to EDX to perform the addition to e which is a dword.
        add EAX,[e]   ;EAX=(a-b+c*128)/(a+b)+e 
        
        cdq           ;converting EAX to EDX:EAX so we can perform the last substraction, where x is a qword.
        
        sub EAX, dword[x]
        sbb EDX, dword[x+4]   ;EDX:EAX=(a-b+c*128)/(a+b)+e-x
        
        
    push dword 0
    call [exit]