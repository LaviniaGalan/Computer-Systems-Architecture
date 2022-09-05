bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;inmultiri, impartiri cu semn 
;24.a-(7+x)/(b*b-c/d+2); a-doubleword; b,c,d-byte; x-qword
segment data use32 class=data
    a dd -200
    b db 10
    c db 12
    d db 15
    x dq 180
segment code use32 class=code
    start:
        mov AL,[b]    ;AL=b
        imul byte [b] ;AX=AL*b=b*b
        mov BX,AX     ;moving AX in BX to free the EAX register, for performing further conversions. Now BX=b*b.
        
        mov AL,[c]    ;AL=c
        cbw           ;converting AL to AX to perform the division. Now AX=c.
        idiv byte [d] ;AL=c/d and AH=c%d. We will use the quotient from AL for further computations.
        
        cbw           ;converting AL to AX for performing the substraction. AX=c/d
        sub BX,AX     ;BX=b*b-c/d
        add BX,2      ;BX=b*b-c/d+2
        mov AX,BX     ;moving BX in AX to convert it later to EAX. AX=b*b-c/d+2
        cwde          ;converting AX to EAX, preparing it for the division. EAX=b*b-c/d+2
        mov EBX,EAX   ;moving EAX in EBX to free the EAX register, for performing further conversions. EBX=b*b-c/d+2
        
        mov AL,7
        cbw           ;convert AL to AX and then to EAX, and then to EDX:EAX to perform the addition to x, which is a qword. AX=7
        cwde          ;EAX=7
        cdq           ;EDX:EAX=7
        
        add EAX, dword [x]
        adc EDX, dword [x+4]   ;EDX:EAX=7+x
        
        idiv EBX      ;EAX=EDX:EAX / EBX = (7+x)/(b*b-c/d+2)
        
        mov EBX, [a]
        sub EBX, EAX  ;EBX=a-(7+x)/(b*b-c/d+2)
        mov EAX,EBX   ;EAX=a-(7+x)/(b*b-c/d+2)
        
    push dword 0
    call [exit]        
        
        
        