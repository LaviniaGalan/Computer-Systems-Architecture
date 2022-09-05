bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;unsigned multiplications, divisions
;24.a-(7+x)/(b*b-c/d+2); a-doubleword; b,c,d-byte; x-qword
segment data use32 class=data
    a dd 200
    b db 10
    c db 12
    d db 15
    x dq 180
segment code use32 class=code
    start:
        mov AL,[b]   ;AL=b
        mul byte [b] ;AX=AL*b=b*b
        mov BX,AX    ;moving AX in BX to free the EAX register, for performing further division. BX=b*b 
        
        mov AL,[c]   ;AL=c
        mov AH,0     ;converting AL to AX. AX=c
        div byte [d] ;AL=c/d and AH=c%d. We use only the quotient (AX) for futher computations.
        
        mov AH,0     ;converting AL to AX. AX=c/d 
        sub BX,AX    ;BX=b*b-c/d
        add BX,2     ;BX=b*b-c/d+2
        
        mov EDX, 0   ;moving 7 in EDX:EAX so that we can add it to x, which is a qword
        mov EAX, 7   ;EDX:EAX=7
        add EAX, dword [x]     
        adc EDX, dword [x+4]   ;EDX:EAX=7+x
        
        push 0
        push BX      ;converting BX to EBX to perform the division.
        pop EBX      ;EBX=b*b-c/d+2
        
        div EBX      ;EAX=EDX:EAX / EBX = (7+x)/(b*b-c/d+2)
        
        mov EBX, [a]
        sub EBX, EAX  ;EBX=a-(7+x)/(b*b-c/d+2)
        mov EAX,EBX   ;EAX=a-(7+x)/(b*b-c/d+2)
        
    push dword 0
    call [exit]
        
        