.model small

.data
mes db '   Sum$'
mes2 db 13,10,13,10, '   Sub$'
mes3 db 13,10,13,10, '   Mul$'
mes4 db 13,10,13,10, '   Div$'
mes5 db 13,10,13,10, '   Exit$'

str1 db 'Enter first number : $'
str2 db 13,10,'Enter second number : $'
mes_sum db 13,10,'The Sum: $'
mes_sub db 13,10,'The Sub: $'
mes_MUL db 13,10,'The Mul: $'
mes_div db 13,10,'The Div: $'

back db 13,10,13,10,'Press any key to return$'

num1 db 0 
num2 db 0
rem db 0
n db 10


len db 0
ar db 1,2,3,4,5
.code
start:

    mov ax,@data
    mov ds,ax

    mov bl, 0
    
    main:
    
    call check
   
    mov ah,0
    int 16h
    
    cmp al,13
    je perform_op
    
    cmp ah,72
    je dec_ar
   
    cmp ah,80
    je inc_ar

    jmp main
    

    inc_ar:
    cmp si,5
    je  ar_rest
    
    inc si
    call check
    jmp main
        
    dec_ar:
    cmp si,0
    je main
    
    dec si
    call check
    
    jmp main
    
    perform_op: 
    
    cmp ar[si],1
    jne o2
    call SUM_NUM
    jmp main
  
    o2:cmp ar[si],2
    jne o3
    call SUB_NUM
    jmp main
       
    o3:cmp ar[si],3
    jne o4
    call Mul_NUM
    jmp main
       
    o4:cmp ar[si],4
    jne o5
    call Div_NUM
    jmp main
        
    o5:cmp ar[si],5
    
    jne main
    je to_end
     
     
    ar_rest:
    mov si,-1
    jmp inc_ar
    
    to_end:
    call clear_screen

    int 27h
  
    ;-------------------PROCEDURE--------------------------;
    check proc
    call clear_screen
    
    cmp ar[si],1
    jne l2
   
    call h_sum
    call draw_menu
    ret
    
    l2:cmp ar[si],2
    jne l3
   
    call h_sub
    call draw_menu
    ret
    
    l3:cmp ar[si],3
    jne l4
    
    call h_mul
    call draw_menu
    ret
    
    l4:cmp ar[si],4
    jne l5
    
    call h_div
    call draw_menu
    ret
    
    l5:cmp ar[si],5
    call h_exit
    call draw_menu
    ret
    endp check
 
   
    
     ;-------------------------------------
    clear_screen proc
   
    ; Set pixel color to black
     mov al, 0
     mov ah, 0ch
     mov cx, 0
     mov dx, 0

     clear_loop:
     int 10h
     inc dx
     cmp dx, 100
     je next_line
     jmp clear_loop

     next_line:
     inc cx
     mov dx, 0
     cmp cx, 100
     jne clear_loop

    ret
    clear_screen endp
    
    
    h_sum proc
    
     mov len,9
     mov dx,1
     call shap
    
    ret
    endp h_sum 
    
    h_sub proc
    
    mov len,14
    mov dx,11
     call shap
    
    ret
    endp h_sub 
    
    h_mul proc
    
    mov len,15
    mov dx,26
     call shap
    
    ret
    endp h_mul
    
    h_div proc
    
    mov len,19
    mov dx,41
     call shap
    
    ret
    endp h_div
    
    h_exit proc
    
    mov len,15
    mov dx,61
     call shap
    
    ret
    endp h_exit
  
    shap proc
    mov ax, 13h
    int 10h
    mov ah, 0ch
    
    mov al,9
    mov bh,len
    i:
    call line_row
    inc dx
    dec bh
    jnz i
    ret
    endp shap

    draw_menu proc
     ;int 10h
    mov al,9
    mov ah, 0ch
    
     mov al ,50
     
    call line_col
    
    mov dx,10
    call line_row
    
    lea dx,mes
    call print_string
    
    mov dx,25
    call line_row
    
    lea dx,mes2
    call print_string
    
    mov dx,40
    call line_row
    
    lea dx,mes3
    call print_string
    
    mov dx,60
    call line_row
    
    lea dx,mes4
    call print_string
    
    mov dx,75
    call line_row
    
    lea dx,mes5
    call print_string
    ret
    endp draw_menu
    
  
    line_row proc
    
     mov cx,0
     mov ah, 0ch
   
    r:
    int 10h
    inc cx
    cmp cx,80
    jne r
    ret
    endp  line_row
    
    
    line_col proc
    mov dx,0
    mov cx,80
    mov ah, 0ch
    
    l:
    int 10h
    inc dx
    cmp dx,75
    jne l
    ret
    endp line_col
    
  
    print_string proc
    
    mov ah, 09h
    int 21h
    ret
    endp print_string
    
    
    ;---------------OP---------------;
    
    
clear_screen2 proc
  
    ; Clear the screen
    mov ah, 06h    ; Scroll up function
    mov al, 0      ; Clear entire screen
    mov bh, 07h    ; Attribute for blank (black background, white text)
    mov cx, 0      ; Upper left corner (row=0, column=0)
    mov dx, 184fh  ; Lower right corner (row=24, column=79)
    int 10h
    
    ; Move cursor to the default position (top-left corner)
    mov ah, 02h    
    mov bh, 00h    
    mov dh, 00h    
    mov dl, 00h    
    int 10h
    
    mov ax,0
    mov bx,0
    
    ret
clear_screen2 endp


background proc

mov ah, 06h     
xor al, al    
xor cx, cx      
mov dx, 184fh    
mov bh, 3h   ; Set desired background color

