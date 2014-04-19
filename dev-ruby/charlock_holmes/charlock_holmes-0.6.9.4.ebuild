# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Character encoding detecting library for Ruby using ICU"
HOMEPAGE="http://github.com/brianmario/charlock_holmes"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rake-compiler
	dev-ruby/minitest )"

RUBY_PATCHES=( "${FILESDIR}"/${P}-extconf.patch )

CDEPEND="dev-libs/icu
		sys-apps/file
		sys-libs/zlib"
DEPEND+=" ${CDEPEND}"
RDEPEND+=" ${CDEPEND}"

all_ruby_prepare() {
	sed -i -e '/bundler/d' test/helper.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die
}

each_ruby_compile() {
		emake V=1 -Cext/${PN}
		cp ext/${PN}/${PN}$(get_modname) lib/${PN}/ || die
		}

each_ruby_test() {
	${RUBY} -Ilib test/*.rb || die
}
