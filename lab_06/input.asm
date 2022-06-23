; Ввод числа (знаковое двоичное)

PUBLIC input_bin_number

EXTERN count_digits_bin : byte
EXTERN max_digits_bin : byte
EXTERN bin_num : byte

EXTERN mess_input : byte
EXTERN mess_input_success : byte
EXTERN mess_input_failure : byte

EXTERN err_invalid_digit : byte
EXTERN was_input_bin : byte
EXTERN was_convert_oct : byte
EXTERN was_convert_hex : byte

EXTERN arr_16 : byte
EXTERN tb : byte

CODESEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CODESEG

clean_number:
    mov si, 0
    mov ch, DS:max_digits_bin

    clean_while:
        mov DS:arr_16[si], '?'
        inc si
        dec ch
        cmp ch, 0
        jne clean_while

    mov DS:tb, 0

    ret

error_digit:
    mov ah, 9
    lea dx, DS:err_invalid_digit
    int 21h

    jmp error_exit

inc_count:
    mov al, DS:tb
    inc al
    mov DS:tb, al

    ret

input_one_bin_digit:
    mov ah, 1
	int 21h

    cmp al, 13                 
	je input_exit

	cmp al, '/'                  
	jle error_digit

	cmp al, '1'                  
	jg error_digit

	sub al, 30h
    mov DS:arr_16[si], al
    inc si

    call inc_count

    jmp condition

copy_arr_bin_num:
    mov si, 0
    mov ch, DS:max_digits_bin

    copy_while:
        mov al, DS:arr_16[si]
        mov DS:bin_num[si], al

        inc si
        dec ch
        cmp ch, 0
        jne copy_while

    mov al, DS:tb
    mov DS:count_digits_bin, al

    ret


input_bin_number:
    call clean_number

    mov ah, 9
    lea dx, DS:mess_input
    int 21h

    mov si, 0

    condition:
        mov al, DS:tb
        mov ah, DS:max_digits_bin
        cmp al, ah

    jne input_one_bin_digit

    input_exit:
        mov DS:was_input_bin, 1
        mov DS:was_convert_oct, 0
        mov DS:was_convert_hex, 0

        mov ah, 9
        lea dx, DS:mess_input_success
        int 21h

        call copy_arr_bin_num
        ret

    error_exit:
        mov ah, 9
        lea dx, DS:mess_input_failure
        int 21h
        ret

CODESEG ENDS
END