# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.5.1

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal elisp-common

MY_PN="Agda"
MY_P="${MY_PN}-${PV}"

## shared with sci-mathematics/agda-stdlib
# upstream does not maintain version ordering:
#  https://github.com/agda/agda-stdlib/releases
# 0.11 -> 2.5.0.20160213 -> 2.5.0.20160412 -> 0.12
# As Agda-stdlib is tied to Agda version we encode
# both versions in gentoo version.
##
MY_UPSTREAM_AGDA_STDLIB_V="0.13"
MY_GENTOO_AGDA_STDLIB_V="${PV}.${MY_UPSTREAM_AGDA_STDLIB_V}"

DESCRIPTION="A dependently typed functional programming language and proof assistant"
HOMEPAGE="http://wiki.portal.chalmers.se/agda/"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+cpphs debug uhc +stdlib emacs"

RESTRICT=test # Unrecognized option: --test (did you mean any of --help --js --css ?)

RDEPEND=">=dev-haskell/boxes-0.1.3:=[profile?] <dev-haskell/boxes-0.2:=[profile?]
	>=dev-haskell/data-hash-0.2.0.0:=[profile?] <dev-haskell/data-hash-0.3:=[profile?]
	>=dev-haskell/edisoncore-1.3.1.1:=[profile?]
	>=dev-haskell/edit-distance-0.2.1.2:=[profile?] <dev-haskell/edit-distance-0.3:=[profile?]
	>=dev-haskell/equivalence-0.2.5:=[profile?] <dev-haskell/equivalence-0.4:=[profile?]
	>=dev-haskell/fail-4.9:=[profile?] <dev-haskell/fail-4.10:=[profile?]
	>=dev-haskell/geniplate-mirror-0.6.0.6:=[profile?] <dev-haskell/geniplate-mirror-0.8:=[profile?]
	>=dev-haskell/gitrev-1.2:=[profile?] <dev-haskell/gitrev-2.0:=[profile?]
	>=dev-haskell/hashable-1.2.1.0:=[profile?] <dev-haskell/hashable-1.3:=[profile?]
	>=dev-haskell/haskeline-0.7.1.3:=[profile?] <dev-haskell/haskeline-0.8:=[profile?]
	>=dev-haskell/ieee754-0.7.8:=[profile?] <dev-haskell/ieee754-0.8:=[profile?]
	>=dev-haskell/monadplus-1.4:=[profile?] <dev-haskell/monadplus-1.5:=[profile?]
	>=dev-haskell/murmur-hash-0.1:=[profile?] <dev-haskell/murmur-hash-0.2:=[profile?]
	>=dev-haskell/parallel-3.2.0.4:=[profile?] <dev-haskell/parallel-3.3:=[profile?]
	>=dev-haskell/regex-tdfa-1.2.2:=[profile?] <dev-haskell/regex-tdfa-1.3:=[profile?]
	>=dev-haskell/semigroups-0.18:=[profile?] <dev-haskell/semigroups-0.19:=[profile?]
	>=dev-haskell/strict-0.3.2:=[profile?] <dev-haskell/strict-0.4:=[profile?]
	>=dev-haskell/text-0.11.3.1:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/transformers-compat-0.3.3.3:=[profile?] <dev-haskell/transformers-compat-0.6:=[profile?]
	>=dev-haskell/unordered-containers-0.2.5.0:=[profile?] <dev-haskell/unordered-containers-0.3:=[profile?]
	>=dev-haskell/xhtml-3000.2.1:=[profile?] <dev-haskell/xhtml-3000.3:=[profile?]
	>=dev-haskell/zlib-0.4.0.1:=[profile?]
	>=dev-lang/ghc-7.10.1:=
	>=dev-haskell/hashtables-1.0.1.8:=[profile?] <dev-haskell/hashtables-1.3:=[profile?]
	>=dev-haskell/mtl-2.1.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	uhc? ( >=dev-haskell/shuffle-0.1.3.3:=[profile?]
		>=dev-haskell/uhc-light-1.1.9.2:=[profile?] <dev-haskell/uhc-light-1.2:=[profile?]
		>=dev-haskell/uhc-util-0.1.6.7:=[profile?] <dev-haskell/uhc-util-0.1.7:=[profile?]
		>=dev-haskell/uulib-0.9.20:=[profile?] )
"
RDEPEND+="
		emacs? ( >=app-editors/emacs-23.1:*
			app-emacs/haskell-mode )
"
PDEPEND="stdlib? ( =sci-mathematics/agda-stdlib-${MY_GENTOO_AGDA_STDLIB_V} )"
DEPEND="${RDEPEND}
	dev-haskell/alex
	>=dev-haskell/cabal-1.22.2.0
	dev-haskell/happy
	cpphs? ( dev-haskell/cpphs )
"
RDEPEND+="!sci-mathematics/agda-executable"

SITEFILE="50${PN}2-gentoo.el"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	if ! use emacs; then
		sed -e '/.*emacs-mode.*$/d' \
			-i "${S}/${MY_PN}.cabal" \
			|| die "Could not remove agda-mode from ${MY_PN}.cabal"
	fi
	cabal_chdeps \
		'EdisonCore >= 1.3.1.1 && < 1.3.2' 'EdisonCore >= 1.3.1.1'
}

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag cpphs cpphs) \
		$(cabal_flag debug debug) \
		$(cabal_flag uhc uhc)
}

src_compile() {
	if use emacs; then
		BYTECOMPFLAGS="-L ./src/data/emacs-mode"
		elisp-compile src/data/emacs-mode/*.el \
			|| die "Failed to compile emacs mode"
	fi
	haskell-cabal_src_compile
}

src_test() {
	export LD_LIBRARY_PATH="${S}/dist/build${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"

	dist/build/agda/agda --test +RTS -M1g || die
}

src_install() {
	local add="${ED}"/usr/share/"${P}/ghc-$(ghc-version)"

	haskell-cabal_src_install

	export LD_LIBRARY_PATH="${S}/dist/build${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	# compile Agda.Primitive and Agda.Builtin modules, emulate Setup.hs postinst phase
	Agda_datadir="${add}" \
		"${ED}"/usr/bin/agda "${add}"/lib/prim/Agda/Primitive.agda \
		|| die "Failed to build 'Primitive.agdai'"
	for file in "${add}"/lib/prim/Agda/Builtin/*.agda; do
		Agda_datadir="${add}" \
			"${ED}"/usr/bin/agda "${file}" \
			|| die "Failed to build '${file}'"
	done

	if use emacs; then
		elisp-install ${PN} src/data/emacs-mode/*.el \
			|| die "Failed to install emacs mode"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "Failed to install elisp site file"
	fi
}

pkg_postinst() {
	haskell-cabal_pkg_postinst
	if use emacs; then
		elisp-site-regen
	fi
}

pkg_postrm() {
	haskell-cabal_pkg_postrm
	if use emacs; then
		elisp-site-regen
	fi
}
