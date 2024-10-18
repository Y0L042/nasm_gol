; main.asm
; 32bit nasm

section .data
	; Game Window Parameters
	win_title	db "Raylib ASM", 0		; Window title
	win_width	dd 800						; Window width
	win_height	dd 600						; Window height
	target_fps	dd 60						; Target fps

	; Message to display
	message		db "Hello, World!", 0		; Null-term string
	msg_pos_x	dd 100						; x pos
	msg_pos_y	dd 100						; y pos
	font_size	dd 30						; font size
	
	COLOR_BLACK	dd 0xFF000000				; Color: Black { 0, 0, 0, 255 } (RGBA)
	COLOR_WHITE dd 0xFFFFFFFF			    ; Color: White { 255,255,255,255 }(RGBA)

  format db "%d", 10, 0   ; C 0-terminated string: "%#x\n"

  grid_height equ 32
  grid_width equ 32

section .bss
  grid resb grid_width * grid_height * 1

section .text
  global main
  extern InitWindow, WindowShouldClose, CloseWindow 
	extern BeginDrawing, EndDrawing, ClearBackground
	extern SetTargetFPS, DrawText
  extern DrawRectangle
	extern printf


;*******************************************************************************
;* int main();
;*******************************************************************************
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

.pre_loop:
	; int power(int x, int n)
	push dword 2				; int n
	push dword 3				; int x
	call power
	add esp, 8

	; void print_int(int x)
	push eax					; int x
	call print_int
	add esp, 4

  ; Create 2D grid
  ; void initialize_grid(int width, int height)
  mov eax, grid_height
  push eax                                  ; int height
  mov eax, grid_width
  push eax                                  ; int width
  call initialize_grid
  add esp, 4

.main_loop:
	; Check if window should close
	; bool WindowShouldClose(void)
	call WindowShouldClose
	test eax, eax				; Check if EAX is non-zero
	jnz .main_loop_end			; if non-zero, exit loop

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
	jmp .main_loop

.main_loop_end:
	; Close window
	call CloseWindow

	; Exit program
	mov eax, 0
	ret



;*******************************************************************************
;* int power(int x, int n);
;*******************************************************************************
%define n [ebp+12]
%define x [ebp+8]
power:
	push ebp		; store return address
	mov ebp, esp	; set base_ptr (ebp) equal to end of stack frame

	mov eax, x
	mov ebx, n


	mov esp, ebp
	pop ebp
	ret


;*******************************************************************************
;* void print_int(int x);
;*******************************************************************************
%define x [ebp+8]
print_int:
	push ebp
	mov ebp, esp

	mov eax, x
	push eax
	push format
	call printf
	add esp, 8

	mov esp, ebp
	pop ebp
	ret

;*******************************************************************************
;* void initialize_grid(int width, height);
;*******************************************************************************
%define height [ebp+12]
%define width [ebp+8]
initialize_grid:
  push ebp
  mov ebp, esp

  mov eax, 0

.fill_rows:
  cmp ecx, height
  jge .done_fill

  mov edx, 0

.fill_columns:
  cmp edx, width
  jge .next_row

  mov eax, ecx
  imul eax, width
  add eax, edx
  shl eax, 2

  ; Set all pixels to dead
  mov byte [grid + eax + 0], 255 ; R

  inc edx
  jmp .fill_columns

.next_row:
  inc ecx
  jmp .fill_rows

.done_fill:
  mov esp, ebp
  pop ebp
  ret

