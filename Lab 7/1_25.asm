bits 32
global start        
extern exit
extern printf
extern scanf
              
import exit msvcrt.dll  
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
    result dd 0
    format_a db 'a=',0
    format_b db 'b=',0
    format_for_read db '%d',0
    a dd 0
    b dd 0
    format_for_print db '%d %c %d',0
    relation dd '='
    
segment code use32 class=code
start:
    push dword format_a
    call [printf]
    add esp,4*1    ;it prints a=
    
    push dword a
    push dword format_for_read
    call [scanf]
    add esp, 4*2  ;reads the value of a
    
    push dword format_b
    call [printf]
    add esp,4*1    ;it prints b=
    
    push dword b
    push dword format_for_read
    call [scanf]
    add esp, 4*2  ;reads the value of b
    
    mov AX, [a]   ;we can not use with CMP 2 operands from the memory
    cmp AX, [b]
    jl less_than
    jg greater_than
    je print
    
    less_than:
        mov byte [relation], '<'
        jmp print
        
    greater_than:
        mov byte [relation], '>'
        jmp print
        
    print:
        push dword [b]
        push dword [relation]
        push dword [a]
        push dword format_for_print
        call [printf]
        add esp, 4*4
        
    push dword 0
    call [exit]
        