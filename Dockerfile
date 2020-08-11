FROM archlinux
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
	hugo			      \
	tar					  \
	sudo				  \
	pacman				  \
	go					  \
	rust

RUN useradd -m -s /bin/bash bytebox &&\
	passwd -d bytebox &&\
	echo "bytebox      ALL = NOPASSWD: ALL" >> /etc/sudoers &&\
	sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf &&\
	sed -i "s,PKGEXT='.pkg.tar.xz',PKGEXT='.pkg.tar',g" /etc/makepkg.conf

USER bytebox
RUN mkdir -p /bytebox && cd / && chown -R bytebox:bytebox /bytebox
WORKDIR /bytebox

RUN mkdir -p /compiler && cd /compiler &&\
	wget https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz &&\
	tar -vxf gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz -C /compiler &&\
	wget https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabi/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi.tar.xz &&\
	tar -vxf gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi.tar.xz -C /compiler &&\
	chown -R bytebox /compiler
ENV path=$PATH:/compiler/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin:/compiler/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin

RUN cd /compiler && git clone https://github.com/cisco/ChezScheme.git && cd ChezScheme && ./configure --disable-x11 --disable-curses && make &&make install

RUN su bytebox -c 'cd /bytebox; git clone https://aur.archlinux.org/yay.git' &&\
	su bytebox -c 'cd /bytebox; cd yay; makepkg' &&\
	pushd /bytebox/yay/ &&\
	pacman -U *.pkg.tar --noprogressbar --noconfirm &&\
	popd &&\
	rm -rf /bytebox/yay

su bytebox -c 'yay -Syyu --noprogressbar --noconfirm --needed'

VOLUME /playground

COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

ENTRYPOINT ["./entrypoint.sh"]
