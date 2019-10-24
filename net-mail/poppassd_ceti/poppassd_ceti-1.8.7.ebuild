# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam

# Long ago it was just "poppassd", but upstream now seems to have
# settled on "poppassd-ceti" (instead of "poppassd_ceti" or no suffix).
MY_PN="poppassd-ceti"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Password change daemon with PAM support"
HOMEPAGE="https://github.com/kravietz/poppassd-ceti"
SRC_URI="https://github.com/kravietz/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

src_install() {
	dodoc README.md
	dodoc "${FILESDIR}/README.gentoo"

	pamd_mimic_system poppassd auth account password

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/poppassd.xinetd poppassd

	exeinto /usr/sbin
	exeopts -o root -g bin -m 500
	doexe poppassd
}
