bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;unsigned addition, substraction; a - byte, b - word, c - double word, d - qword 
;9.(d+d-b)+(c-a)+d
segment data use32 class=data
    a db 10
    b dw 20
    c dd 30
    d dq 1230
segment code use32 class=code
    start:
        mov EAX, dword [d]
        mov EDX, dword [d+4]  ;EDX:EAX=d
        add EAX, dword [d]
        adc EDX, dword [d+4]  ;EDX:EAX=d+d
        
        mov BX, [b]
        push 0                ;convert b to qword so that we can perform the substraction d+d-b, where d is a qword
        push BX
        pop EBX
        mov ECX,0             ;ECX:EBX=b
        
        sub EAX,EBX
        sbb EDX,ECX           ;EDX:EAX=d+d-b
        
        mov EBX,[c]           ;EBX=c
        
        mov CL,[a]
        mov CH,0              ;convert a to word, then to dword (so that we can perform the substraction c-a, where c is dword). Now CX=a
        push 0
        push CX
        pop ECX               ;ECX=a
        
        sub EBX,ECX           ;EBX=c-a
        
        mov ECX,0             ;set the value of ECX to 0, so that we can perform the addition of d+d-b which is in EDX:EAX to c-a which will be in ECX:EBX
        add EAX,EBX
        adc EDX,ECX           ;EDX:EAX=(d+d-b) + (c-a)
        
        add EAX, dword [d]
        adc EDX, dword [d+4]  ;EDX:EAX=(d+d-b) + (c-a) + d
        
    push dword 0
    call [exit]
    