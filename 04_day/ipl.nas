; hello-os
; TAB=4
CYLS    EQU     10              ; 定义值
        ORG     0x7c00          ; 指明程序装载地址

; 标准FAT12格式软盘专用的代码 Stand FAT12 format floppy code

        JMP     entry
        DB      0x90
        DB      "HELLOIPL"      ; 启动扇区名称（8字节）
        DW      512             ; 每个扇区（sector）大小（必须512字节）
        DB      1               ; 簇（cluster）大小（必须为1个扇区）
        DW      1               ; FAT起始位置（一般为第一个扇区）
        DB      2               ; FAT个数（必须为2）
        DW      224             ; 根目录大小（一般为224项）
        DW      2880            ; 该磁盘大小（必须为2880扇区1440*1024/512）
        DB      0xf0            ; 磁盘类型（必须为0xf0）
        DW      9               ; FAT的长度（必??9扇区）
        DW      18              ; 一个磁道（track）有几个扇区（必须为18）
        DW      2               ; 磁头数（必??2）
        DD      0               ; 不使用分区，必须是0
        DD      2880            ; 重写一次磁盘大小
        DB      0,0,0x29        ; 意义不明（固定）
        DD      0xffffffff      ; （可能是）卷标号码
        DB      "HELLO-OS   "   ; 磁盘的名称（必须为11字?，不足填空格）
        DB      "FAT12   "      ; 磁盘格式名称（必??8字?，不足填空格）
        RESB    18              ; 先空出18字节

; 程序主体

entry:
        MOV     AX,0            ; 初始化寄存器
        MOV     SS,AX
        MOV     SP,0x7c00
        MOV     DS,AX

;读取磁盘数据到内存
        MOV             AX,0x0820
        MOV             ES,AX
        MOV             CH,0                    ; 柱面0
        MOV             DH,0                    ; 磁头0
        MOV             CL,2                    ; 扇区2
readloop:
        MOV             SI,0                    ; 执行次数
retry:
        MOV             AH,0x02                 ; 读入磁盘
        MOV             AL,1                    ; 1个扇区
        MOV             BX,0
        MOV             DL,0x00                 ; A驱动器
        INT             0x13                    ; 调用bios方法
        JNC             next                    ; 成功则继续读
        ADD             SI,1                    ; 执行次数+1
        CMP             SI,5                    ;
        JAE             error                   ;SI>5,跳转 error
        MOV             AH,0x00
        MOV             DL,0x00
        INT             0x13                    ;重置驱动器
        JMP             retry
next:
        MOV             AX,ES
        ADD             AX,0x0020
        MOV             ES,AX                   ;内存后移
        ADD             CL,1
        CMP             CL,18                   ;
        JBE             readloop                ;CL <= 18 读到18扇区
        MOV             CL,1
        ADD             DH,1
        CMP             DH,2
        JB              readloop                ;DH < 2 继续读
        MOV             DH,0
        ADD             CH,1
        CMP             CH,CYLS
        JB              readloop

        JMP             0xc200                  ;执行 start.sys

putloop:
        MOV     AL,[SI]
        ADD     SI,1            ; 给SI加1
        CMP     AL,0
        JE      fin
        MOV     AH,0x0e         ; 显示一个文字
        MOV     BX,15           ; 指定字符颜色
        INT     0x10            ; 调用显卡BIOS
        JMP     putloop
fin:
        HLT                     ; 让CPU停止，等待指令
        JMP     fin    ; 无限循环
error:
        MOV             SI,msg
msg:
        DB      0x0a, 0x0a      ; 换行两次
        DB      "load error 1"
        DB      0x0a            ; 换行
        DB      0
        RESB    0x7dfe-$        ; 填写0x00直到0x001fe
        DB      0x55, 0xaa

