bits 32
global start
extern exit
import exit msvcrt.dll

;A byte string S of length l is given. Obtain the string D of length l-1 so that the elements of D represent the difference between every two consecutive elements of S.

segment data use32 class=data
    s DB 1, 2, 4, 6, 10, 20, 25
    len equ $-s
    d times (len-1) DB 0
    
segment code use32 class=code
    start:
        mov ESI,0     ;ESI=the index of the first byte in strings s and d
        repeat:
            mov AL,[s+ESI]      ;AL=s[ESI]
            mov BL,[s+ESI+1]    
            sub BL,AL           ;obtaining the difference between two consecutive elements of string s
            mov [d+ESI],BL      ;d[ESI]=BL
            add ESI,1           ;moving to the next index in strings s and d
            cmp ESI,len-1       ;if ESI<len-1 jump to repeat, else continue below
            jb repeat
    push dword 0
    call [exit]