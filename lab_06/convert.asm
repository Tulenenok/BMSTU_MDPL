; Перевод числа из з2 в бз8 и з16

PUBLIC convert_bin_oct
PUBLIC convert_bin_hex

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

EXTERN arr_16 : byte
EXTERN arr_5 : byte
EXTERN arr_3 : byte
EXTERN tb : byte

EXTERN was_input_bin : byte
EXTERN was_convert_oct : byte
EXTERN was_convert_hex : byte

EXTERN mess_convert_success: byte
EXTERN mess_convert_failure : byte

CODESEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CODESEG

error_convert:
    mov ah, 9
    lea dx, DS:mess_convert_failure
    int 21h

    ret

null_array:
    mov si, 0
    mov ch, DS:max_digits_bin

    null_while:
        mov DS:arr_16[si], 0
        inc si
        dec ch
        cmp ch, 0
        jne null_while

    ret

shift_bin_digits_to_end:
    call null_array

    mov si, 0
    mov al, DS:bin_num[si]      ; Оставили знаковый байт как есть
    mov arr_16[si], al

    find_tail:
        inc si
        cmp bin_num[si], '?'
        jne find_tail

    mov al, DS:max_digits_bin
    mov ah, 0
    mov di, ax

    shift_copy:
        dec si
        dec di

        cmp si, 0
        je shift_exit

        mov al, DS:bin_num[si]
        mov DS:arr_16[di], al

        jmp shift_copy

    shift_exit:
        ret

; Конвертрует число из трех разрядов в десятичное представление
help_convert_b_o:
    mov bl, 0

    mov al, 4
    mul DS:arr_16[si]
    add bl, al

    inc si

    mov al, 2
    mul DS:arr_16[si]
    add bl, al

    inc si

    add bl, DS:arr_16[si]

    inc si

    ret

; Конвертрует число из четырех разрядов в десятичное представление
help_convert_b_h:
    mov bl, 0

    mov al, 8
    mul DS:arr_16[si]
    add bl, al

    inc si

    mov al, 4
    mul DS:arr_16[si]
    add bl, al

    inc si

    mov al, 2
    mul DS:arr_16[si]
    add bl, al

    inc si

    add bl, DS:arr_16[si]

    inc si

    ret

hex_number_to_char:
    cmp bl, 10
    je c_A

    cmp bl, 11
    je c_B

    cmp bl, 12
    je c_C

    cmp bl, 13
    je c_D

    cmp bl, 14
    je c_E

    cmp bl, 15
    je c_F

    jmp c_exit

    c_A:
        mov bl, 'A'
        sub bl, 30h
        jmp c_exit

    c_B:
        mov bl, 'B'
        sub bl, 30h
        jmp c_exit

    c_C:
        mov bl, 'C'
        sub bl, 30h
        jmp c_exit

    c_D:
        mov bl, 'D'
        sub bl, 30h
        jmp c_exit

    c_F:
        mov bl, 'F'
        sub bl, 30h
        jmp c_exit

    c_E:
        mov bl, 'E'
        sub bl, 30h
        jmp c_exit

    c_exit:
        ret


convert_bin_oct:
    cmp was_input_bin, 1
    jne error_convert

    call shift_bin_digits_to_end

    mov si, 1
    mov di, 0
    convert_while:
        call help_convert_b_o

        mov DS:oct_num[di], bl
        inc di

        cmp si, 16
        jne convert_while

    mov DS:was_convert_oct, 1

    mov ah, 9
    lea dx, DS:mess_convert_success
    int 21h

    ret

convert_bin_hex:
    cmp was_input_bin, 1
    jne error_convert

    call shift_bin_digits_to_end

    mov al, DS:arr_16[0]
    cmp al, 1                 ; Посмотрели, какой у числа знак
    je minus

    plus:
        mov DS:hex_sign, '+'
        jmp change_first_digit
    
    minus:
        mov DS:hex_sign, '-'
    
    change_first_digit:
        mov DS:arr_16[0], 0
        
    mov si, 0
    mov di, 0
    convert_while_h:
        call help_convert_b_h
        call hex_number_to_char

        mov DS:hex_num[di], bl
        inc di

        cmp si, 16
        jne convert_while_h

    mov DS:was_convert_hex, 1

    mov ah, 9
    lea dx, DS:mess_convert_success
    int 21h

    ret

CODESEG ENDS
END