org 100h
     
mov bl, 0   ; X = 0
mov bh, 2   ; Y = 0
mov al, 'r' ; DIR_X = right
mov ah, 'd' ; DIR_Y = down
           
jmp Main:                 

Spc: db ' ', 0
           
Print: 
    push ax

    mov ah, 0eh
    
    ._loop:
        lodsb
        cmp al, 0
        je .done
        int 10h
        jmp ._loop
        
    .done: 
        pop ax
    
        ret
        
PrintNL: 
    push ax

    MOV dl, 10
    MOV ah, 02h
    INT 21h
    MOV dl, 13
    MOV ah, 02h
    INT 21h
    
    pop ax
    
    ret 
    
Cls:   
    push ax

    mov ax, 3
    int 10h
    
    pop ax
             
    ret
    
Moving:    
    cmp al, 'r'
    je .MoveRight
._GBFR:
    cmp al, 'l'
    je .MoveLeft
._GBFL:    
    cmp ah, 'u'
    je .MoveUp
._GBFU:     
    cmp ah, 'd'
    je .MoveDown
._GBFD:            
    ret

    .MoveRight:      
        push cx
        mov cl, 1h
        add bl, cl
        pop cx
        jmp ._GBFR
        
    .MoveLeft:
        push cx        
        mov cl, 1h
        sub bl, cl
        pop cx
        jmp ._GBFL
       
    .MoveDown:
        push cx   
        mov cl, 1h
        add bh, cl
        pop cx
        jmp ._GBFD
        
    .MoveUp:
        push cx
        mov cl, 1h
        sub bh, cl
        pop cx
        jmp ._GBFU
    
ChangeDir:
    cmp bl, 0 ; If has hit the left side of the screen.
    je .MakeRight
.GBFR:    
    cmp bl, 10 ; If has hit the right side of the screen
    je .MakeLeft
.GBFL:    
    cmp bh, 0 ; If has hit the top of the screen
    je .MakeDown
.GBFD:    
    cmp bh, 10 ; If has hit the bottom of the screen
    je .MakeUp  
.FIN:    
    ret
    
    .MakeRight:
        mov al, 'r'  
        jmp .GBFR
        
    .MakeLeft:
        mov al, 'l'
        jmp .GBFL
        
    .MakeUp:
        mov ah, 'u'
        jmp .FIN
        
    .MakeDown:
        mov ah, 'd'
        jmp .GBFD
    
; DIR_X = al
; DIR_Y = ah

; X = bl
; Y = bh

; I = cx
    
Char: db 'ASM', 0    
    
        
Main: 
    call ChangeDir
    call Moving
    call Cls 
    
    mov ch, bh ; I = Y
    jmp .PrintY
.CBFPY:    
    mov ch, bl ; I = X
    jmp .PrintX
.CBFPX:           
    mov si, Char
    call Print
       
    ; Loop:
    jmp Main  
    
    .PrintY:  
        cmp ch, 0
        je .CBFPY
    
        call PrintNL 
        push dx
        mov dh, 1h
        sub ch, dh
        pop dx
        
        cmp ch, 0 
        ; Loop:
        jne .PrintY 
        
        jmp .CBFPY
        
    .PrintX:     
        cmp ch, 0
        je .CBFPX
    
        mov si, Spc
        call Print
        push dx
        mov dh, 1h
        sub ch, dh
        pop dx
        
        cmp ch, 0
        ; Loop:
        jne .PrintX 
        
        jmp .CBFPX