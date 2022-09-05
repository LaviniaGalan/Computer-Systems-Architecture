bits 32 
global start        
extern exit               
import exit msvcrt.dll   
;unsigned addition, substraction; a - byte, b - word, c - double word, d - qword 
;24.((a + b) + (a + c) + (b + c)) - d
segment data use32 class=data
    a db 10
    b dw 20
    c dd 1030
    d dq 1230
segment code use32 class=code
    start:
        mov AL, [a]
        mov AH, 0     ;converting a to word, so that we can perform a+b, where b is a word. Now AX=a and we move a in BX to be able to convert a again for the next operation.
        mov BX, AX    ;BX=AX=a. 
        add BX,[b]    ;BX=a+b
        
        push 0
        push AX       ;converting a to dword, so that we can perform a+c, where c is a dword.
        pop EAX       ;EAX=a (doubleword)
        add EAX,[c]   ;EAX=a+c
        
        push 0
        push BX       ;converting a+b from word to dword, so we can add it to (a+c) which is a dword.
        pop EBX       ;EBX=a+b
        
        add EAX,EBX   ;EAX=(a+b)+(a+c)
        
        mov BX,[b]
        push 0
        push BX       ;converting b to dword, so that we can perform b+c, where c is a dword.
        pop EBX       ;EBX=b (dword)
        add EBX,[c]   ;EBX=b+c
        
        add EAX,EBX   ;EAX=(a+b)+(a+c)+(b+c)
        
        mov EDX,0     
        sub EAX, dword [d]
        sbb EDX, dword [d+4] ;EDX:EAX=(a+b)+(a+c)+(b+c)-d
       
    push dword 0
    call [exit]