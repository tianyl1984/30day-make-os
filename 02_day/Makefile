
default :
	make run

ipl.bin : ipl.nas Makefile
	nasm ipl.nas -o ipl.bin -l ipl.lst

helloos.img : ipl.bin Makefile
	../tools/edimg imgin:../tools/fdimg0at.tek \
	wbinimg src:./ipl.bin len:512 from:0 to:0 \
	imgout:./helloos.img

run : helloos.img
	qemu-system-x86_64 helloos.img

clean :
	-rm -rf ./ipl.bin
	-rm -rf ./ipl.lst
	-rm -rf ./helloos.img

