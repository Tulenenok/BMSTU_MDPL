; Этот модуль предназначен для ввода и ввода строк
; Строка должна заканчиватся символом $
; Для ввода и вывода адрес строки должен при вызове находится в регистре bx

PUBLIC input_str_from_stdin
PUBLIC input_char_from_stdin
PUBLIC input_digit_from_stdin

PUBLIC print_str_to_stdout
PUBLIC print_char_to_stdout
PUBLIC print_digit_to_stdout


CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG

input_str_from_stdin:
    mov ah, 0ah
    mov dx, bx
    int 21h            ; вызываем прерывание для считывания строки в string

    ret                ; возвращаем управление вызывающей стороне
	
print_str_to_stdout:   ; Вывод строки на экран
	mov ah, 9
    mov dx, bx
    int 21h            ; вызываем прерывание для вывода строки
	
	ret
	
input_char_from_stdin: 
	mov ah, 1
	int 21h
	
	ret 
	
print_char_to_stdout:
	mov ah, 2
	mov dl, bl
	int 21h
	
	ret
	
input_digit_from_stdin: 
	mov ah, 1
	int 21h
	sub al, 30h        ; изменяем представление чисела с ascii-кода на реальное число
	
	ret                ; считанная цифра будет лежать в al
	
print_digit_to_stdout:
	mov ah, 2
	add bl, 30h        ; возвращаемся из представления чисел в представлние ascii-кода
	mov dl, bl
	int 21h
	
	ret
	
CODESEG ENDS
END
