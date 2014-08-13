# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libinfinity/libinfinity-0.5.4.ebuild,v 1.2 2014/08/10 20:49:20 slyfox Exp $

EAPI=5

inherit autotools-utils eutils versionator user

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="An implementation of the Infinote protocol written in GObject-based C"
HOMEPAGE="http://gobby.0x539.de/"
COMMIT_ID="b96eef880fe8a98d551c46607a05675ed20ef40e"
SRC_URI="https://github.com/gobby/libinfinity/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi doc gtk server static-libs"

S=${WORKDIR}/${PN}-${COMMIT_ID}

RDEPEND="dev-libs/glib:2
	dev-libs/libxml2
	net-libs/gnutls
	sys-libs/pam
	virtual/gsasl
	avahi? ( net-dns/avahi )
	gtk? ( x11-libs/gtk+:3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	dev-util/gtk-doc"

DOCS=(AUTHORS NEWS README.md TODO)

pkg_setup() {
	if use server ; then
		enewgroup infinote 100
		enewuser infinote 100 /bin/bash /var/lib/infinote infinote
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc gtk-doc)
		$(use_with gtk inftextgtk)
		$(use_with gtk infgtk)
		$(use_with gtk gtk3)
		$(use_with server infinoted)
		$(use_with avahi)
		$(use_with avahi libdaemon)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use server ; then
		newinitd "${FILESDIR}/infinoted.initd" infinoted
		newconfd "${FILESDIR}/infinoted.confd" infinoted

		keepdir /var/lib/infinote
		fowners infinote:infinote /var/lib/infinote
		fperms 770 /var/lib/infinote

		dosym /usr/bin/infinoted-${MY_PV} /usr/bin/infinoted

		elog "Add local users who should have local access to the documents"
		elog "created by infinoted to the infinote group."
		elog "The documents are saved in /var/lib/infinote per default."
	fi
}
