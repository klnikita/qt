# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/minitube/minitube-1.9.ebuild,v 1.2 2012/11/17 19:17:31 hwoarang Exp $

EAPI=4
PLOCALES="ar ca ca_ES da de_DE el en es es_AR es_ES fi fi_FI fr gl he_IL hr hu
ia id it jv ka_GE nb nl nn pl pl_PL pt pt_BR ro ru sk sl sq sr sv_SE tr uk_UA
zh_CN"

EGIT_REPO_URI="git://gitorious.org/minitube/minitube.git"
inherit l10n qt4-r2 git-2

DESCRIPTION="Qt4 YouTube Client"
HOMEPAGE="http://flavio.tordini.org/minitube"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug gstreamer kde"

DEPEND=">=dev-qt/qtgui-4.6:4[accessibility]
	>=dev-qt/qtdbus-4.6:4
	kde? ( || ( media-libs/phonon[gstreamer?] >=dev-qt/qtphonon-4.6:4 ) )
	!kde? ( || ( >=dev-qt/qtphonon-4.6:4 media-libs/phonon[gstreamer?] ) )
	gstreamer? (
		media-plugins/gst-plugins-soup
		media-plugins/gst-plugins-ffmpeg
		media-plugins/gst-plugins-faac
		media-plugins/gst-plugins-faad
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

DOCS="AUTHORS CHANGES TODO"

src_prepare() {
	qt4-r2_src_prepare

	# Remove unneeded translations
	local trans=
	for x in $(l10n_get_locales); do
		trans+="${x}.ts "
	done
	if [[ -n ${trans} ]]; then
		sed -i -e "/^TRANSLATIONS/s/+=.*/+=${trans}/" locale/locale.pri || die
	fi
	# gcc-4.7. Bug #422977
	epatch "${FILESDIR}"/${PN}-1.9-gcc47.patch
}

src_install() {
	qt4-r2_src_install
	newicon images/app.png minitube.png
}
