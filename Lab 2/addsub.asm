bits 32 
global start        
extern exit               
import exit msvcrt.dll    
; (d+d-b)+(c-a)+d
segment data use32 class=data
    a db 5
    b db 6
    c db 30
    d db 3
;(3+3-6)+(30-5)+3=0+25+3=8

segment code use32 class=code
    start:
        mov AL,[d] ;AL=d/ d=byte, so we use AL register which has 8 bits
        add AL,[d] ;AL=AL+d=d+d
        sub AL,[b] ;AL=AL-b=(d+d-b)
        mov BL,[c] ;BL=c (c is a byte so we use BL register which has 8 bits)
        sub BL,[a] ;BL=BL-a=c-a
        add AL,BL  ;AL=AL+BL=(d+d-b)+(c-a)
        add AL,[d] ;AL=AL+d=(d+d-b)+(c-a)+d
        
        push    dword 0      
        call    [exit]      
