bits 32 
global start        
extern exit               
import exit msvcrt.dll    
;3*[20*(b-a+2)-10*c]+2*(d-3)
segment data use32 class=data
    a db 7
    b db 9
    c db 2
    d dw 8
;3*[20*(9-7+2)-10*2]+2*(8-3)=3*(20*4-20)+2*5=190    
segment code use32 class=code
    start:
        mov AL,[b] ;AL=b/ b=byte, so we use AL register which has 8 bits
        sub AL,[a] ;AL=b-a
        add AL, 2  ;AL=(b-a+2)
        mov CL,20  ;move 20 in CL to do the multiplication by AL// AL->8 bits so 20 has to be stored in a 8 bits register (CL)
        mul CL     ;AX=AL*20=20*(b-a+2)
        mov BX,AX  ;free AX register so we can do the multiplication 10*c //BX=20*(b-a+2)
        mov AL,10  ;AL=10
        mul byte [c]    ;AX=10*c
        sub BX,AX  ;BX=BX-AX=[20*(b-a+2)-10*c]
        mov AX,BX  ;move BX in AX to do the multiplication by 3
        mov CX,3   ;move 3 in CX to do the multiplication by BX// BX-16 bits so 3 has to be stored in a 16 bits register (CX)
        mul CX     ;DX:AX=AX*3=3*[20*(b-a+2)-10*c]
        push DX    ;punem pe stiva DX
        push AX    ;punem pe stiva AX
        pop EBX    ;extragem de pe stiva AX(plasat la final), DX(plasat in fata)// EBX=DX:AX=3*[20*(b-a+2)-10*c]
        mov AX,[d] ;move d in AX to do the multiplication by 2 (d=word, so we use AX)
        sub AX,3   ;AX=AX-3=d-3
        mov CX,2   ;move 2 in CX to do the multiplication by AX// AX->16 bits so 2 has to be stored in a 16 bits register (CX)
        mul CX     ;DX:AX=AX*2=2*(d-3)
        push DX    ;punem pe stiva DX
        push AX    ;punem pe stiva AX
        pop EAX    ;extragem de pe stiva AX(plasat la final), DX(plasat in fata)// EAX=DX:AX=2*(d-3)
        ADD EAX,EBX ;do the final sum; EAX=EAX+EBX=3*[20*(b-a+2)-10*c]+2*(d-3)
        
        push    dword 0      
        call    [exit]      
