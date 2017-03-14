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
        mov data32Iter, edx; int i, make a procedure then

        call CheckNums

        ;make %10 and other, eax /= 10, edx = eax%10
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
    mov data32Div, 100000
    mov edx, 0
    div data32Div
    add data32left, eax; result of i/100000
    mov eax, data32Iter
    mov data32Div, 10000
    mov edx, 0
    div data32Div
    mov edx, 0
    div data32Ten
    add data32left, edx ; result of (i/10000)%10
    mov eax, data32Iter
    mov data32Div, 1000
    mov edx, 0
    div data32Div
    mov edx, 0
    div data32Ten
    ;push edx ; result of (i/1000)%10
    add data32left, edx

    mov data32right, 0
    mov eax, data32Iter
    mov edx, 0
    div data32Ten
    add data32right, edx; result of i%10
    mov eax, data32Iter
    mov edx, 0
    div data32Ten
    mov edx, 0
    div data32Ten
    add data32right, edx; result of (i/10)%10
    mov eax, data32Iter
    mov data32Div, 100
    mov edx, 0
    div data32Div
    mov edx, 0
    div data32Ten
    add data32right, edx ; result of (i/100)%10

    mov eax, data32right
    sub eax, data32left
    ret 
CheckNums endp
end start