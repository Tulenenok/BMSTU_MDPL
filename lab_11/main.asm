; #########################################################################

      .386
      .model flat, stdcall
      option casemap :none   ; case sensitive

; #########################################################################

      include \masm32\include\windows.inc
      include \masm32\include\user32.inc
      include \masm32\include\kernel32.inc
      include \masm32\include\gdi32.inc
      include \masm32\include\masm32.inc

      includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\gdi32.lib
      includelib \masm32\lib\masm32.lib

; #########################################################################

        ;=============
        ; Local macros
        ;=============
  
        szText MACRO Name, Text:VARARG
          LOCAL lbl
            jmp lbl
              Name db Text,0
            lbl:
          ENDM
          
        ;=================
        ; Local prototypes
        ;=================
        WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        
    .data
        hEdit1      HWND ?         ; HWND -- дескриптор окна
        hEdit2      HWND ?
        hButn1      HWND ?
        hInstance   dd 0
        hIconImage  dd 0
        hIcon       dd 0
        dlgname     db "TESTWIN",0
		    res         db 10 dup(?)
		

; #########################################################################

    .code

start:

      invoke GetModuleHandle, NULL
      mov hInstance, eax
      
      ; -------------------------------------------
      ; Call the dialog box stored in resource file
      ; -------------------------------------------
      invoke DialogBoxParam,hInstance,ADDR dlgname,0,ADDR WndProc,0

      invoke ExitProcess, eax

; #########################################################################

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

      LOCAL Ps :PAINTSTRUCT

      .if uMsg == WM_INITDIALOG
      
        szText dlgTitle,"Lab_11 Gurova Natalia IU7-44"
        invoke SendMessage,hWin,WM_SETTEXT,0,ADDR dlgTitle

        invoke LoadIcon,hInstance,200
        mov hIcon, eax
        invoke SendMessage,hWin,WM_SETICON,1,hIcon

        invoke GetDlgItem,hWin,100
        mov hEdit1, eax

        invoke GetDlgItem,hWin,101
        mov hEdit2, eax

        invoke GetDlgItem,hWin,1000
        mov hButn1, eax

        xor eax, eax
		
        ret


      .elseif uMsg == WM_COMMAND
        .if wParam == 1000
					
			; первое число
			invoke GetWindowText, hEdit1, addr res, 10
      xor ebx, ebx
			xor eax, eax
			xor edi, edi
			
			mov bl, byte ptr res[0]
			sub bl, '0'
			push ebx

      invoke GetWindowText, hEdit2, addr res, 10
      xor ebx, ebx
			xor eax, eax
			xor edi, edi
			
			mov bl, byte ptr res[0]
			sub bl, '0'
			add eax,ebx
			pop ebx
			add eax, ebx
			
			mov bl, 10
			div bl
			
			add al, '0'
			mov bl, al
			add ah, '0'
			mov bh, ah

      cmp bl, '0'
      jne print
      mov bl, ' '

			print:
			mov dword ptr res, ebx
			szText dlgTitle1,"RESULT"
            invoke MessageBox, hWin, ADDR res,
                              ADDR dlgTitle1,MB_OK
			
			
        .endif

      .elseif uMsg == WM_CLOSE
        invoke EndDialog,hWin,0

      .elseif uMsg == WM_PAINT
        invoke BeginPaint,hWin,ADDR Ps
      ; ----------------------------------------
      ; The following function are in MASM32.LIB
      ; ----------------------------------------
        ;invoke FrameGrp,hButn1, 6,1,0
        ;invoke FrameGrp,hEdit1,hEdit3,4,1,0
        ;invoke FrameCtrl,hEdit4,4,1,0
        invoke FrameWindow,hWin,0,1,1
        invoke FrameWindow,hWin,1,1,0

        invoke EndPaint,hWin,ADDR Ps
        xor eax, eax
        ret

      .endif

    xor eax, eax    ; this must be here in NT4
    ret

WndProc endp

; ########################################################################

end start
