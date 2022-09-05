bits 32
global start
extern exit
extern printf
extern scanf
extern transf 

import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

global alphabet

segment data use32 class=data
    alphabet db 'OPQRSTUVWXYZABCDEFGHIJKLMN'
    s1 times 256 db 0
    s2 times 256 db 0
    read_format db 'the string: %s',0
    print_format db '%s',0
    
segment code use32 class=code
start:
    push dword read_format
    call [printf]
    add esp,4*1    ;it prints "the string:"
    
    push dword s1
    push dword read_format
    call [scanf]
    add esp, 4*2   ;it read the string
    
    mov ESI,s1
    mov EDI,s2
    cld
    
    repeat:
        lodsb      ;AL = a character from s1, ESI++
        cmp AL,0
        je next
        call transf    ;I will pass the parameters using the AL register
        stosb      ;AL = the new character and will be put in s2, EDI++
        jmp repeat
        
    next:
        push dword s2
        push dword print_format
        call [printf]
        add esp, 4*2
        
    push dword 0
    call exit
        