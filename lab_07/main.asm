; Указание, что в программе один сегмент на все
.MODEL TINY

CODES SEGMENT
    ASSUME CS:CODES
    ORG 100H                            ; Там хранится PSP (делаем сдвиг)

MAIN:
    JMP INSTALL_BREAKING     

    ; Определение всяких переменных           
    OLD_INTERR  DD 0                     ; Сюда будем сохранять адрес старого обработчика
    WAS_INSTALL DB 1                     ; Флаг, показывающий была ли установка нашего 
    SPEED       DB 1Fh                   ; Скорость автоповтора ввода (изначально самая минимальная - 2 симв./сек.)
    TIME        DB 0                     ; Текущее время

    INSTALL_MSG   DB 'Install success$'
    UNINSTALL_MSG DB 'Uninstall success$'

MY_NEW_INTERR PROC NEAR
    ; Сохраняем значения регистров, чтобы потом их восстановить
    PUSH AX
    ; PUSH BX
    PUSH CX
    PUSH DX
    ; PUSH DI
    ; PUSH SI
    ; PUSH ES
    ; PUSH DS

    ; Сохраняет значения флагов 
    ; PUSHF

    ; Чтение времени из RTC. Возвращает время в формате: час (в регистре СН), минуту (CL), секунду (DH).
    MOV AH, 02h   
    INT 1Ah 

    ; Если секунда не изменилась, то ничего не делаем
    CMP DH, TIME
    je EXIT_BREAKING                                    

    ; Если секуна изменилась, то сохраняем новое значение и изменяем скорость автоповтора (увеличиваем)
    MOV TIME, DH                                        
    DEC SPEED                                           

    CMP SPEED, 1Fh                                      ; эта конструкция закольцовывет cur_speed в диапазоне 00h-1Fh, т.е. меняется только скорость автоповтора (в пределах 2-30 симв./сек.), а пауза перед началом автоповтора остаётся минимальной (250 мс)
    jbe SET_SPEED
    
    mov SPEED, 1Fh

    SET_SPEED:
    MOV AL, 0F3h                                        ; команда F3h отвечает за параметры режима автоповтора нажатой клавиши ; '0' в начале числа можно и не писать, но тогда MASM будет воспринимать это как метку, потому что она начинается с буквы
    OUT 60h, AL                                         ; порт 60h предназначен для работы с клавиатурой и обычно принимает пары байтов последовательно: первый - код команды, второй - данные

    MOV AL, SPEED
    OUT 60h, AL     

    EXIT_BREAKING:
    ; Восстанавливаем значения регистров
    ; POP DS
    ; POP ES
    ; POP SI
    ; POP DI
    POP DX
    POP CX
    ; POP BX
    POP AX

    ; Вызываем дефолтный обработчик события, чтобы ничего не сломалось
    JMP CS:OLD_INTERR

    ; IRET

MY_NEW_INTERR ENDP

INSTALL_BREAKING:
    ; Скачали процедуру, которая обрабатывает прерывание 1C сейчас
    MOV AX, 351CH 
    INT 21H

    ; Если установка уже была, то нужно наоборот вернуть все как было
    CMP ES:WAS_INSTALL, 1
    JE UNINSTALL_BREAKING

    ; Сохраняем адрес вектора прерывания старого
    ; 'word ptr' нужно для того, чтобы обратиться по двухбайтному адресу
    MOV WORD PTR OLD_INTERR, BX      
    MOV WORD PTR OLD_INTERR + 2, ES  

    ; Установка нашего собственного прерывания
    MOV AX, 251CH               
    LEA DX, MY_NEW_INTERR
    INT 21H                     

    ; Вывод сообщения об установке
    LEA DX, INSTALL_MSG
    MOV AH, 9
    INT 21H

    ; Прерывание 27h – завершиться, но остаться в памяти. При этом в DX кладется адрес первого байта за резидентным участком программы
    ; То есть всё, начиная с адреса метки init, будет освобождено из памяти
    LEA DX, INSTALL_BREAKING
    INT 27H            

UNINSTALL_BREAKING:
    ; Восстанавливаем дефолтную скорость для автоповтора
    MOV al, 0F3h                                            
    OUT 60h, al                                             
    MOV al, 0
    OUT 60h, al 

    PUSH ES
    PUSH DS

    ; Восстанавливаем дефолтный обработчик прерывания
    MOV AX, 251CH 
    MOV DX, WORD PTR ES:OLD_INTERR          
    MOV DS, WORD PTR ES:OLD_INTERR[2]     
    INT 21H

    POP DS
    POP ES

    ; Вывод сообщения о том, что все успешно
    LEA DX, UNINSTALL_MSG
    MOV AH, 9H
    INT 21H

    ; Освобождаем блок памяти, начинающийся с адреса ES:0000
    MOV AH, 49H                         
    INT 21H

    ; Завершили программу окончательно
    MOV AX, 4C00H
    INT 21H
    

CODES ENDS
END MAIN