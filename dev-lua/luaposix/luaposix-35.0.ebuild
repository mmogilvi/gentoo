# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bindings for POSIX APIs"
HOMEPAGE="https://luaposix.github.io/luaposix/ https://github.com/luaposix/luaposix"
SRC_URI="https://github.com/luaposix/luaposix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-lang/lua:0="
RDEPEND="${DEPEND}
	dev-lua/lua-bit32"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	# Temporary fix for respect LDFLAGS (#739050)
	# Fixed in luke 0.2.1
	sed -i -e "s:c_module,libdirs:c_module,'\$LDFLAGS',libdirs:g" \
		build-aux/luke || die
}

src_compile() {
	./build-aux/luke package="${PN}" version="${PV}" \
		PREFIX="${ED}/usr" \
		INST_LIBDIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)" \
		INST_LUADIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
	./build-aux/luke install \
		PREFIX="${ED}/usr" \
		INST_LIBDIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)" \
		INST_LUADIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" \
		|| die
	dodoc -r doc NEWS.md README.md
}
