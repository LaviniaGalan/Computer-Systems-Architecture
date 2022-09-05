bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;unsigned multiplication, division; a,b-byte; c-word; e-doubleword; x-qword
;9.(a-b+c*128)/(a+b)+e-x;
segment data use32 class=data
    a db 20
    b db 10
    c dw 1030
    e dd 123
    x dq 1230
segment code use32 class=code
    start:
        mov BL, [a]   ;AL=a
        sub BL, [b]   ;BL=a-b
        
        mov AX, [c]   ;AX=c
        mov DX, 128   ;DX=128
        mul DX        ;DX:AX=c*128
        
        mov BH, 0     ;converting BL to BX. Now BX=a-b.
        mov CX, 0     ;converting BX to CX:BX so that we can perform the addition a-b+c*128.
        
        add AX, BX    ;adding BX:CX to DX:AX.
        adc DX, CX    ;DX:AX=DX:AX + BX:CX = a-b + c*128
        
        mov BL,[a]    ;BL=a
        add BL,[b]    ;BL=a+b
        mov BH,0      ;converting BL to BX. Now BX=a+b. 
        div BX        ;AX=DX:AX /BX = (a-b+c*128)/(a+b)
                      ;DX=DX:AX %BX
                      ;the quotient of the division is in AX and the remainder in DX, but we only use the quotient in the further computations.
        push 0
        push AX
        pop EAX       ;converting AX to EAX to perform the addition. Now EAX=(a-b+c*128)/(a+b).
        
        add EAX,[e]   ;EAX=(a-b+c*128)/(a+b)+e 
        
        mov EDX,0     ;converting EAX to EDX:EAX to perform the final substraction.
        sub EAX, dword[x]
        sbb EDX, dword[x+4]  ;EDX:EAX=(a-b+c*128)/(a+b)+e-x
        
        
    push dword 0
    call [exit]
        
        
        
        
        