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
	tar

RUN useradd -m -s /bin/bash bytebox && passwd -d bytebox
RUN mkdir -p /bytebox && cd / && chown -R bytebox /bytebox
RUN mkdir -p /compiler && cd /compiler &&\
	wget https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz &&\
	tar -vxf gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz -C /compiler &&\
	wget https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabi/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi.tar.xz &&\
	tar -vxf gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi.tar.xz -C /compiler &&\
	chown -R bytebox /compiler
ENV path=$PATH:/compiler/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin:/compiler/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin

USER bytebox
WORKDIR /bytebox
VOLUME /playground

COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

ENTRYPOINT ["./entrypoint.sh"]
