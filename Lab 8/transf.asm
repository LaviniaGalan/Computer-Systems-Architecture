bits 32

extern alphabet

segment code use32 class=code
    transf:
        mov EBX,0
        sub AL, 'a'
        add EBX, AL
        mov AL, [alphabet + EBX]
        
        
        
        
        