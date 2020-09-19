FROM archlinux
ARG COMPILER_VERSION_MAJOR=7
ARG COMPILER_VERSION_MINOR=5
ARG COMPILER_VERSION_PATCH=0
ARG COMPILER_BUILD_YEAR=2019
ARG COMPILER_BUILD_MON=12
ARG COMPILER_BUILD_DAY=0

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
	tar			      \
	sudo			      \
	pacman			      \
	go			      \
	rust			      \
	base-devel		      \
	zsh			      \
	neofetch		      \
	python-virtualenv	      \
	python-pip				\
	help2man				\
	lzip					\
	axel

USER root
RUN useradd -m -s /bin/bash bytebox &&\
	passwd -d bytebox &&\
	echo "bytebox      ALL = NOPASSWD: ALL" >> /etc/sudoers &&\
	sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf &&\
	sed -i "s,PKGEXT='.pkg.tar.xz',PKGEXT='.pkg.tar',g" /etc/makepkg.conf

RUN mkdir -p /compiler && cd /compiler &&\
	axel https://releases.linaro.org/components/toolchain/binaries/${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}/arm-linux-gnueabihf/gcc-linaro-${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}.${COMPILER_VERSION_PATCH}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}-x86_64_arm-linux-gnueabihf.tar.xz 2>&1 >/dev/null &&\
	tar -xf gcc-linaro-${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}.${COMPILER_VERSION_PATCH}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}-x86_64_arm-linux-gnueabihf.tar.xz -C /compiler &&\
	axel https://releases.linaro.org/components/toolchain/binaries/${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}/arm-linux-gnueabi/gcc-linaro-${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}.${COMPILER_VERSION_PATCH}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}-x86_64_arm-linux-gnueabi.tar.xz 2>&1 >/dev/null &&\
	tar -xf gcc-linaro-${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}.${COMPILER_VERSION_PATCH}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}-x86_64_arm-linux-gnueabi.tar.xz -C /compiler &&\
	cd /compiler && git clone https://github.com/cisco/ChezScheme.git && cd ChezScheme && ./configure --disable-x11 --disable-curses && make && make install &&\
	sudo echo ". /bytebox/esp-idf/export.sh" >> /etc/profile &&\
	sudo echo "export PATH=$PATH:/compiler/gcc-linaro-${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}.${COMPILER_VERSION_PATCH}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}-x86_64_arm-linux-gnueabi/bin:/compiler/gcc-linaro-${COMPILER_VERSION_MAJOR}.${COMPILER_VERSION_MINOR}.${COMPILER_VERSION_PATCH}-${COMPILER_BUILD_YEAR}.${COMPILER_BUILD_MON}-x86_64_arm-linux-gnueabihf/bin" >> /etc/profile &&\
	mkdir -p /bytebox && cd / && chown -R bytebox:bytebox /bytebox

USER bytebox
WORKDIR /bytebox
RUN cd /bytebox &&\
	git clone https://aur.archlinux.org/yay.git &&\
	pushd yay &&\
	makepkg --noconfirm -si &&\
	popd &&\
	rm -rf yay &&\
	cd /bytebox && git clone --recursive https://github.com/espressif/esp-idf.git && cd esp-idf/ && ./install.sh

RUN	git clone https://github.com/crosstool-ng/crosstool-ng &&\
	pushd crosstool-ng &&\
	./bootstrap &&\
	./configure &&\
	make &&\
	sudo make install &&\	
	popd &&\
	rm -rf crosstool-ng &&\
	ct-ng arm-cortexa9_neon-linux-gnueabihf &&\
	ct-ng build

VOLUME /playground

COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

ENTRYPOINT ["./entrypoint.sh"]
