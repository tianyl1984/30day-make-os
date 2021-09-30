TOOLPATH = ../tools/
INCPATH  = ../includes/
RULEFILE = $(INCPATH)haribote.rul
NASK     = $(TOOLPATH)nask
EDIMG    = $(TOOLPATH)edimg
CC1      = $(TOOLPATH)gocc1 -I$(INCPATH) -Os -Wall -quiet 
GAS2NASK = $(TOOLPATH)gas2nask -a
OBJ2BIM  = $(TOOLPATH)obj2bim
BIM2HRB  = $(TOOLPATH)bim2hrb

default :
	make run

ipl.bin : ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst

# haribote.sys : haribote.nas Makefile
# 	$(NASK) haribote.nas haribote.sys haribote.lst

asmhead.bin : asmhead.nas Makefile
	$(NASK) asmhead.nas asmhead.bin asmhead.lst

naskfunc.obj : naskfunc.nas Makefile
	$(NASK) naskfunc.nas naskfunc.obj naskfunc.lst

bootpack.gas : bootpack.c Makefile
	$(CC1) -o bootpack.gas bootpack.c

bootpack.nas : bootpack.gas Makefile
	$(GAS2NASK) bootpack.gas bootpack.nas

bootpack.obj : bootpack.nas Makefile
	$(NASK) bootpack.nas bootpack.obj bootpack.lst

bootpack.bim : bootpack.obj naskfunc.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
		bootpack.obj naskfunc.obj

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

helloos.img : ipl.bin haribote.sys Makefile
	$(EDIMG) imgin:../tools/fdimg0at.tek \
	wbinimg src:./ipl.bin len:512 from:0 to:0 \
	copy from:haribote.sys to:@: \
	imgout:./helloos.img

run : helloos.img
	qemu-system-x86_64 -fda helloos.img

clean :
	-rm -rf ./*.bin
	-rm -rf ./*.sys
	-rm -rf ./*.lst
	-rm -rf ./*.img
	-rm -rf bootpack.nas
	-rm -rf bootpack.gas
	-rm -rf bootpack.obj
	-rm -rf bootpack.map
	-rm -rf bootpack.bim
	-rm -rf bootpack.hrb
	-rm -rf haribote.sys
	-rm -rf naskfunc.obj

