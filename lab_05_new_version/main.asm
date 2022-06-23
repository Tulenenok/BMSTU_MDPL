; Модуль содержит в себе основную часть программы

EXTRN input_str_from_stdin:far
EXTRN input_digit_from_stdin:far
EXTRN input_char_from_stdin:far

EXTRN print_str_to_stdout:far
EXTRN print_digit_to_stdout:far
EXTRN print_char_to_stdout:far

PUBLIC error_input_data

STACKSEG SEGMENT PARA STACK 'STACK'
	DB 300h dup('$')
STACKSEG ENDS

DATASEG SEGMENT 'messages'
    mess_input_count_rows DB 10, 'Input count rows: ', '$'
	mess_input_count_cols DB 10, 'Input count columns: ', '$'
	mess_input_matrix DB 10, 'Input matrix:', 13, 10, '$'
	mess_find_min_elem DB 10, 'Find min elem: ', '$'
	mess_col_min_elem DB 10, 'Column with min elem: ', '$'
	mess_result DB 10, 10, 'Result:', 13, 10, '$'
	mess_empty_res DB 10, 'Empty result', 10, '$'
	mess_error_input_rows DB 10, 10, 'ERROR: invalid input count rows [int > 0 & < 10]', 10, '$'
	mess_error_input_cols DB 10, 10, 'ERROR: invalid input count columns [int > 0 & < 10]', 10, '$'
	mess_error_input_data DB 10, 10, 'ERROR: invalid input data [int >= 0 & <= 9]', 10, '$'
DATASEG ENDS

DATASEG SEGMENT 'data'
    count_rows DB ?
	count_columns DB ?
	matrix DB 9 * 9 dup (?)
DATASEG ENDS

DATASEG SEGMENT 'res_data'
	res_matrix DB 9 * 9 dup (?)
DATASEG ENDS

DATASEG SEGMENT 'auxiliary_variables'
    min_elem DB ?
	ind_col DB ?
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

error_input_count_rows:
	lea bx, mess_error_input_rows        
	call print_str_to_stdout

	mov ah, 4Ch
	int 21h  

error_input_count_cols:
	lea bx, mess_error_input_cols        
	call print_str_to_stdout

	mov ah, 4Ch
	int 21h   

error_input_data:
 	lea bx, mess_error_input_data       
	call print_str_to_stdout

	mov ah, 4Ch
	int 21h 

empty_res:
    lea bx, mess_empty_res        
	call print_str_to_stdout

	mov ah, 4Ch
	int 21h 

main:
	mov ax, DATASEG
    mov ds, ax 
	
	; ВВОД КОЛИЧЕСТВА СТРОК
	lea bx, mess_input_count_rows         
	call print_str_to_stdout              ; вывод приглашения для ввода количества строк
	
	call input_digit_from_stdin           ; вызов подпрограммы считывающей символ с клавиатуры
	mov count_rows, al                    ; сохранили считанное значение

	cmp count_rows, 0                     ; типа проверка на валидность
	je error_input_count_rows

	cmp count_rows, 9                     ; типа проверка на валидность
	jg error_input_count_rows
	
	; ВВОД КОЛИЧЕСТВА СТОЛБЦОВ
	lea bx, mess_input_count_cols        
	call print_str_to_stdout              ; вывод приглашения для ввода количества столбцов
	
	call input_digit_from_stdin           ; вызов подпрограммы считывающей символ с клавиатуры
	mov count_columns, al                 ; сохранили считанное значение

	cmp count_columns, 0                  ; типа проверка на валидность
	je error_input_count_cols

	cmp count_columns, 9                  ; типа проверка на валидность
	jg error_input_count_cols

	; ВВОД МАТРИЦЫ
	lea bx, mess_input_matrix            
	call print_str_to_stdout              ; вывод приглашения для ввода количества столбцов

	mov ch, count_rows                    ; cl -- счетчик по строкам
	mov si, 0
	input_row: 
		mov bx, 0
		mov cl, count_columns             ; bl -- счетчик по столбцам
		input_col:
			mov ah, 1 
			int 21h

			cmp al, '/'                  ; типа проверка на валидность
			jle error_input_data

			cmp al, '9'                  ; типа проверка на валидность
			jg error_input_data

			mov matrix[si][bx], al
			inc bx

			mov ah, 2
			mov dl, ' '
			int 21h

			dec cl
			cmp cl, 0
			jne input_col

		mov ah, 2
		mov dl, 10
		int 21h

		add si, 9

		dec ch
		cmp ch, 0
		jne input_row

	cmp count_columns, 1          ; обработка пустого результата              
	je empty_res
	
	;ПОИСК МИНИМАЛЬНОГО ЭЛЕМЕНТА
	mov si, 0
	mov bx, 0
	mov al, matrix[si][bx]
	mov min_elem, al

	mov ch, count_rows

	change_min:
		mov al, matrix[si][bx]
		mov min_elem, al
		mov ind_col, cl

	find_min_elem_row:
		mov cl, count_columns 
		find_min_elem_col:
			mov al, matrix[si][bx]
			cmp min_elem, al
			jg change_min     ; по-моему должно быть jl, но работает так...

			inc bx

			dec cl
			cmp cl, 0
			jne find_min_elem_col

		mov bx, 0
		add si, 9

		dec ch
		cmp ch, 0
		jne find_min_elem_row

	; ВЫВОД ПОЯСНЯЮЩИХ СООБЩЕНИЙ ДЛЯ НАЙДЕННЫХ ЗНАЧЕНИЙ
	; мягко говоря UB, нормально говоря -- работает через жопу
	lea bx, mess_find_min_elem
	call print_str_to_stdout

	mov bl, min_elem
	call print_char_to_stdout

	lea bx, mess_col_min_elem
	call print_str_to_stdout

	mov bl, ind_col
	call print_digit_to_stdout

	;УДАЛЯЕМ СТОЛБЕЦ
	mov ch, count_rows
	mov bx, 0

	del_row:
		mov cl, count_columns
		mov si, 0
		mov di, 0

		del_col:
			mov al, count_columns
			sub al, cl
			cmp ind_col, al
			je next_col

			mov al, matrix[bx][si]
			mov res_matrix[bx][di], al

			inc di
			
			next_col:
				inc si
				dec cl
				cmp cl, 0
				jne del_col

		next_row:
			add bx, 9

			dec ch
			cmp ch, 0
			jne del_row

	; ВЫВОД МАТРИЦЫ
	lea bx, mess_result          
	call print_str_to_stdout

	mov ch, count_rows                    ; cl -- счетчик по строкам
	mov si, 0
	print_row: 
		mov bx, 0
		mov cl, count_columns             ; bl -- счетчик по столбцам
		dec cl
		print_col:
			mov ah, 2
			mov dl, res_matrix[si][bx]
			;mov dl, matrix[si + bx]
			int 21h

			mov dl, ' '
			int 21h

			inc bx

			dec cl
			cmp cl, 0
			jne print_col

		add si, 9

		mov ah, 2
		mov dl, 10
		int 21h

		dec ch
		cmp ch, 0
		jne print_row

	mov ah, 4Ch
	int 21h            ; завершаем программу
	
CODESEG ENDS
END main