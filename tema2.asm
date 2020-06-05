%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0
        str_task1 db "revient", 0
        str_task2 db "C'est un proverbe francais." ,0
section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text
global main

;=======================================Task1===========================================

bruteforce_singlebyte_xor:
mov edi, 0          ;cheie pentru xor =[0..256] 
loop_xor_Matrix:   
    mov eax, [img_width]
    ;Fac xor pe imagine pentru fiecare cheie
    call bruteforce_xor
    inc edi
    cmp edi, 256
    jne loop_xor_Matrix
ret
leave

bruteforce_xor:
xor edx, edx    ; indice linie
                ; parcurg matricea
for_line:
    xor ecx, ecx ; indice coloana
    xor esi, esi ; indice pentru str_task1
for_culomn:
        push edx  
        
        imul eax, edx                        
        add eax, ecx                                           
        mov eax, [ebx+4*eax]   ; elementul eax din matrice 

        xor eax, edi           ; fac xor pe elementele matricei
        
        movzx edx, byte[str_task1 + esi] ; pun in edx cate o litera din str_task1
        inc esi

        cmp eax, edx           ; verific cuvantul str_task1 daca se afla
                               ; pe linia din matrice
        je continue                    
        xor esi, esi     
continue:
        pop edx
        cmp esi, 7              ; conditie in caz ca am gasit str_task1
        je exit2
        inc ecx
        
        mov eax, [img_width]    ; reinoiesc registrul eax 
        cmp ecx, [img_width]    ; conditia de a trece pe urmatoarea coloana
        jne for_culomn                  
    inc edx
    cmp edx, [img_height]       ; conditia de a trece pe urmatoarea linie
    jne for_line
exit1:
ret
leave
exit2:
mov esi, edi    ; pastrez cheia gasita in esi
mov edi, 255    ; pun in edi ultima cheie 
jmp exit1       ; iesire din functie

print:  
;afisez linia in care am gasit str_task1
for:
    imul eax, edx
    add eax, ecx
    
    mov eax, [ebx+4*eax]
    
    xor eax, edi
    cmp eax, 0      ;conditie daca am gasit terminatorul de sir
    je next
    PRINT_CHAR eax  ;Printez caracter cu caracter
    mov eax, [img_width]
    inc ecx
    cmp ecx, [img_width] 
    jne for
next:
    NEWLINE
    PRINT_DEC 4, edi    ;Printez cheia folosita 
    NEWLINE
    PRINT_DEC 4, edx    ;Printez linia pe care am gasit str_task1
    NEWLINE
    jmp done
ret
leave

;=======================================Task2===========================================

xor_Matrix:
xor edx, edx    ; indice linie
xor_line:   
    xor ecx, ecx ; indice coloana
xor_column:
        imul eax, edx
        add eax, ecx
        xor [ebx+4*eax], edi ; modific elementul din matrice cu 
                             ; noul element xorat
        mov eax, [img_width] ; actualizez registrul eax
        inc ecx
        cmp ecx, [img_width] ; conditie pentru urmatoarea coloana
        jne xor_column
    inc edx
    cmp edx, [img_height]   ; conditie pentru urmatoarea linie
    jne xor_line
ret
leave

new_massage:
 ; iau byte cu byte din str_task2 si le introduc pe 
 ; linia matricei ebx=[img]
    movzx edi, byte[str_task2 + ecx]

    imul eax, edx
    add eax, ecx
    mov [ebx+4*eax], edi
   
    mov eax, [img_width]
    inc ecx
    cmp ecx, 28     ; conditie de oprire
    jne new_massage
ret
leave

; Aplic formula: key = floor((2 * old_key + 3) / 5) - 4    
new_key:
    imul esi, 2
    add esi, 3
    mov eax, esi
    cdq
    mov ecx, 5
    idiv ecx
    sub eax, 4
ret
leave

;=======================================Task3===========================================

morse_encrypt:
xor ecx, ecx        ; indicele pentru mesaj
codify_byte:
    movzx edi, byte[esi + ecx]  ; parcurg mesajul byte by byte
    cmp edi, 0x00   ; conditie pentru iesire
    je end
    cmp ecx, 0x00   
    je next1
    mov byte[edx+4*eax], " "    ;adaug spatii
    inc eax
next1:    
    inc ecx
    jmp cod_A       ; parcurg fiecare litera
