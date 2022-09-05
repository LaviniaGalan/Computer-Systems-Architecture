bits 32
global start        
extern exit
extern fopen
extern fclose
extern fprintf
              
import exit msvcrt.dll 
import fopen msvcrt.dll 
import fclose msvcrt.dll 
import fprintf msvcrt.dll

segment data use32 class=data
    file_name db 'output.txt',0
    acces_mode db 'w', 0
    handle dd -1
    text db 'aaAAA123ab4asc8 =w9^^0',0
    len equ $-text
    
segment code use32 class=code
start:
        ; we modify the text:
        mov ESI,  text
        mov ECX, len
        repeat:
                lodsb ;AL= a character from text; ESI++
                cmp AL,'0'
                jb next_elem
                cmp AL, '9'
                ja next_elem   ; if the character isn t a digit, we move te the next element
                sub ESI,1
                mov byte [ESI], 'C'
                add ESI,1
                next_elem:
                    loop repeat
        
        ; first, we create the file
        ; eax = fopen(file_name, acces_mode)
        push dword acces_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2   
        
        ;check if the file was created successfully:
        mov [handle], EAX
        cmp EAX, 0
        je the_end
        
        ;write the text in the file:
        push dword text
        push dword [handle]
        call [fprintf]
        add esp, 4*2
        
        ;close the file:
        push dword [handle]
        call [fclose]
        add esp, 4
        
        the_end:
        push dword 0
        call [exit]
    