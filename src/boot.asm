org 0x7C00

%define ball_size 2

mov bx, welcome_message

mov ah, 0x0E
print_loop:     ;do{
  mov al, [bx] 
  int 0x10        ;printc(*bx);
  inc bx          ;bx++,
  cmp al, 0x00
  jne print_loop;}while(*bx =!= 0x00);

mov ah, 0x00
int 0x16

mov ax, 0x0004
int 0x10      ;set_video_mode(0x04) more info at: https://www.minuszerodegrees.net/video/bios_video_modes.htm

mov bx, 320
call random
mov bx, [random_number]
mov [ball_x], bx

mov bx, 200
call random
mov bx, [random_number]
mov [ball_y], bx

loop:
  mov al, 0x00
  call render_ball
  call update_ball
  mov al, 0x0F
  call render_ball
  mov al, 0x00
  wait_loop:
    int 0x08
    inc al
    cmp al, 100
    jne wait_loop
  jmp loop

random:
  mov ah, 0x00
  int 0x1A    ;Get system time and return on cx and dx.

  mov ax, dx
  xor dx, dx
  div bx

  mov [random_number], dx
  ret

update_ball:
  mov ax, [ball_x]
  mov cx, [ball_velocity_x]
  add ax, cx
  mov [ball_x], ax

  mov bx, [ball_y]
  mov dx, [ball_velocity_y]
  add bx, dx
  mov [ball_y], bx

  cmp ax, 320
  je inv_vel_x
  cmp ax, 0
  je inv_vel_x
  continue:
    cmp bx, 200
    je inv_vel_y
    cmp bx, 0
    je inv_vel_y
    ret
  inv_vel_x:
    neg cx
    mov [ball_velocity_x], cx
    jmp continue
  inv_vel_y:
    neg dx
    mov [ball_velocity_y], dx
    ret

render_ball:
  mov ah, 0x0C
  mov bh, 0x00
  mov cx, [ball_x]
  mov dx, [ball_y]
  int 0x10
  ret

ball_x: dw 0x0000
ball_y: dw 0x0000
ball_velocity_x: dw 0x0001
ball_velocity_y: dw 0x0001
random_number: dw 0x0000
color: db 0x0F
welcome_message:
  db "Press any key to continue!", 0x00

times 510-($-$$) db 0
db 0x55, 0xAA
