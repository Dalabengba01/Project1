.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwexitcode:Dword

include Irvine32.inc
 
.data
array dword 11, 29, 10, 15, 2, 12, 1, 99, 67, 40	;ͨ��������������������ɸ�100���ڵ���
str1  byte ": ",0									;�������������ʹ�õ����ַ���
str2  byte "Not Found",0    
str3  byte "Please input the number to find:",0
x dword ?
len dword ?
 
.code
main PROC
mov edi, 0						;�������� i=0
mov len, lengthof array			;��ȡ���鳤��

read:
	mov edx, offset str3
	call WriteString
	call ReadDec
	mov x, eax

search:
	mov ebx, [array + edi]
	cmp ebx, x
	je found					;���������������������ȣ���ʾ���ҵ�������ת��found

	add edi, type array			;i++
	sub len, 1					;len--,������ֹѭ������ֹ����Խ��
	jnz search					;ѭ����������

	jmp notFound				;���������鶼δ�ҵ������������ͬ��Ԫ�أ���ʾδ�ҵ�����ת��notFound

found:
	mov eax, edi				;����ǰλ�õ����ֽ�������eax������cdq��eax��չ��edx
	cdq
	mov ebx, type array			;��ebx��һ��Ԫ����ռ�ֽ���
	div ebx						;�ó�������Ԫ�ص�λ��

	call WriteDec				;��ӡeax�Ĵ������ֵ��λ�ã�

	mov edx, offset str1
	call WriteString			;��ӡ ��

	mov eax, [array + edi]
	call WriteDec				;��ӡ������

	INVOKE ExitProcess,0

notFound:
	mov edx, offset str2
	call WriteString

	INVOKE ExitProcess,0

 
main ENDP
END main