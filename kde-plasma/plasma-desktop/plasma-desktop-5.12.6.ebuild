# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE Plasma desktop"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="appstream +fontconfig ibus +mouse pulseaudio scim +semantic-desktop touchpad"

COMMON_DEPEND="
	$(add_frameworks_dep attica)
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kactivities-stats)
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kded)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpeople)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep solid)
	$(add_frameworks_dep sonnet)
	$(add_plasma_dep kwin)
	$(add_plasma_dep plasma-workspace)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	media-libs/phonon[qt5(+)]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/libxkbfile
	appstream? ( dev-libs/appstream[qt5] )
	fontconfig? (
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/libXft
		x11-libs/xcb-util-image
	)
	ibus? (
		$(add_qt_dep qtx11extras)
		app-i18n/ibus
		dev-libs/glib:2
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libcanberra
		media-sound/pulseaudio
	)
	scim? ( app-i18n/scim )
	semantic-desktop? ( $(add_frameworks_dep baloo) )
	touchpad? ( x11-drivers/xf86-input-synaptics )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	x11-base/xorg-proto
	fontconfig? ( x11-libs/libXrender )
	mouse? (
		x11-drivers/xf86-input-evdev
		x11-drivers/xf86-input-libinput
	)
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep qqc2-desktop-style)
	$(add_plasma_dep breeze)
	$(add_plasma_dep kde-cli-tools)
	$(add_plasma_dep oxygen)
	$(add_qt_dep qtgraphicaleffects)
	sys-apps/accountsservice
	sys-apps/util-linux
	x11-apps/setxkbmap
	pulseaudio? ( $(add_plasma_dep plasma-pa ) )
	!kde-apps/kcontrol
	!<kde-apps/kde4-l10n-17.08.1-r1
	!kde-apps/knetattach[handbook]
	!kde-misc/kcm-touchpad
	!kde-plasma/plasma-desktop:4
	!kde-plasma/plasma-workspace:4
	!kde-plasma/solid-actions-kcm:4
	!kde-plasma/systemsettings:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package appstream AppStreamQt)
		$(cmake-utils_use_find_package fontconfig Fontconfig)
		$(cmake-utils_use_find_package ibus IBus)
		$(cmake-utils_use_find_package mouse Evdev)
		$(cmake-utils_use_find_package pulseaudio PulseAudio)
		$(cmake-utils_use_find_package scim SCIM)
		$(cmake-utils_use_find_package semantic-desktop KF5Baloo)
		$(cmake-utils_use_find_package touchpad Synaptics)
	)

	kde5_src_configure
}

src_test() {
	# parallel tests fail, foldermodeltest hangs, bug #646890
	# needs D-Bus, bug #634166
	local myctestargs=(
		-j1
		-E "(foldermodeltest|test_kio_fonts)"
	)

	kde5_src_test
}

pkg_postinst() {
	kde5_pkg_postinst

	if has_version "x11-libs/gtk+:2" && ! has_version "dev-libs/libappindicator:2"; then
		elog "For GTK+2 applications legacy-systray support, please install dev-libs/libappindicator:2."
	fi
	if has_version "x11-libs/gtk+:3" && ! has_version "dev-libs/libappindicator:3"; then
		elog "For GTK+3 applications legacy-systray support, please install dev-libs/libappindicator:3."
	fi
}
