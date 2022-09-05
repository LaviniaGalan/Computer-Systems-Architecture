bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;signed addition, substraction; a - byte, b - word, c - double word, d - qword 
;9.a-d+b+b+c
segment data use32 class=data
    a db 10
    b dw 20
    c dd 1030
    d dq 1230
segment code use32 class=code
    start:
        mov AL,[a]    ;AL=a
        cbw           ;converting AL to AX. Now AX=a and we will convert it again for performing the substraction a-d, where d is a qword.
        cwde          ;converting AX to EAX.
        cdq           ;converting EAX to EDX:EAX. Now EDX:EAX=a.
        
        sub EAX, dword [d]
        sbb EDX, dword [d+4]   ;EDX:EAX=a-d
        
        mov ECX,EDX   ;moving EDX:EAX in ECX:EBX to free the EAX register, so that we can do other conversions.
        mov EBX,EAX   ;ECX:EBX=a-d 
        
        mov AX, [b]   ;AX=b
        cwde          ;converting AX to EAX. Now EAX=b.
        mov EDX,EAX   ;EDX=b.
        add EAX,EDX   ;EAX=EAX+EDX=b+b.
        add EAX,[c]   ;EAX=b+b+c.
        
        mov EDX,0
        add EAX,EBX
        adc EDX,ECX   ;EDX:EAX=EDX:EAX+ECX:EBX=a-d+b+b+c.
        
    push dword 0
    call [exit]
        
        
     
        
        
        
        