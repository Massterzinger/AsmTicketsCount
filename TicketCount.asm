.386
.model flat, stdcall
option casemap: none
include D:\Programs\masm32\include\windows.inc
include D:\Programs\masm32\include\user32.inc
include D:\Programs\masm32\include\kernel32.inc
includelib D:\Programs\masm32\lib\user32.lib
includelib D:\Programs\masm32\lib\kernel32.lib

BSIZE equ 7

.data
data32left DWORD ?
data32right DWORD ?
data32Count DWORD ?
data32Iter DWORD ?
data32Ten DWORD ?
data32func DWORD ?
data32Div DWORD ?
ifmt db "%d",0
buf db BSIZE dup (?)
crlf db 0dh, 0ah
stdout dd ?
cWritten dd ?

.code
start:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov stdout, eax
    mov data32Ten, 10
    mov data32Count, 0
    mov edx, 1000
    mov ecx, 1000000
    nxt:
        mov data32Iter, edx; int i
        call CheckNums
        cmp eax, 0
        jz CountInc
        jmp AllInc
        CountInc:
            inc data32Count
        AllInc:
            inc data32Iter
            mov edx, data32Iter
            cmp edx, ecx
            jz done
            jmp nxt

done:
    invoke wsprintf, ADDR buf, ADDR ifmt, data32Count
    invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, NULL
    invoke WriteConsoleA, stdout, ADDR crlf, 2, ADDR cWritten, NULL
invoke ExitProcess, 0

CheckNums proc
    mov data32left, 0
    mov eax, edx
    mov data32Div, 1000
    mov edx, 0
    div data32Div

    call GetSum
    mov eax, data32func
    mov data32left, eax
    ;------------------------------
    mov data32right, 0
    mov eax, data32Iter

    call GetSum
    mov eax, data32func
    mov data32right, eax

    mov eax, data32right
    sub eax, data32left
    ret 
CheckNums endp

GetSum proc
    mov data32func, 0 
    mov edx, 0
    div data32Ten
    add data32func, edx; result of i%10
    
    mov edx, 0
    div data32Ten
    add data32func, edx; result of (i/10)%10

    mov edx, 0
    div data32Ten
    add data32func, edx ; result of (i/100)%10
ret
GetSum endp

end start