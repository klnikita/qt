# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="3"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python

DESCRIPTION="A full featured Python IDE using PyQt4 and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"

SLOT="5"
MY_PN="${PN}${SLOT}"
MY_P="${MY_PN}-${PV}"

SRC_URI="mirror://sourceforge/eric-ide/${MY_PN}/stable/${PV}/${MY_P}.tar.gz"
LICENSE="GPL-3"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="spell"

DEPEND=">=dev-python/PyQt4-4.7.0[assistant,svg,webkit,X]
	>=dev-python/qscintilla-python-2.4.0"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.0.1
	>=dev-python/pygments-1.1.1
	>=dev-python/coverage-3.2"
PDEPEND="spell? ( dev-python/pyenchant )"
RESTRICT_PYTHON_ABIS="2.*"

LANGS="cs de es it ru"
for L in ${LANGS}; do
	SRC_URI="${SRC_URI}
		linguas_${L}? ( mirror://sourceforge/eric-ide/${MY_PN}/stable/${PV}/${MY_PN}-i18n-${L/zh_CN/zh_CN.GB2312}-${PV}.tar.gz )"
	IUSE="${IUSE} linguas_${L}"
done
unset L

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-5.0_no_interactive.patch"
	epatch "${FILESDIR}/${PN}-5.0_remove_coverage.patch"
	epatch "${FILESDIR}/${PN}-5.0_sandbox.patch"

	# Append ${SLOT} to the icon name to avoid file collisions
	sed -i -e "s/^Icon=eric$/&${SLOT}/" eric/eric${SLOT}.desktop || die

	# Delete internal copies of dev-python/chardet,
	# dev-python/coverage and dev-python/pygments
	rm -fr eric/ThirdParty
	rm -fr eric/DebugClients/Python{,3}/coverage
}

src_install() {
	installation() {
		"$(PYTHON)" install.py \
			-z \
			-b "${EPREFIX}/usr/bin" \
			-i "${D}" \
			-d "${EPREFIX}$(python_get_sitedir)" \
			-c
	}
	python_execute_function installation

	newicon eric/icons/default/eric.png eric${SLOT}.png || die
	domenu eric/eric${SLOT}.desktop || die
}

pkg_postinst() {
	python_mod_optimize eric${SLOT}{,config.py,plugins}

	elog
	elog "If you want to use Eric with mod_python, have a look at"
	elog "\"${EROOT%/}$(python_get_sitedir -f)/eric${SLOT}/patch_modpython.py\"."
	elog
	elog "The following packages will give Eric extended functionality:"
	elog "  dev-python/pylint"
	elog "  dev-python/pysvn"
	elog
	elog "This version has a plugin interface with plugin-autofetch from"
	elog "the application itself. You may want to check those as well."
	elog
}

pkg_postrm() {
	python_mod_cleanup eric${SLOT}{,config.py,plugins}
}