;本代码需要Irvine32库，故使用之前需先下载库
;并且修改include path和链接器的附加库目录、附加依赖项
;本代码需修改内存。某些保护软件会阻止其运行，故使用之前应先关闭之
;本程序无任何异常处理，故若你想得到期望的输出，请按指定的格式输入数据
;按回车表示一个数字录入完毕
;2022/05/26


.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO,dwExitCode:DWORD

include Irvine32.inc				;导入库



.data
array dword 100 dup(0)				;给100个双字大小的内存
str1  byte ": ",0					;调用输出函数所使用到的字符串
str2  byte "Not Found!",0    
str3  byte "how many numbers do you want to input:",0
str4  byte "please input the number's value:",0
str5  byte "please input the number which is you want to see:",0

.code
main PROC

	mov		edx,offset str3
	call	WriteString

	call	ReadDec					;输入一个数，它代表这数组的长度
	mov		ecx,eax
	push	eax						;将数组长度压栈
	lea		edi,array				;将数组的首地址存在edi中
L1:
	
	mov		edx,offset str4
	call	WriteString

	call	ReadDec
	mov		dword ptr [edi],eax		;存储从键盘输入的数，到给定的数组中
	add		edi,4
	sub		ecx,1
	jnz		L1						;循环变量ecx不为0，跳到L1循环继续

									;下面是给定一个目标值，以及初始化循环变量

	mov		edx,offset str5
	call	WriteString

	call	ReadDec
	mov		ebx,eax					;输入一个数，它代表要查找的数，存放在ebx中
	mov		ecx,1					;此时循环变量ecx代表的是，当前数是数组中第几个数

	pop		edx						;edx存放的是数组长度
	lea		edi,array				;edi存放的是数组首地址


L2:
									;下面是“查找给定的数是否在数组中”程序
	cmp		edx,ecx
	jl		L3						;比较数组长度与当前位置，若小于0.即越界则退出循环
	mov		esi,dword ptr [edi]		;esi存放从数组取出的数
	add		ecx,1
	add		edi,4
	cmp		esi,ebx
	jnz		L2						;数组中的值与目标值不相等，继续循环
	
									;若执行到这儿（好不容易）则表示找到目标值。
									;此时，应输出ecx-1：值在数组中的位置
									;			ebx: 值
	sub		ecx,1
	mov		eax,ecx
	call	WriteDec
	mov		edx,offset str1
	call	WriteString
	mov		eax,ebx
	call	WriteDec

	INVOKE ExitProcess,0


L3:	
									;未能找到结果，返回Not Found
	mov		edx,offset str2
	call	WriteString


	INVOKE ExitProcess,0
main ENDP
END main
