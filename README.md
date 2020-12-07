# 30day-make-os

mac上测试

模拟器，安装qemu

`brew install qemu`

编译器，安装nasm

`brew install nasm`

nask和NASM代码对比,来源 https://blog.csdn.net/FIREDOM/article/details/18968109

```
nask代码              NASM代码

JMP entry          ->   JMP SHORT entry

RESB <填充字节数>    ->   TIMES <填充字节数> DB <填充数据>

RESB 0x7dfe-$      ->   TIMES 0x1fe-($-$$) DB 0

ALIGNB 16          ->   ALIGN 16, DB 0
```

使用 `ORG   0x7c00` 代表程序从7c00装载,所以 `RESB 0x7dfe-$` 改为 `TIMES 0x1fe-($-$$) DB 0`

$ 是当前位置 $$ 是段开始位置 $ - $$ 是当前位置在段内的偏移

启动模拟器，加载镜像

`qemu-system-x86_64 -m 32 -hda aaa.img`

修改文件

`0x1fe-$` 修改为 `0x1fe-($-$$)`

mac版、linux版tools下载地址

`https://github.com/yourtion/YOS`


