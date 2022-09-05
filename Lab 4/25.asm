;Given the doublewords M and N, compute the doubleword P as follows.
;the bits 0-6 of P are the same as the bits 10-16 of M
;the bits 7-20 of P are the same as the bits 7-20 of (M AND N).
;the bits 21-31 of P are the same as the bits 1-11 of N.
bits 32
global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    m DD 01110111010101010111011101010101b
    n DD 01110111010101011110001001001101b
    p DD 0
    
segment code use32 class=code
start:
    ;I will store the result into EBX
    mov EBX,0
    ;the bits 0-6 of P are the same as the bits 10-16 of M
    mov EAX,[m] ;placing the bits of M in the right position, then isolating them using the AND operator and the mask
    shr EAX,10
    and EAX,00007Fh
    or EBX,EAX  ;putting the result in EBX
    ;the bits 7-20 of P are the same as the bits 7-20 of (M AND N)
    mov EAX,[m] 
    and EAX,[n] ;calculating the result of (M AND N)
    and EAX,00000000000111111111111110000000b   ;isolating the bits of (M AND N)
    or EBX,EAX  ;putting the result in EBX
    ;the bits 21-31 of P are the same as the bits 1-11 of N
    mov EAX,[n]  
    shl EAX,20  ;placing the bits of N in the right place
    and EAX,11111111111000000000000000000000b  ;isolating them
    or EBX,EAX  ;putting the result in EBX
    
    mov [p],EBX
  push dword 0
  call [exit]