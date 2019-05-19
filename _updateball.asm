; (_updateball.asm)

include Pong.inc

.code
UpdateBall proc,
	xCoordBall: ptr dword,
	yCoordBall: ptr dword,
	xRun: ptr dword,
	yRise: ptr dword,
	space: ptr byte,
	boardTopOffset: dword,
	boardHeight: dword
	
	; xCoordBall - the current absolute x coordinate of the ball 
	; yCoordBall - the current absolute y coordinate of the ball
	; xRun - the x (horizontal) component of the ball's velocity
	; yRise - the y (vertical) component of the ball's velocity
		; note : a positive yRise value translates to downward motiuon of the ball on the consoloe and vice-versa
	
	; save the state of the registers from the time of the function call
	pushad

    ; check whether the ball is touching either frame
    ; bottom frame
	mov eax, [yCoordBall]
	mov ebx, boardTopOffset
	add ebx, boardHeight
    dec ebx
	cmp [eax], ebx
	jb NotTouchingBottom
	mov eax, [yRise]
	neg dword ptr [eax]
	
NotTouchingBottom:
	; top frame
    mov eax, [yCoordBall]
	mov ebx, boardTopOffset
	inc ebx
	cmp [eax], ebx
	ja NotTouchingTop
	mov eax, [yRise]
	neg dword ptr [eax]
	
NotTouchingTop:
	
	
	
	; update the x- and y-coordinates of the ball
	; x
	mov eax, [xRun]
    mov ebx, [eax]
    mov eax, [xCoordBall]
    add ebx, [eax]
	mov [eax], ebx
	; y
	mov eax, [yRise]
	mov ebx, [eax]
	mov eax, [yCoordBall]
	add ebx, [eax]
	mov [eax], ebx
	
	; Gotoxy moves the cursor to the point whose x-value is in dl and whose y-value is in dh
	mov ebx, [xCoordBall]
	mov dl, byte ptr [ebx]
	mov ebx, [yCoordBall]
	mov dh, byte ptr [ebx]
	call Gotoxy
	
	; change the fill color to white to represent the ball with a white-filled space
	mov eax, white * 16
	call SetTextColor
	
	; print a space character to print the ball as a white space
	mov edx, space
	call WriteString
	
	; now set the text background color back to black like a friend
	mov eax, black * 16
	call SetTextColor

    ; now erase the ball's shadow from its previous location
    ; go to the ball's previous position
	; set x-coordinate back to its original value
    mov eax, [xCoordBall]
    mov ebx, [eax]
    mov eax, [xRun]
	sub ebx, [eax]
    ; now store the (original) x-coordinate value in xCoordBall
    mov eax, [xCoordBall]
    mov [eax], ebx

	; set y-coordinate back to its original value
    mov eax, [yCoordBall]
	mov ebx, [eax]
	mov eax, [yRise]
	sub ebx, [eax]
	mov eax, [yCoordBall]
    mov [eax], ebx

    ; Gotoxy moves the cursor to the point whose x-value is in dl and whose y-value is in dh
    mov ebx, [xCoordBall]
	mov dl, [ebx]
	mov ebx, [yCoordBall]
	mov dh, [ebx]
	call Gotoxy
	
	; now print a space with a black background to remove the ball's shadow
	mov edx, space
	call WriteString
	
	; now re-update xCoordBall and yCoordBall with their new values
	; x
	mov eax, [xRun]
    mov ebx, [eax]
    mov eax, [xCoordBall]
    add ebx, [eax]
	mov [eax], ebx
	; y
	mov eax, [yRise]
	mov ebx, [eax]
	mov eax, [yCoordBall]
	add ebx, [eax]
	mov [eax], ebx
	
    ; move the cursor back to 0 to get it out of the gamespace
    mov edx, 0
    call Gotoxy

	; restore the state of the registers from the time of the function call
	popad
	ret

UpdateBall endp
end
	
	