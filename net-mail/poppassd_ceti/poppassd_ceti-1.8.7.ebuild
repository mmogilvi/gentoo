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

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/doc-sudoAlternative-1.8.7.patch"
)

src_install() {
	dodoc README.md

	pamd_mimic_system poppassd auth account password

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/poppassd.xinetd poppassd

	insinto /usr/sbin
	insopts -o root -g bin -m 500
	doins poppassd
}

pkg_postinst() {
	elog "/usr/sbin/poppassd has to be run as root to work."
	elog "Most commonly a font end would use sys-apps/xinetd and connect"
	elog "to port 106: For this, edit /etc/xinetd.d/poppassd,"
	elog "install sys-apps/xinetd, and start the xinetd service."
	elog "   Alternatively, the front end may be able to run it"
	elog "directly (if already root), or might use app-admin/sudo."
	elog "   See also /usr/share/doc/${PF}/README.md.bz2"
}
