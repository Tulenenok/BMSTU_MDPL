PUBLIC print_bin_number
PUBLIC print_oct_number
PUBLIC print_hex_number

PUBLIC print_help_bin

PUBLIC print_all

EXTERN count_digits_bin : byte
EXTERN max_digits_bin : byte
EXTERN bin_num : byte

EXTERN count_digits_oct : byte
EXTERN max_digits_oct : byte
EXTERN oct_num : byte

EXTERN hex_sign : byte
EXTERN count_digits_hex : byte
EXTERN max_digits_hex : byte
EXTERN hex_num : byte

EXTERN mess_result : byte
EXTERN mess_print_hex : byte
EXTERN mess_print_oct : byte
EXTERN mess_print_bin : byte
EXTERN mess_print_hex_failure : byte
EXTERN mess_print_oct_failure : byte
EXTERN mess_print_bin_failure : byte
EXTERN arr_16 : byte

EXTERN was_input_bin : byte
EXTERN was_convert_oct : byte
EXTERN was_convert_hex : byte

CODESEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CODESEG

error_print_bin:
    mov ah, 9
    lea dx, DS:mess_print_bin_failure
    int 21h

    ret

error_print_oct:
    mov ah, 9
    lea dx, DS:mess_print_oct_failure
    int 21h

    jmp show_hex

error_print_hex:
    mov ah, 9
    lea dx, DS:mess_print_hex_failure
    int 21h
    ret

print_all:
    cmp DS:was_input_bin, 1
    jne error_print_bin

    call print_bin_number

    mov ah, 9
    lea dx, DS:mess_result
    int 21h

    cmp DS:was_convert_oct, 1
    jne error_print_oct

    call print_oct_number

    show_hex:
    cmp DS:was_convert_hex, 1
    jne error_print_hex

    call print_hex_number

    ret

print_bin_number:
    mov ah, 9
    lea dx, DS:mess_print_bin
    int 21h

    mov si, 0
    mov ch, DS:max_digits_bin

    mov ah, 2
    print_while:
        cmp ch, 0
        je print_exit
    
        dec ch

        print_one_digit:
            mov dl, DS:bin_num[si]
            inc si

            cmp dl, '?'
            je print_exit
            ;je p_o

            add dl, 30h 
            p_o:
            int 21h
            jmp print_while

    print_exit:
        ret

print_oct_number:
    mov ah, 9
    lea dx, DS:mess_print_oct
    int 21h

    mov si, 0
    mov ch, DS:max_digits_oct

    mov ah, 2
    mov al, 0             ; Флаг, равен 0, пока идут ведующие нули
    print_while_o:
        cmp ch, 0
        je print_exit_o
    
        dec ch

        print_one_digit_o:
            mov dl, DS:oct_num[si]
            inc si

            cmp dl, 0
            jne not_null

            cmp al, 0            ; Обрабока случая ведущих нулей
            je print_while_o

            not_null:
                mov al, 1
                add dl, 30h 
                int 21h
            jmp print_while_o

    print_exit_o:
        cmp al, 0
        jne ex

        mov dl, '0'               ; Обработка нуля
        int 21h

        ex:
            ret

; Проверка, является ли число нулем (чтобы в этом случае не выводить знак)
is_hex_not_null:
    mov al, 0                   ; Флаг, что число является нулем
    mov si, 0
    mov ch, DS:max_digits_hex

    is_hex_null_while:
        cmp ch, 0
        je is_hex_null_exit
    
        dec ch

        mov dl, DS:hex_num[si]
        inc si

        cmp dl, 0
        je is_hex_null_while

        mov al, 1
        ret

    is_hex_null_exit:
        ret

print_hex_null:
    mov ah, 2
    mov dl, '0'
    int 21h

    ret

print_hex_number:
    mov ah, 9
    lea dx, DS:mess_print_hex
    int 21h

    call is_hex_not_null
    cmp al, 0                  ; Число является нулем
    je print_hex_null

    mov ah, 2
    mov dl, DS:hex_sign
    int 21h

    mov si, 0
    mov ch, DS:max_digits_hex

    mov al, 0                    ; Флаг для ведущих нулей
    print_while_h:
        cmp ch, 0
        je print_exit_h
    
        dec ch

        print_one_digit_h:
            mov dl, DS:hex_num[si]
            inc si

            cmp dl, 0
            jne not_null_h

            cmp al, 0            ; Обрабока случая ведущих нулей
            je print_while_h

            not_null_h:
                mov al, 1
                add dl, 30h 
                int 21h

            jmp print_while_h

    print_exit_h:
        ret

print_help_bin:
    mov ah, 9
    lea dx, DS:mess_print_bin
    int 21h

    mov si, 0
    mov ch, DS:max_digits_bin

    mov ah, 2
    print_while_help:
        cmp ch, 0
        je print_exit_help
    
        dec ch

        print_one_digit_help:
            mov dl, DS:arr_16[si]
            inc si

            cmp dl, '?'
            ;je print_exit_h
            je p_h

            add dl, 30h 
            p_h:
            int 21h
            jmp print_while_help

    print_exit_help:
        ret

CODESEG ENDS
END