org 0x7C00

%define len 0x10;len = 10

mov bx, buffer  ;bx = &buffer
get_loop:       ;do {
  mov ah, 0x00  ;ah = 0x00
  int 0x16      ;al = get_input()
  mov [bx], al  ;*bx = al
  inc bx        ;bx += 1
  cmp bx, buffer + len
  jne get_loop  ;}while(bx == &buffer + len)

mov ah, 0x0E    ;ah = 0x0E
mov bx, buffer  ;bx = &buffer
print_loop:     ;while(true){
  mov al, [bx]  ;al = *bx
  int 0x10      ;print(al)
  cmp bx, buffer + len
  je exit       ;if(bx == &buffer + len) break
  inc bx        ;bx += 1
  jmp print_loop;}

exit:
  jmp $ ;while(true){}

buffer:
  times len db 0;char buffer[len] = [0; len]

times 510-($-$$) db 0
db 0x55, 0xAA
