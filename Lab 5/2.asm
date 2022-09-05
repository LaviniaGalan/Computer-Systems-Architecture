bits 32
global start
extern exit
import exit msvcrt.dll

;Two character strings S1 and S2 are given. Obtain the string D which contains all the elements of S1 that do not appear in S2.

segment data use32 class=data
    s1 DB '+', '4', '2', 'a', '8', '4', 'X', '5'
    s2 DB 'a', '4', '5'
    len1 equ $-s1
    len2 equ $-s2
    d times (len1) DB 0
    
segment code use32 class=code
    start:
        mov ESI,0
        mov EDI,0
        mov ECX,len1
        repeat:
        
            mov AL,[s1+ESI]         ;take the element of s1 whose index is equal to ESI
            mov EDX,0
            repeat1:
                cmp AL,[s2+EDX]      ;compare the actual element of s1 with each of the elements of s2   
                je next_element          ;if they are equal, then we move to the next element in s1 (*)
            
            if_not_equal:
                add EDX,1            ;if they are not equal, there are 2 possibilities: 1)if the number to compare with is the last in s2, then
                cmp EDX,len2         ; we have to add the current element of s1 in d. 2)if not, then we have to compare the current element 
                jb repeat1           ;with the next element of s2.
                je add_valid_element
                
            add_valid_element:
                mov [d+EDI],AL       ;adding a valid element to d, the string of the result
                add EDI,1
                
            next_element:
                add ESI,1            ;move to the next element of s1 (*)
                sub ECX,1
                cmp ECX,0
                ja repeat
                
    push dword 0
    call [exit]
        
                
                
                