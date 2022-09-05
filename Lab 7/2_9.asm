bits 32
global start        
extern exit
extern fopen
extern fread
extern fclose
extern printf
              
import exit msvcrt.dll  
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll 
import printf msvcrt.dll

segment data use32 class=data
    file_name db "input.txt", 0   
    acces_mode db "r", 0      
    handle dd -1    
    len equ 100    
    sir resb len
    nr_read_char db 0
    list_of_frequency times 25 db 0
    max_freq dd 0
    letter_max_freq dd 0
    format_for_print dd '%c with frequency %d',0
segment code use32 class=code
start:  
        ;open the file:
        push dword acces_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        ;check if the open was successful:
        mov [handle],EAX
        cmp EAX,0
        je the_end
        
        repeat:
            ; read 100 characters from the text from the file
            ; eax = fread(sir, 1, len, handle)
            push dword [handle]
            push dword len
            push dword 1
            push dword sir
            call [fread]
            add esp, 4*4
            ;eax = the number of read characters
            cmp eax, 0          ;if the number of read characters = 0, then we have read the whole file
            je close_file
            mov [nr_read_char], EAX
            mov ECX,0
        
            freq:
                mov ESI,sir
                mov CL,[nr_read_char]
                repeat1:
                    lodsb       ;AL = a character from sir    ;ESI = ESI+1
                    cmp AL, 'A'
                    jb final  ;if the character is below 'A', we move to the next character
                    cmp AL, 'Z' 
                    ja final  ;if the character is above 'Z', we move to the next character
                    mov EBX,0
                    mov BL, AL
                    sub BL, 65  ;we obtain in BL the position of AL in string of characters
                    add byte [list_of_frequency+EBX], 1
                    final:
                       loop repeat1
            
            jmp repeat
            
        close_file:
            push dword [handle]
            call [fclose]
            add esp, 4
            
        mov ECX,26
        mov EDX,0     ;in DL i will store the higher frequency. now i will store the frequency of A and then i will compare it with other frequencies  
        mov ESI, 0
        repeat2:  
            cmp byte [list_of_frequency+ESI], DL       
            jb endd                              ;if the current frequency is below the max frecquency, move to the next element
            mov DL, byte [list_of_frequency+ESI]
            mov EBX,ESI
            add EBX, 65
            endd:
                add ESI,1
                loop repeat2
        
        mov dword [max_freq], EDX
        mov dword [letter_max_freq], EBX
        
        push dword [max_freq]
        push dword [letter_max_freq]
        push dword format_for_print
        call [printf]
        add ESP, 4*3
            
        the_end:
            push dword 0
            call [exit]
        
            
            
            
            