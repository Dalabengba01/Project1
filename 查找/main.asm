;��������ҪIrvine32�⣬��ʹ��֮ǰ�������ؿ�
;�����޸�include path���������ĸ��ӿ�Ŀ¼������������
;���������޸��ڴ档ĳЩ�����������ֹ�����У���ʹ��֮ǰӦ�ȹر�֮
;���������κ��쳣������������õ�������������밴ָ���ĸ�ʽ��������
;���س���ʾһ������¼�����
;2022/05/26


.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO,dwExitCode:DWORD

include Irvine32.inc				;�����



.data
array dword 100 dup(0)				;��100��˫�ִ�С���ڴ�
str1  byte ": ",0					;�������������ʹ�õ����ַ���
str2  byte "Not Found!",0    
str3  byte "how many numbers do you want to input:",0
str4  byte "please input the number's value:",0
str5  byte "please input the number which is you want to see:",0

.code
main PROC

	mov		edx,offset str3
	call	WriteString

	call	ReadDec					;����һ������������������ĳ���
	mov		ecx,eax
	push	eax						;�����鳤��ѹջ
	lea		edi,array				;��������׵�ַ����edi��
L1:
	
	mov		edx,offset str4
	call	WriteString

	call	ReadDec
	mov		dword ptr [edi],eax		;�洢�Ӽ��������������������������
	add		edi,4
	sub		ecx,1
	jnz		L1						;ѭ������ecx��Ϊ0������L1ѭ������

									;�����Ǹ���һ��Ŀ��ֵ���Լ���ʼ��ѭ������

	mov		edx,offset str5
	call	WriteString

	call	ReadDec
	mov		ebx,eax					;����һ������������Ҫ���ҵ����������ebx��
	mov		ecx,1					;��ʱѭ������ecx������ǣ���ǰ���������еڼ�����

	pop		edx						;edx��ŵ������鳤��
	lea		edi,array				;edi��ŵ��������׵�ַ


L2:
									;�����ǡ����Ҹ��������Ƿ��������С�����
	cmp		edx,ecx
	jl		L3						;�Ƚ����鳤���뵱ǰλ�ã���С��0.��Խ�����˳�ѭ��
	mov		esi,dword ptr [edi]		;esi��Ŵ�����ȡ������
	add		ecx,1
	add		edi,4
	cmp		esi,ebx
	jnz		L2						;�����е�ֵ��Ŀ��ֵ����ȣ�����ѭ��
	
									;��ִ�е�������ò����ף����ʾ�ҵ�Ŀ��ֵ��
									;��ʱ��Ӧ���ecx-1��ֵ�������е�λ��
									;			ebx: ֵ
	sub		ecx,1
	mov		eax,ecx
	call	WriteDec
	mov		edx,offset str1
	call	WriteString
	mov		eax,ebx
	call	WriteDec

	INVOKE ExitProcess,0


L3:	
									;δ���ҵ����������Not Found
	mov		edx,offset str2
	call	WriteString


	INVOKE ExitProcess,0
main ENDP
END main