int 10h          
ret
endp background



SUM_NUM proc

mov ax, 0003h   ; 03h is the mode for 80x25 text
    int 10h

mov dx,offset str1
mov ah,09h
int 21h

mov ah,01
int 21h


CMP al,'-'
JE SUM_INP

sub al,48
mov num1,al


SUM_VAL:
mov dx,offset str2
mov ah,09h
int 21h

mov ah,01
int 21h

CMP al,'-'
JE SUM_defn

sub al,48
mov num2,al
jmp SUM_RUN


SUM_INP:
mov ah,01
int 21h
sub al,48
neg al
mov num1,al
jmp SUM_VAL



SUM_defn:
mov ah,01
int 21h
sub al,48
neg al
mov num2,al


SUM_RUN:

mov al,num1
add al,num2

mov dx,offset mes_sum
    mov ah,09h
    int 21h
    
    
    CMP al,0
    jge SUM_p
    
    mov bl, al
    neg bl
    mov ah, 02
    mov dl, '-'
    int 21h
    
    mov al, bl
      

    SUM_p:
mov ah,0
div n
mov num1,al
mov num2,ah

cmp al,0
je sk

mov ah,02
mov dl,num1
add dl,48
int 21h

sk:
mov ah,02
mov dl,num2
add dl,48
int 21h

mov ah,09
mov dl,offset back
int 21h

mov ax,0
int 16h

call clear_screen2
ret
endp SUM_NUM




SUB_NUM proc

mov ax, 0003h   ; 03h is the mode for 80x25 text
    int 10h

mov dx,offset str1
mov ah,09h
int 21h

mov ah,01
int 21h


CMP al,'-'
JE SUB_INP

sub al,48
mov num1,al


SUB_VAL:
mov dx,offset str2
mov ah,09h
int 21h

mov ah,01
int 21h

CMP al,'-'
JE SUB_defn

sub al,48
mov num2,al
jmp SUB_RUN


SUB_INP:
mov ah,01
int 21h
sub al,48
neg al
mov num1,al
jmp SUB_VAL



SUB_defn:
mov ah,01
int 21h
sub al,48
neg al
mov num2,al


SUB_RUN:

mov al,num1
sub al,num2

mov dx,offset mes_sub
    mov ah,09h
    int 21h
    
    
    CMP al,0
    jge SUB_p
    
    mov bl, al
    neg bl
    mov ah, 02
    mov dl, '-'
    int 21h
    
    mov al, bl
      

    SUB_p:
mov ah,0
div n
mov num1,al
mov num2,ah


cmp al,0
je sk1

mov ah,02
mov dl,num1
add dl,48
int 21h

sk1:
mov ah,02
mov dl,num2
add dl,48
int 21h

mov ah,09
mov dl,offset back
int 21h

mov ax,0
int 16h

call clear_screen2
ret


ret
endp SUB_NUM



MUL_NUM proc
mov ax, 0003h   ; 03h is the mode for 80x25 text
    int 10h
    
mov dx,offset str1
mov ah,09h
int 21h

mov ah,01
int 21h


CMP al,'-'
JE MUL_INP

sub al,48
mov num1,al


MUL_VAL:
mov dx,offset str2
mov ah,09h
int 21h

mov ah,01
int 21h

CMP al,'-'
JE MUL_defn

sub al,48
mov num2,al
jmp MUL_RUN


MUL_INP:
mov ah,01
int 21h
sub al,48
neg al
mov num1,al
jmp MUL_VAL



MUL_defn:
mov ah,01
int 21h
sub al,48
neg al
mov num2,al


MUL_RUN:

mov al,num1
mul num2

mov dx,offset mes_mul
    mov ah,09h
    int 21h
    
    
    CMP al,0
    jge MUL_p
    
    mov bl, al
    neg bl
    mov ah, 02
    mov dl, '-'
    int 21h
    
    mov al, bl
      

    MUL_p:
mov ah,0
div n
mov num1,al
mov num2,ah


cmp al,0
je sk2

mov ah,02
mov dl,num1
add dl,48
int 21h

sk2:
mov ah,02
mov dl,num2
add dl,48
int 21h

mov ah,09
mov dl,offset back
int 21h

mov ax,0
int 16h

call clear_screen2
ret
endp MUL_NUM



DIV_NUM proc
mov ax, 0003h   ; 03h is the mode for 80x25 text
    int 10h
    
mov dx,offset str1
mov ah,09h
int 21h

mov ah,01
int 21h


CMP al,'-'
JE DIV_INP

sub al,48
mov num1,al


DIV_VAL:


mov dx,offset str2
mov ah,09h
int 21h

mov ah,01
int 21h

CMP al,'-'
JE DIV_defn

sub al,48
mov num2,al
jmp DIV_RUN


DIV_INP:
mov ah,01
int 21h
sub al,48
neg al
mov num1,al
jmp DIV_VAL



DIV_defn:
mov ah,01
int 21h
sub al,48
neg al
mov num2,al


DIV_RUN:

mov al, num1
mov bl, num2
xor ah, ah     
div bl         


mov rem, ah


mov dx, offset mes_div
mov ah, 09h
int 21h


add al, 48
mov dl, al
mov ah, 02h
int 21h
cmp rem,0
je endd


mov bh,'.'
mov dl,bh
mov ah, 02h
int 21h
    

mov al, rem
mul n

div bl     
add al, 48
mov dl, al
mov ah, 02h
int 21h

endd:

mov ah,09
mov dl,offset back
int 21h

mov ax,0
int 16h

call clear_screen2     
ret

endp DIV_NUM
    
end start