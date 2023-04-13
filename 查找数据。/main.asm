.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwexitcode:Dword
INCLUDE Irvine32.inc
INCLUDE macros.inc
includelib Irvine32.lib
 
.data
array dword 88, 5, 1, 443, 21, 310, 4, 75, 27, 0
inputNum dword ?
msg byte "The input number is not in the array!", 0
promptBad byte "Invalid input, please enter again", 0
split byte " : ", 0
 
.code
 
main PROC
mov edi, 0
mov ecx, lengthof array                  ;lengthof 得到数组元素个数
 
read:
call ReadDec
jnc  goodInput
mov edx, OFFSET promptBad
call WriteString;
jmp  read
 
goodInput:
mov  inputNum, eax                       ;store input value
 
L1 :
mov ebx, [array + edi]                   ;[]意为解析操作，取出该地址里的值
cmp ebx, inputNum
je Find
add edi, type array                      ;type得到元素长度（字节），加进edi，得到下一个元素地址
loop L1
 
jmp notFind
 
Find:
mov eax, edi
cdq
mov ebx, type array
div ebx
inc eax
call WriteDec                             ;打印eax寄存器里的值（数字位置） （数字 : 数字）
mov eax, [array + edi]
mov edx, offset split
call WriteString
call WriteDec
jmp ed
 
notFind:
mov edx, offset msg
call WriteString
jmp ed
 
ed:
exit
 
main ENDP
END main