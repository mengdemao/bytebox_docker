FROM archlinux
RUN mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
RUN pacman --noconfirm  -Syu &&	      \
	pacman -S --need --noconfirm  \
	gcc			      \
	clang			      \
	llvm			      \
	vim			      \
	grep			      \
	sed			      \
	gawk			      \
	uboot-tools		      \
	autoconf		      \
	automake		      \
	bison			      \
	bzip2			      \
	flex			      \
	git			      \
	gperf			      \
	make			      \
	python			      \
	texinfo			      \
	unrar			      \
	unzip			      \
	wget			      \
	sudo			      \
	cmake			      \
	scons			      \
	doxygen			      \
	hugo

RUN useradd -m -s /bin/bash bytebox && passwd -d bytebox
RUN mkdir -p /bytebox && cd / && chown -R bytebox /bytebox
RUN mkdir -p /compiler && cd /compiler && mkdir
USER bytebox
WORKDIR /bytebox

COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

#ENTRYPOINT ["./entrypoint.sh"]
