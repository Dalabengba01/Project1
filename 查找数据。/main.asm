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
mov ecx, lengthof array                  ;lengthof �õ�����Ԫ�ظ���
 
read:
call ReadDec
jnc  goodInput
mov edx, OFFSET promptBad
call WriteString;
jmp  read
 
goodInput:
mov  inputNum, eax                       ;store input value
 
L1 :
mov ebx, [array + edi]                   ;[]��Ϊ����������ȡ���õ�ַ���ֵ
cmp ebx, inputNum
je Find
add edi, type array                      ;type�õ�Ԫ�س��ȣ��ֽڣ����ӽ�edi���õ���һ��Ԫ�ص�ַ
loop L1
 
jmp notFind
 
Find:
mov eax, edi
cdq
mov ebx, type array
div ebx
inc eax
call WriteDec                             ;��ӡeax�Ĵ������ֵ������λ�ã� ������ : ���֣�
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