end:
mov dword[edx+4*eax], 0x00  ;terminatorul de 
jmp exit_morse_encrypt
; Trec prin fiecare caracter si il criptez in code morse
; in acelasi timp introduc fiecare caracter morse in matricea edx=[img]
cod_A:
    cmp edi, "A"
    jne cod_B
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_B:
    cmp edi, "B"
    jne cod_C
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_C:
    cmp edi, "C"
    jne cod_D
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_D:
    cmp edi, "D"
    jne cod_E
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_E:
    cmp edi, "E"
    jne cod_F
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_F:
    cmp edi, "F"
    jne cod_G
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_G:
    cmp edi, "G"
    jne cod_H
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_H:
    cmp edi, "H"
    jne cod_I
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_I:
    cmp edi, "I"
    jne cod_J
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_J:
    cmp edi, "J"
    jne cod_K
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_K:
    cmp edi, "K"
    jne cod_L
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_L:
    cmp edi, "L"
    jne cod_M
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_M:
    cmp edi, "M"
    jne cod_N
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_N:
    cmp edi, "N"
    jne cod_O
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_O:
    cmp edi, "O"
    jne cod_P
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_P:
    cmp edi, "P"
    jne cod_Q
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_Q:
    cmp edi, "Q"
    jne cod_R
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_R:
    cmp edi, "R"
    jne cod_S
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_S:
    cmp edi, "S"
    jne cod_T
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_T:
    cmp edi, "T"
    jne cod_U
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_U:
    cmp edi, "U"
    jne cod_V
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_V:
    cmp edi, "V"
    jne cod_W
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_W:
    cmp edi, "W"
    jne cod_X
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_X:
    cmp edi, "X"
    jne cod_Y
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_Y:
    cmp edi, "Y"
    jne cod_Z
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_Z:
    cmp edi, "Z"
    jne cod_1
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_1:
    cmp edi, "1"
    jne cod_2
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_2:
    cmp edi, "2"
    jne cod_3
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_3:
    cmp edi, "3"
    jne cod_4
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_4:
    cmp edi, "4"
    jne cod_5
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_5:
    cmp edi, "5"
    jne cod_6
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_6:
    cmp edi, "6"
    jne cod_7
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_7:
    cmp edi, "7"
    jne cod_8
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_8:
    cmp edi, "8"
    jne cod_9
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_9:
    cmp edi, "9"
    jne cod_0
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    jmp codify_byte
cod_0:
    cmp edi, "0"
    jne cod_comma
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
cod_comma:
    cmp edi, ","
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "."
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    mov byte[edx+4*eax], "-"
    inc eax
    jmp codify_byte
exit_morse_encrypt: 
ret
leave

;=======================================Task4===========================================

lsb_encode:
    movzx edi, byte[esi + ecx] ; parcurg fiecare litera din mesaj
    inc ecx
    push ecx
    mov ecx, 128       ; indice pentru fiecare bit
    
in_binar:
    push edi           
    and edi, ecx       ; verific fiecare bit din edi
    cmp edi,0x00       ; conditie de verificare bit
    je bit_0           
bit_1:
    pop edi
    push esi        
    mov esi, 1          
    and esi, dword[edx+4*eax] ;pastrez lsb al elementului matrice
    cmp esi, 1  ;conditie de modificare bit 
    je cont
    xor dword[edx+4*eax], 1 ;daca era 0 devine 1
cont:
    pop esi
    inc eax
    shr ecx, 1  ;shiftez la dreapta cu un bit
    cmp ecx, 0  ;conditie de iesire din functie
    jne in_binar
    pop ecx
    jmp if_end
bit_0:
    pop edi
    push esi
    mov esi, 1
    and esi, dword[edx+4*eax]  ; iau lsb din elementul matricei
    xor dword[edx+4*eax], esi  ; si daca era = 1 devine = 0 
    pop esi
    inc eax
    shr ecx, 1 ; siftez reprezentarea pe biti cu 1 la dreapta
    cmp ecx, 0
    jne in_binar
    pop ecx
if_end:
    cmp edi, 0x00    ; conditie pentru terminatorul de sir
    je exit_encode
    jmp lsb_encode
exit_encode:
ret
leave

;=======================================Task5===========================================

lsb_decode:
    mov esi, 1
    and esi, dword[edx+4*eax] ;accesez lsb fiecare element al [img]
    inc eax
    or ebx, esi     ; Stochez in ebx fiecare bit gasit         
    inc ecx         ; Indice biti gasiti
    cmp ecx, 8      ; Am gasit 8 biti
    je continu
    shl ebx, 1      ; Shiftez la stanga cu 1
    jmp lsb_decode
    
continu:
    cmp ebx, 0      ; Conditie de iesire
    je exit_decode
    PRINT_CHAR ebx  ; Printez fiecare octet gasit
    xor ecx, ecx
    xor ebx, ebx
    jmp lsb_decode  ; Caut urmatorul octet
exit_decode:
ret
leave

;=======================================Task6===========================================

blur:
mov edx, 1 ; Indice Linie
blur_line:
    mov ecx, 1 ; Indice coloana
