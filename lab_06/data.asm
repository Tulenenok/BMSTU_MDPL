; Все данные, с которыми происходит работа в программе

EXTERN input_bin_number:far
EXTERN convert_bin_oct:far
EXTERN convert_bin_hex:far
EXTERN print_all:far
EXTERN exit:far

STACKSEG SEGMENT PARA STACK 'stack'
        DB 200h DUP(?)
STACKSEG ENDS

DATASEG SEGMENT 'menu'
    choice DW ?
    commands dw exit, input_bin_number, convert_bin_oct, convert_bin_hex, print_all
DATASEG ENDS

DATASEG SEGMENT PARA PUBLIC 'messages'
    mess_menu DB 10, 10, 'Menu:', 10, '  0. EXIT', 10, '  1. Input number', 10, '  2. Convert to unsigned 8', 10, '  3. Convert to signed 16', 10, '  4. Print results', 10, 'Input command: $'
    mess_echo_command DB 10, 10, 'Command: ', '$'
    mess_input DB 10, 10, 'Input signed binary number [count digits <= 16]: ', '$'

    mess_input_success DB 'Input ---> SUCCESS', '$'
    mess_input_failure DB 'Input ---> FAILURE', '$'
    mess_convert_success DB 10, 'Convert ---> SUCCESS', '$'
    mess_convert_failure DB 10, 'Convert ---> FAILURE (input at first)', '$'
    mess_print_hex_failure DB 10, 'Print 16 ---> FAILURE (convert at first)', '$'
    mess_print_oct_failure DB 10, 'Print 8 ---> FAILURE (convert at first)', '$'
    mess_print_bin_failure DB 10, 'Print 2 ---> FAILURE (input at first)', '$'

    mess_print_bin DB 10, 10, 'INPUT', 10, 'Signed bin number: ', '$'
    mess_print_oct DB 10, 'Unsigned oct number: ', '$'
    mess_print_hex DB 10, 'Signed hex number: ', '$'
    mess_result DB 10, 10, 'RESULT CONVERT', '$'

    err_invalid_digit DB 10, 10, 'ERROR: invalid command [ >= 0 & <= 4 ]', 10, '$'
    err_invalid_command DB 10, 10, 'ERROR: invalid command [>= 0 & <= 4]', 10, '$'
DATASEG ENDS

DATASEG SEGMENT PUBLIC 'bin_number'
    max_digits_bin DB 16
    count_digits_bin DB 0
    bin_num DB 16 dup ('?')                  ; Знаковое
DATASEG ENDS

DATASEG SEGMENT PUBLIC 'oct_number'
    max_digits_oct DB 15 / 3
    count_digits_oct DB 0
    oct_num DB 15 / 3 dup ('?')              ; Беззнаковое
DATASEG ENDS

DATASEG SEGMENT PUBLIC 'hex_number'
    hex_sign DB '+'
    max_digits_hex DB 16 / 4
    count_digits_hex DB 0
    hex_num DB 16 / 4 dup ('?')              ; Знаковое (знак в отдельной переменной)
DATASEG ENDS

DATASEG SEGMENT PUBLIC 'flags'
    was_input_bin DB 0
    was_convert_oct DB 0
    was_convert_hex DB 0
DATASEG ENDS

DATASEG SEGMENT PUBLIC 'temp'
    tb DB ?
    tw DB ?
    arr_16 DB 16 dup ('?')
    arr_5 DB 5 dup ('?')
    arr_3 DB 3 dup ('?')
DATASEG ENDS


PUBLIC choice
PUBLIC commands

PUBLIC mess_menu
PUBLIC mess_echo_command
PUBLIC mess_input
PUBLIC mess_input_success
PUBLIC mess_input_failure
PUBLIC mess_convert_success
PUBLIC mess_convert_failure
PUBLIC mess_print_bin
PUBLIC mess_print_oct
PUBLIC mess_print_hex
PUBLIC mess_result
PUBLIC mess_print_hex_failure
PUBLIC mess_print_oct_failure
PUBLIC mess_print_bin_failure
PUBLIC err_invalid_digit
PUBLIC err_invalid_command

PUBLIC max_digits_bin
PUBLIC count_digits_bin
PUBLIC bin_num

PUBLIC max_digits_oct
PUBLIC count_digits_oct
PUBLIC oct_num

PUBLIC hex_sign
PUBLIC max_digits_hex
PUBLIC count_digits_hex
PUBLIC hex_num

PUBLIC was_input_bin
PUBLIC was_convert_oct
PUBLIC was_convert_hex

PUBLIC tb
PUBLIC tw
PUBLIC arr_16
PUBLIC arr_5
PUBLIC arr_3

END