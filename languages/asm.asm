; x86-64 NASM sample
%define SYS_WRITE 1
%define STDOUT    0x01

%macro  syscall3 4
        mov     rax, %1
        mov     rdi, %2
        mov     rsi, %3
        mov     rdx, %4
        syscall
%endmacro

BITS 64
default rel

        global  _start
        global  sum_bytes:function
        extern  printf
        extern  exit

MSG_LEN equ     msg_end - msg

        section .rodata
msg:    db      "hello, `theme'", 0Ah, 09h, 0
msg_end:
fmt:    db      `raw \t %s = %d\n`, 0
tag:    dw      0b1010_1010, 0Fh, 'A', -1
table:  dq      1.5e3, 0x7FFFFFFFFFFFFFFF
pad:    times   16 db 0xCC

        section .bss
buf:    resb    64
slot:   resq    1
count:  resd    1

        section .text
sum_bytes:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        xor     eax, eax
        lea     rsi, [rel msg]
        mov     qword [rbp-8], rsi
        mov     rcx, MSG_LEN
        jz      .done
.loop:
        movzx   edx, byte [rsi]
        cmp     dl, 'z'
        ja      .skip
        add     al, dl
        and     eax, 0xFF
        shl     edx, 2
        or      eax, edx
.skip:
        inc     rsi
        dec     rcx
        jnz     .loop
.done:
        mov     dword [count], eax
        movsd   xmm0, [table]
        mov     rsp, rbp
        pop     rbp
        ret

_start:
        call    sum_bytes
        mov     rdi, fmt
        mov     esi, dword [count]
        xor     eax, eax
        call    printf wrt ..plt
        syscall3 SYS_WRITE, STDOUT, msg, MSG_LEN
        cmp     eax, 0
        jne     .fail
        jmp     .out
.fail:
        neg     eax
.out:
        mov     edi, eax
        call    exit
