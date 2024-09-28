; main.asm
section .data
    msg db 'Hello, World!', 0xA ; Message with newline
    len equ $ - msg              ; Length of the message

section .text
    global _start
    extern InitWindow, WindowShouldClose, CloseWindow, BeginDrawing, EndDrawing, ClearBackground

_start:
    ; sys_write(stdout, msg, len)
    mov eax, 4        ; sys_write
    mov ebx, 1        ; file descriptor (stdout)
    mov ecx, msg      ; pointer to message
    mov edx, len      ; message length
    int 0x80          ; call kernel

    ; sys_exit(0)
    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80          ; call kernel
