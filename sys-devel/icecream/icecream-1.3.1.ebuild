# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

MY_P="icecc-${PV}"
DESCRIPTION="Distributed compiling of C(++) code across several machines; based on distcc"
HOMEPAGE="https://github.com/icecc/icecream"
SRC_URI="https://github.com/icecc/icecream/releases/download/${PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"

DEPEND="
	sys-libs/libcap-ng
	dev-libs/lzo
	app-arch/libarchive
	"
RDEPEND="
	${DEPEND}
    acct-group/icecream
    acct-user/icecream
"
BDEPEND=""

src_install()
{
	default
	systemd_dounit "${FILESDIR}"/icecc{d,-scheduler}.service
}

pkg_prerm() {
    if [[ -z ${REPLACED_BY_VERSION} && ${ROOT} == / ]]; then
        eselect compiler-shadow remove icecc
    fi
}

pkg_postinst() {
    if [[ ${ROOT} == / ]]; then
        eselect compiler-shadow update icecc
    fi
}

