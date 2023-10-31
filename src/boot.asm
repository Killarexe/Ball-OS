org 0x7C00

%define ball_size 2

mov ah, 0x0E
mov bx, welcome_message
print_loop:
  mov al, [bx]
  int 0x10
  inc bx
  cmp al, 0
  jne print_loop

mov ah, 0x00
int 0x16

mov ax, 0x0004
int 0x10      ;set_video_mode(0x04) more info at: https://www.minuszerodegrees.net/video/bios_video_modes.htm

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
color: db 0x0F
welcome_message:
  db "Press any key to continue!", 0x00

times 510-($-$$) db 0
db 0x55, 0xAA
