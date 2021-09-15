# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

SLOT=0

SRC_URI="https://download.jetbrains.com/toolbox/${P}.tar.gz"
DESCRIPTION="Toolbox App by JetBrains"
HOMEPAGE="https://www.jetbrains.com/toolbox-app/"

# JetBrains supports officially only x86_64 even though some 32bit binaries are
# provided. See https://www.jetbrains.com/toolbox-app/#section=linux
KEYWORDS="~amd64"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CDDL-1.1
        codehaus-classworlds CPL-1.0 EPL-1.0 EPL-2.0
        GPL-2 GPL-2-with-classpath-exception ISC
        JDOM LGPL-2.1 LGPL-2.1+ LGPL-3-with-linking-exception MIT
        MPL-1.0 MPL-1.1 OFL ZLIB"

DEPEND="
        || (
                >=dev-java/openjdk-11.0.11_p9-r1:11
                >=dev-java/openjdk-bin-11.0.11_p9-r1:11
        )"

RDEPEND="${DEPEND}
        virtual/jdk
        dev-lang/go
        dev-lang/python
        dev-lang/ruby
        dev-java/jansi-native
        dev-libs/libdbusmenu
        media-libs/harfbuzz
        =dev-util/lldb-10*
"

RESTRICT="bindist mirror"
S="${WORKDIR}/${P}"

QA_PREBUILT="opt/${P}/*"

# src_unpack() {
# 	default_src_unpack
# 	unpack ${P}.tar.gz
# }

src_compile() {
	./"${PN}" --appimage-extract
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
    doins jetbrains-toolbox
	fperms +x /opt/jetbrains-toolbox/jetbrains-toolbox

	make_wrapper "${PN}" "${dir}/jetbrains-toolbox"
	#newicon "squashfs-root/${PN}.svg" "${PN}.svg"
	#make_desktop_entry "${PN}" "goland" "${PN}" "Development;IDE;"
	insinto /usr/share/applications
	doins "squashfs-root/${PN}.desktop"

}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
