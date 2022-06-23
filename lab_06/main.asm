; Основной модуль программы

PUBLIC exit

EXTERN input_bin_number : far
EXTERN print_bin_number : far
EXTERN convert_bin_oct : far
EXTERN convert_bin_hex : far
EXTERN print_help_bin : far
EXTERN print_oct_number : far
EXTERN print_hex_number : far

EXTERN mess_menu : byte
EXTERN mess_echo_command : byte
EXTERN mess_result : byte
EXTERN err_invalid_command : byte

EXTERN choice : word
EXTERN commands : word

CODESEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CODESEG

exit:
    mov ax, 4c00h
    int 21h

error_command:
    mov ah, 9
    lea dx, DS:err_invalid_command
    int 21h

    call input_command

print_menu:
    mov ah, 9
    lea dx, DS:mess_menu
    int 21h

    ret

input_command:
    call print_menu

    mov ah, 1
	int 21h

	cmp al, '/'                  
	jle error_command

    ; cmp al, '0'
    ; je exit

	cmp al, '4'                  
	jg error_command

	sub al, 30h

    ret

main:
    mov ax, seg choice
    mov ds, ax

    infinite_loop:
    call input_command 

    mov ah, 0  
    mov bx, 2
    mul bx
    mov bx, ax

    call DS:commands[bx]

    jmp infinite_loop      ; Вывели меню

    mov ah, 4Ch
    int 21h

CODESEG ENDS
END main


    ; Вывод сообщения о том, какую команду ввели
    ; mov ah, 9
    ; lea dx, DS:mess_echo_command
    ; int 21h

    ; mov ah, 2
    ; mov dl, DS:choice
    ; add dl, 30h
    ; int 21h

    ; call input_bin_number  ; Ввод двоичного числа

    ; mov ah, 9
    ; lea dx, DS:mess_result
    ; int 21h

    ; call convert_bin_oct   ; Перевели в восьмиричную 
    ; call print_help_bin    ; Заодно вывели в красивом виде двоичное

    ; call convert_bin_hex   ; Перевели в шестнадцатиричную 

    ; call print_oct_number  ; Напечатали восьмиричное
    ; call print_hex_number  ; Напечатали шестнадцатиричное
