# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qscintilla/qscintilla-2.6.2.ebuild,v 1.1 2012/06/27 13:31:54 pesa Exp $

EAPI=4

inherit qt4-r2

HG_REVISION="4e0cb0250dad"

MY_P=QScintilla-gpl-snapshot-${PV/_pre*/-${HG_REVISION}}

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://gentoo-el.org/~hwoarang/distfiles/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc python"

DEPEND="
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
"
RDEPEND="${DEPEND}"
PDEPEND="python? ( ~dev-python/qscintilla-python-${PV} )"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PN}-2.6.2-designer.patch"
)

src_configure() {
	pushd Qt4Qt5 > /dev/null
	einfo "Configuration of qscintilla"
	eqmake4 qscintilla.pro
	popd > /dev/null

	pushd designer-Qt4 > /dev/null
	einfo "Configuration of designer plugin"
	eqmake4 designer.pro
	popd > /dev/null
}

src_compile() {
	pushd Qt4Qt5 > /dev/null
	einfo "Building of qscintilla"
	emake
	popd > /dev/null

	pushd designer-Qt4 > /dev/null
	einfo "Building of designer plugin"
	emake
	popd > /dev/null
}

src_install() {
	pushd Qt4Qt5 > /dev/null
	einfo "Installation of qscintilla"
	emake INSTALL_ROOT="${D}" install
	popd > /dev/null

	pushd designer-Qt4 > /dev/null
	einfo "Installation of designer plugin"
	emake INSTALL_ROOT="${D}" install
	popd > /dev/null

	dodoc NEWS

	if use doc; then
		dohtml doc/html-Qt4Qt5/*
		insinto /usr/share/doc/${PF}
		doins -r doc/Scintilla
	fi
}
