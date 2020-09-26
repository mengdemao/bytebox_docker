FROM archlinux
ARG COMPILER_VERSION_MAJOR=7
ARG COMPILER_VERSION_MINOR=5
ARG COMPILER_VERSION_PATCH=0
ARG COMPILER_BUILD_YEAR=2019
ARG COMPILER_BUILD_MON=12
ARG COMPILER_BUILD_DAY=0

RUN pacman --noconfirm  -Syu &&			\
	pacman -S --need --noconfirm		\
	clang								\
	llvm								\
	vim									\
	grep								\
	sed									\
	gawk								\
	uboot-tools							\
	autoconf							\
	automake							\
	bison								\
	bzip2								\
	flex								\
	git									\
	gperf								\
	make								\
	python								\
	texinfo								\
	unrar								\
	unzip								\
	wget								\
	sudo								\
	cmake								\
	scons								\
	doxygen								\
	hugo								\
	tar									\
	sudo								\
	pacman								\
	go									\
	rust								\
	base-devel							\
	zsh									\
	neofetch							\
	python-virtualenv					\
	python-pip							\
	help2man							\
	lzip								\
	axel								\
	rsync

USER root
RUN useradd -m -s /bin/bash bytebox &&\
	passwd -d bytebox &&\
	echo "bytebox      ALL = NOPASSWD: ALL" >> /etc/sudoers &&\
	sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf &&\
	sed -i "s,PKGEXT='.pkg.tar.xz',PKGEXT='.pkg.tar',g" /etc/makepkg.conf

RUN mkdir -p /compiler && cd /compiler &&\
	mkdir -p /bytebox && cd / && chown -R bytebox:bytebox /bytebox

USER bytebox
WORKDIR /bytebox
RUN cd /bytebox &&\
	git clone https://aur.archlinux.org/yay.git &&\
	pushd yay &&\
	makepkg --noconfirm -si &&\
	popd &&\
	rm -rf yay

VOLUME /playground

COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

ENTRYPOINT ["./entrypoint.sh"]
