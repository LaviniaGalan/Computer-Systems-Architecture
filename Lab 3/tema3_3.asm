bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;signed addition, substraction; a - byte, b - word, c - double word, d - qword 
;24.(a + b + c) - d + (b - c)
segment data use32 class=data
    a db 10
    b dw 20
    c dd 1030
    d dq 60
segment code use32 class=code
    start:
        mov AL, [a]  
        cbw          ;converting AL to AX. Now AX=a and we can perform the addition a+b, with b=word.
        add AX,[b]   ;AX=a+b
        cwde         ;converting AX to EAX. Now EAX=a+b and we can perform the addition a+b+c, where c is a dword.
        add EAX,[c]  ;EAX=a+b+c
        cdq          ;converting EAX to EDX:EAX (qword), so we can perform the substraction with the qword d. Now EDX:EAX=a+b+c.
        
        sub EAX, dword [d]
        sbb EDX, dword [d+4] ;EDX:EAX=(a+b+c)-d
        
        mov ECX,EDX     ;we move EDX:EAX to ECX:EBX, to free the EAX register, for performing other signed converstions.
        mov EBX,EAX     ;ECX:EBX=(a+b+c)-d
        
        mov AX,[b]      ;AX=b
        cwde            ;converting AX to EAX. EAX=b and we can perform the substraction b-c, where c is a dword.
        sub EAX,[c]     ;EAX=EAX-c=b-c
        
        cdq             ;converting EAX to EDX:EAX, for performing the final addition. Now EDX:EAX=b-c.
        
        add EAX,EBX  
        adc EDX,ECX     ;EDX:EAX=(a + b + c) - d + (b - c)
        
    push dword 0
    call [exit]
        