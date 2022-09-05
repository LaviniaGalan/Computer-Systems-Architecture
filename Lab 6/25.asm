;A string of bytes is given. Obtain the mirror image of the binary representation of this string of bytes.
bits 32
global start
extern exit
import exit msvcrt.dll
segment data use32 class=data
     s DB 01011100b, 10001001b, 11100101b 
     len equ $-s
     d times len DB 0
     two DB 2
     counter2 DB 0
     
segment code use 32 class=code
start:  
        mov ESI,s
        mov EDI,d+len-1
        mov ECX,len
        repeat:
            cld
            mov [counter2],ECX ;pt a nu se pierde valoarea
            mov AH,0
            lodsb       ;AL=the current element in s
            mov ECX,8
            mov BX,0    ;in EBX i will store the quotients obtained in the division by 2
            mov DL,0    ;in DL i will store the palindrome of every byte from s
            repeat_2:
                div byte [two]   ;AH=the remainder, AL=the quotient. we will need the quotient further
                mov BL,AL
                sub CL,1
                shl AH,CL
                add CL,1
                or  DL,AH
                mov AX,BX
                loop repeat_2
            mov AL,DL
            std
            stosb 
            mov ECX,[counter2]
            loop repeat
            
        push dword 0
        call [exit]
            
                
            
push dword 0
call [exit]
        