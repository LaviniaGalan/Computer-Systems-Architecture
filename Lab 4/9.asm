;Given the word A and the byte B, compute the doubleword C as follows:
;the bits 0-3 of C are the same as the bits 6-9 of A
;the bits 4-5 of C have the value 1
;the bits 6-7 of C are the same as the bits 1-2 of B
;the bits 8-23 of C are the same as the bits of A
;the bits 24-31 of C are the same as the bits of B
bits 32
global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    a DW 0111011101010101b
    b DB 01001101b
    c DD 0
    
segment code use32 class=code
start:
        ;I will store the result in DX:BX.
        mov BX, 0
        mov DX, 0
        ;the bits 0-3 of C = the bits 6-9 of A
        mov AX, [a]  ;placing the bits of A in the right position, then isolating them using the AND operator and the mask
        shr AX, 6
        and AX, 0000000000001111b
        or BX,AX    ;putting the bits into result
        ;the bits 4-5 of C = 11
        mov AX, 0000000000110000b
        or BX,AX    ;putting the bits into result
        ;the bits 6-7 of C = the bits 1-2 of B
        mov AL,[b]  ;placing the bits of B in the right position and then isolating them
        shl AL,5
        and AL,11000000b
        mov AH,0
        or BX,AX    ;putting the bits into result
        ;the bits 8-23 of C are the same as the bits of A. I will complete first the bits 8-15, corresponding to the bits of BX. Then, the bits 16-23 of C will be the bits 0-7 of DX.
        ;the bits 8-15 of C = 0-7 of A
        mov AX,[a]  
        shl AX,8
        and AX,1111111100000000b
        or BX,AX
        ;the bits 16-23 of C = 8-15 of A (16-23 of C means 0-7 of DX)
        mov AX,[a]
        shr AX,8
        and AX,0000000011111111b
        or DX,AX
        ;the bits 24-31 of C = the bits 0-7 of B (24-31 of C means 8-15 of DX)
        mov AH,[b]
        mov AL,0
        or DX,AX
        push DX
        push BX
        pop EAX
        mov [c],EAX
    push dword 0
    call [exit]
    
    