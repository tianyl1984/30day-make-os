; haribote-os
; TAB=4
;BIOS信息
CYLS    EQU             0x0ff0                  ; 启动区
LEDS    EQU             0x0ff1
VMODE   EQU             0x0ff2                  ; 颜色数目
SCRNX   EQU             0x0ff4                  ; 像素x
SCRNY   EQU             0x0ff6                  ; 像素y
VRAM    EQU             0x0ff8                  ; 显卡内存地址

        ORG     0xc200          ;
        MOV     AL,0x13         ; 320x200x8位彩色
        MOV     AH,0x00
        INT     0x10

        MOV             BYTE [VMODE],8  ; 画面モードをメモする
        MOV             WORD [SCRNX],320
        MOV             WORD [SCRNY],200
        MOV             DWORD [VRAM],0x000a0000

        MOV             AH,0x02
        INT             0x16                    ; keyboard BIOS
        MOV             [LEDS],AL

        MOV     AL,65
        MOV     AH,0x0e         ; 显示一个文字
        MOV     BX,15           ; 指定字符颜色
        INT     0x10            ; 调用显卡BIOS

fin:
        HLT                     ; 让CPU停止，等待指令
        JMP     fin    ; 无限循环