blur_column:
        push edx
        imul eax, edx
        add eax, ecx
        mov eax, [ebx+4*eax] ; Elementul la care ma aflu
        push eax             ; Il stochez pe stiva
        
        mov eax, [img_width]
        dec edx
        imul eax, edx
        inc edx
        add eax, ecx
        mov eax, [ebx+4*eax] ; Vecinul cu o linie mai sus 
        push eax             ; Il stochez pe stiva
        
        mov eax, [img_width]
        inc edx
        imul eax, edx
        dec edx
        add eax, ecx
        mov eax, [ebx+4*eax] ; Vecinul cu o linie mai jos 
        push eax             ; Il stochez pe stiva
        
        mov eax, [img_width]
        imul eax, edx
        add eax, ecx
        mov eax, [ebx+4*eax+4] ; Vecinul cu o coloana la dreapta
        push eax               ; Il stochez pe stiva
        
        mov eax, [img_width]
        imul eax, edx
        add eax, ecx
        mov eax, [ebx+4*eax-4] ; Vecinul cu o coloana la stanga
        
        ; Fac media aritmetica dintre Elementul de pe pozitia
        ; la care ma aflu cu toti vecinii lui 
        mov edx, eax
        pop eax
        add edx, eax
        pop eax
        add edx, eax
        pop eax
        add edx, eax
        pop eax
        add eax, edx
        push ebx
        cdq
        mov ebx, 5
        idiv ebx
        pop ebx             ; Stochez pe stiva toate elementele noi calculate

        pop edx
        push eax
        inc ecx
        mov eax, [img_width]
        mov esi, [img_width] 
        dec esi             ; Pentru a merge pana la penultima coloana
        cmp ecx, esi
        jne blur_column
        
    inc edx
    mov esi, [img_height]
    dec esi                 ; Pentru a merge pana la penultima linie
    cmp edx, esi
    jne blur_line
    
mov edx, [img_height]
dec edx
dec edx                     ; Indice linie

; Modific toate elementele necesare
change_blur_line:
    mov ecx, [img_width] 
    dec ecx
    dec ecx                 ; Indice coloana
change_blur_column:
        imul eax, edx
        add eax, ecx
        pop esi            ; Extrag de pe stiva cate un element calculat anterior
        mov dword[ebx+4*eax], esi ; Modific matricea [img]
        
        dec ecx
        mov eax, [img_width]
        cmp ecx, 0             
        jne change_blur_column
    dec edx
    cmp edx, 0
    jne change_blur_line
ret
leave


    
    
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax
    
    call get_image_height
    mov [img_height], eax
    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax
  
    ;There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
    ;TODO Task1
    
    mov ebx, [img]  
    
    ;Functia care face xor pe imagine pana nu
    ;gaseste o cheie favorabila in intervalul [0..256]
    call bruteforce_singlebyte_xor

    
    mov eax, [img_width]
    mov edi, esi
    xor ecx, ecx
    ;Afisez mesajul gasit,
    ;linia si cheia cu care am gasit mesajul
    call print
    
    jmp done
    
solve_task2:
    ; TODO Task2
    
    mov ebx, [img]
    ;aflu linia si cheia cu care trebuie xorata matricea
    call bruteforce_singlebyte_xor
    
    push edx    ;linia pe care am gasit str_task1
     
    mov ebx, [img]
    mov eax, [img_width]
    mov edi, esi
    ;xorez matricea
    call xor_Matrix
    
    pop edx
    mov eax, [img_width]
    xor edi, edi
    xor ecx, ecx
    inc edx
    ;introduc noul mesaj in matrice
    call new_massage
    
    mov edi, edx
    ;calculez noua cheie 
    call new_key
    
    mov edi, eax
    xor edx, edx
    mov eax, [img_width]
    ;xorez matricea cu noua cheie
    call xor_Matrix
    
    mov eax, [img_height]
    mov ecx, [img_width]
    push eax
    push ecx
    push ebx
    ;afisez imaginea
    call print_image
    
    jmp done
solve_task3:
    ; TODO Task3
    
    ;argv[3] = mesaj
    mov esi, [ebp + 12]
    mov esi, dword[esi+12]
    ;argv[4] = indice din matrice
    mov eax, [ebp + 12]
    mov eax, dword[eax+16]
    push eax
    
    call atoi
    mov edx, [img]
    ; criptez mesajul primit prin argv[3]
    call morse_encrypt
    
    mov eax, [img_height]
    mov ecx, [img_width]
    push eax
    push ecx
    push edx
    ; printez imaginea
    call print_image
    
    jmp done
    
solve_task4:
    ; TODO Task4
    
    ; argv[3] = mesaj
    mov esi, [ebp + 12]
    mov esi, dword[esi+12]
    
    ; argv[4] = indice din matrice
    mov eax, [ebp + 12]
    mov eax, dword[eax+16]
    push eax
    call atoi
    
    mov edx, [img]
    dec eax
    ; codificarea pe bitul cel mai nesemnificativ
    call lsb_encode

    mov eax, [img_height]
    mov ecx, [img_width]
    push eax
    push ecx
    push edx
    ; printare imagine
    call print_image
    jmp done
solve_task5:
    ; TODO Task5
    
    ;argv[3] = indice din matrice
    mov eax, [ebp + 12]
    mov eax, dword[eax+12]
    push eax
    call atoi

    dec eax
    mov edx, [img]
    xor ecx, ecx
    xor ebx, ebx
    ; Decriptarea si afisarea mesajului criptat
    ; din imaginea data 
    call lsb_decode
    
    jmp done
solve_task6:
    ; TODO Task6 
    
    mov eax, [img_width]
    mov ebx, [img]
    xor edi, edi
    ; Blurez imaginea [img]
    call blur
    
    mov eax, [img_height]
    mov ecx, [img_width]
    push eax
    push ecx
    push ebx
    ; Printez imaginea blurata
    call print_image
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    
