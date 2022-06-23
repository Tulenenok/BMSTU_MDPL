; Модуль содержит в себе основную программу, 
; которая считывает строку с консоли и выводит ее обратно в консоль

PUBLIC string

EXTRN input_str_from_stdin:far
EXTRN print_str_to_stdout:far

STACKSEG SEGMENT PARA STACK 'STACK'
	DB 200h dup('$')
STACKSEG ENDS

DATASEG SEGMENT
    string DB 13 DUP('$'), '$'    ; почему-то перестает работать, если пытаться проинициализировать 0
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

main:
	mov ax, DATASEG
    mov ds, ax         ; связываем регистр ds с сегментом DATASEG
	
	call input_str_from_stdin
	call print_str_to_stdout
	
	mov ah, 4Ch
	int 21h            ; завершаем программу
	
CODESEG ENDS
END main