; main.asm
; 32bit nasm

section .data
	; Game Window Parameters
	win_title	db "Hello Window", 0		; Window title
	win_width	dd 800						; Window width
	win_height	dd 600						; Window height
	target_fps	dd 60						; Target fps

	; Message to display
	message		db "Hello, World!", 0		; Null-term string
	msg_pos_x	dd 100						; x pos
	msg_pos_y	dd 100						; y pos
	font_size	dd 30						; font size
	
	COLOR_BLACK	dd 0xFF000000				; Color: Black { 0, 0, 0, 255 } (RGBA)
	COLOR_WHITE dd 0xFFFFFFFF			    ; Color: White { 255, 255, 255, 255 } (RGBA)

section .text
    global main
    extern InitWindow, WindowShouldClose, CloseWindow 
	extern BeginDrawing, EndDrawing, ClearBackground
	extern SetTargetFPS, DrawText

main:
	; Initialize window
	; InitWindow(int width, int height, const char *title)
	push dword win_title		; const char *title
	push dword [win_height]		; int height
	push dword [win_width]		; int width
	call InitWindow
	add esp, 12					; Clean up stack (3 args of 4bytes each)

	; Set target fps
	; SetTargetFPS(int fps)
	push dword [target_fps]		; int fps
	call SetTargetFPS
	add esp, 4					; Clean up stack (4bytes)

main_loop:
	; Check if window should close
	; bool WindowShouldClose(void)
	call WindowShouldClose
	test eax, eax				; Check if EAX is non-zero
	jnz main_loop_end			; if non-zero, exit loop

	; Begin drawing
	call BeginDrawing

	; Clear background with black
	; void ClearBackground(Color color)
	push dword [COLOR_BLACK]	; Color color
	call ClearBackground
	add esp, 4					; Clean up stack

	; Draw text "Hello, World!"
	; void DrawText(const char *text, int x, int y, int fontsize, Color color)
	push dword [COLOR_WHITE]	; Color color
	push dword [font_size]		; int fontsize
	push dword [msg_pos_y]		; int y
	push dword [msg_pos_x]		; int x
	push dword message			; const char *text
	call DrawText
	add esp, 20					; Clean up stack (5 args of 4bytes each)

	; End drawing
	call EndDrawing

	; Repeat main_loop
	jmp main_loop

main_loop_end:
	; Close window
	call CloseWindow

	; Exit program
	mov eax, 0
	ret

