;A list of doublewords is given. Starting from the low part of the doubleword, obtain the doubleword made of the high even bytes of the low words of each 
;doubleword from the given list. If there are not enough bytes, the remaining bytes of the doubleword will be filled with the byte FFh.

bits 32
global start
extern exit
import exit msvcrt.dll
segment data use32 class=data
     s DD 12345678h, 1A2C3C4Dh, 98FCDD76h, 12783A2Bh
     len equ ($-s)/4
     d DD 0
     two DB 2
     four DB 4
     
segment code use 32 class=code
start:  
        mov ESI,s
        mov EDI,d
        mov ECX,len
        cld
        repeat:
            lodsd      ;EAX=the current element in s // ESI=ESI+1
            mov AL,AH  ;AL=high part of the low part of the element
            mov BL,AL  ;pt a nu pierde rezultatul
            mov AH,0   ;AX=AL
            div byte [two]   ;verifying if AX is even (dividing it by 2). the remainder is in AH
            cmp AH,0         ;if the remainder is not zero, we move to the next element in s
            jne not_even
            ;if the number is even, we have to put it in d:
            mov AL,BL
            stosb            
            cmp EDI,d+4
            je the_end
            not_even:
                loop repeat  ; if ecx>0 (there are more elements in s), then resume the loop.
        ;if there aren't enough bytes:
        mov EDX,EDI
        sub EDX,d
        cmp EDX,4
        je the_end
        
        sub [four],EDX
        mov ECX,[four]
        repeat_F:
            mov AX, 00FFh  ;AL=FFh
            stosb
            loop repeat_F
        
        the_end:
        push dword 0
        call [exit]
         