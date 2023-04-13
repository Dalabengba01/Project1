;msort.asm
data segment
	nums1 db 100,34,78,9,160,200,90,65
	nums2 db 212,152,8,49,83,35,79,51
	buffer db 8 dup(?)               ; 用于两个有序数列进行合并的缓冲区
	bufptr dw 0                      ; buffer中已合并数据的个数
data ends

code segment
	assume cs:code
  
start:     
	mov ax,data
	mov ds,ax
	mov es,ax
	
	;对nums1中的数据排序并显示
	mov bx,offset nums1
	mov ah,0
	mov al,7
	call mergesort
	mov bx,offset nums1
	mov si,0
	call showdecs
	
	;显示换行和回车
	mov dl,0ah
	mov ah, 02h
	int 21h
	mov dl,0dh
	mov ah, 02h
	int 21h
	
	;对nums2中的数据排序并显示
	mov bx,offset nums2
	mov ah,0
	mov al,7
	mov si,0
	mov dx,0
	mov cx,0
	call mergesort
	mov bx,offset nums2
	mov si,0
	call showdecs
	
	mov ah,4ch              ; 功能：返回DOS系统
	int 21h                 ;       DOS功能调用

; 对一组数据进行归并排序（采用递归方法实现）
; bx--基地址 addr cx--数据个数
mergesort proc near
	cmp ah,al				;p=dh,q=dl,start=ah,end=al,mid=si
	jge next
	push ax
	add al,ah
	mov ah,0
	push dx
	mov dl,2
	div dl
	pop dx
	mov ah,0
	mov si,ax				;mid = (end+start)/2
	pop ax
	inc si
	mov dx,si				;q = mid + 1
	dec si
	mov dh,ah				;p = start
	push ax
	push dx
	push si
	push dx
	mov dx,si
	mov al,dl
	pop dx
	call mergesort			;mergerSort(start, mid)
	pop si
	pop dx
	pop ax
	push ax
	push dx
	push si
	inc si
	push dx
	mov dx,si
	mov ah,dl
	pop dx
	dec si
	call mergesort			;mergerSort(mid+1,end)
	pop si
	pop dx
	pop ax
	call mergepart
next:
    ret
mergesort endp

; 对两组已分别排序的数据进行合并和排序，两组数据的个数相同
;    中间结果可以存放到buffer中，最后结果要放到原区域
; 参数：bx--基地址（两部分连续存放）,cx--每组数据的个数
mergepart proc near
	push ax				;p=dh,q=dl,start=ah,end=al,mid=si
	push bx	
	push dx
	push si
	push bx
	mov cx,0
	mov cl,ah
	push cx
	
	
again1:
	pop cx
	push dx
	push ax
	mov ah,0
	mov al,dh
	mov dl,al
	mov dh,0
	pop ax
	cmp dx,si
	pop dx
	ja next1
	cmp dl,al
	ja next1
	push ax
	push bx
	push dx
	push si				;保存现场 
	
	push ax
	push si
	mov si,dx
	and si,0000000011111111b
	mov al,[bx+si]
	push ax
	mov ax,0
	mov al,dh
	mov si,ax
	pop ax
	mov ah,[bx+si]
	push dx
	mov dl,ah
	mov dh,0
	mov ah,0
	cmp dx,ax
	pop dx
	ja great			;arr[p] > arr[q]
	pop si
	pop ax
	push ax
	mov al,dh
	mov ah,0
	mov si,ax
	pop ax
	mov dl,[bx+si]		;dl=arr[p]
	mov bx,offset buffer
	mov si,cx
	mov [bx+si],dl
	pop si
	pop dx
	pop bx
	pop ax
	add dh,1
	jmp far ptr next2
great:
	pop si
	pop ax
	mov si,dx
	and si,0000000011111111b
	mov dl,[bx+si]
	mov bx,offset buffer
	mov si,cx
	mov [bx+si],dl
	pop si
	pop dx
	pop bx
	pop ax
	inc dl
next2:
	inc cl
	push cx
	mov cl,2			;not to break loop
	loop again1
next1:
	push cx
again2:
	pop cx
	push dx
	push ax
	mov ax,si
	mov dl,al
	pop ax
	cmp dh,dl			;p=dh,q=dl,start=ah,end=al,mid=si
	pop dx
	ja next3			;p>mid
	push ax
	push bx
	push dx
	push si
	mov al,dh
	mov ah,0
	mov si,ax
	mov dl,[bx+si]		;dl=arr[p]
	mov bx,offset buffer
	mov si,cx
	mov [bx+si],dl
	pop si
	pop dx
	pop bx
	pop ax
	inc cl
	add dh,1
	push cx
	mov cl,2			;not to break loop
	loop again2
next3:
	push cx
again3:
	pop cx
	cmp dl,al			;p=dh,q=dl,start=ah,end=al,mid=si
	ja next4			;q>end
	push ax
	push bx
	push dx
	push si
	mov si,dx
	and si,0000000011111111b
	mov dl,[bx+si]		;dl=arr[q]
	mov bx,offset buffer
	mov si,cx
	mov [bx+si],dl
	pop si
	pop dx
	pop bx
	pop ax
	inc cl
	add dl,1
	push cx
	mov cl,2			;not to break loop
	loop again3
next4:
	push dx
	mov dx,0
	mov dl,ah
	mov cx,dx			;cl=start
	pop dx
	pop bx
	call copyFromBufferToNums
	pop si
	pop dx
	pop bx	
	pop ax
    ret
mergepart endp

; 把buffer中的数据拷贝到bx开始的存储区中
; 参数：bx--基地址,cx--数据个数
copyFromBufferToNums proc
	push cx
again4:
	pop cx
	cmp cl,al			;p=dh,q=dl,start=ah,end=al,mid=si
	ja next5
	push ax
	push bx
	push dx
	push si
	push bx
	mov bx,offset buffer
	mov si,cx
	mov dl,[bx+si]		;dl=arr[p]
	pop bx
	mov [bx+si],dl
	pop si
	pop dx
	pop bx
	pop ax
	inc cx
	push cx
	mov cl,2			;not to break loop
	loop again4
next5:
    ret
copyFromBufferToNums endp

; 把al的数据保存到buffer中
saveToBuffer proc
	push ax
	push bx
	push dx
	push si
	mov si,cx
	mov bx,offset buffer
	mov [bx+si],al
	pop si
	pop dx
	pop bx
	pop ax
	inc cl
    ret
saveToBuffer endp

; 把一组十六进制数据转换为十进制数并显示出来
; 参数：ds:bx --基地址 cx -- 数据个数
showdecs proc near
print:
	mov ax,0
	mov al,[bx+si]
	mov dl,100
	div dl
	mov dl,al
	call showdec
	mov al,ah
	mov ah,0
	mov dl,10
	div dl
	mov dl,al
	call showdec
	mov dl,ah
	call showdec
	mov dl,10
	mov ah,02h       
	int 21h
	inc si
	loop print					;循环输出
	ret
showdecs endp

;把al中的二进制数转换为十进制数并显示出来。
showdec proc near
	push ax
	push bx
	push cx
	push dx
	add dl,'0'
	mov ah,02h       
	int 21h
	pop dx
	pop cx
	pop bx
	pop ax
	ret
showdec endp

code  ends
      end start
