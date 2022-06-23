; Этот модуль предназначен для ввода и ввода строк
; Строка должна заканчиватся символом $

PUBLIC input_str_from_stdin
PUBLIC print_str_to_stdout

EXTRN string:BYTE

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG

input_str_from_stdin:
    mov ah, 0ah
    lea dx, string
    int 21h            ; вызываем прерывание для считывания строки в string

    ret                ; возвращаем управление вызывающей стороне
	
print_str_to_stdout:   ; Вывод строки на экран
	mov string + 1, 0ah  ; первые два байта - выводить все равно не надо, поэтому можно записать туда переход на новую строку
	
	mov ah, 9
    lea dx, string + 1
    int 21h            ; вызываем прерывание для считывания строки в INPUT_STR
	
	ret
	
CODESEG ENDS
END
