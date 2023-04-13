.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwexitcode:Dword

include Irvine32.inc
 
.data
array dword 11, 29, 10, 15, 2, 12, 1, 99, 67, 40	;通过随机数生成器生成若干个100以内的数
str1  byte ": ",0									;调用输出函数所使用到的字符串
str2  byte "Not Found",0    
str3  byte "Please input the number to find:",0
x dword ?
len dword ?
 
.code
main PROC
mov edi, 0						;遍历变量 i=0
mov len, lengthof array			;获取数组长度

read:
	mov edx, offset str3
	call WriteString
	call ReadDec
	mov x, eax

search:
	mov ebx, [array + edi]
	cmp ebx, x
	je found					;遍历到的数与待查找数相等，表示已找到，则跳转至found

	add edi, type array			;i++
	sub len, 1					;len--,用于终止循环，防止数组越界
	jnz search					;循环遍历数组

	jmp notFound				;遍历完数组都未找到与待查找数相同的元素，表示未找到，跳转至notFound

found:
	mov eax, edi				;将当前位置的总字节数存入eax，并用cdq将eax扩展到edx
	cdq
	mov ebx, type array			;用ebx存一个元素所占字节数
	div ebx						;得出待查找元素的位置

	call WriteDec				;打印eax寄存器里的值（位置）

	mov edx, offset str1
	call WriteString			;打印 ：

	mov eax, [array + edi]
	call WriteDec				;打印所查数

	INVOKE ExitProcess,0

notFound:
	mov edx, offset str2
	call WriteString

	INVOKE ExitProcess,0

 
main ENDP
END main