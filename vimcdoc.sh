#!/bin/sh
#
# vimcdoc.sh:	vimcdoc Linux install/uninstall script
#
# Usage: 		(run it as root)
#				'./vimcdoc.sh install' to install vimcdoc
#				'./vimcdoc.sh uninstall' to uninstall vimcdoc
#
# Author:		wandys	(wandys@users.sf.net)
#				lang2	(lang2@users.sf.net)

# change these if you needed for your system
INSTALLPRG=install
RMPRG=rm
LNPRG=ln


VIMCDOC_PATH=/usr/share/doc/vimcdoc-`cat VERSION`
VIMCDOC_PATH_LINK=/usr/share/doc/vimcdoc
CNTAGS=tags-cn
DIST_FILES="README
guides.txt
LICENSE
TODO
VERSION
INSTALL
AUTHORS
dict.txt"
VIMCDOC_INST='vimcdoc.sh'

install_dist_files=0

if [ `whoami` == 'root' ]; then
	VIM_PATH=/usr/share/vim/vimfiles
	install_dist_files=1
else
	VIM_PATH=$HOME/.vim/
fi

case $1 in
	install)
	if [ $install_dist_files -eq 1 ]; then
		for i in $DIST_FILES; do
			$INSTALLPRG -D -m 644 $i $VIMCDOC_PATH/$i
		done
		$INSTALLPRG -D -m 755 $VIMCDOC_INST $VIMCDOC_PATH/$VIMCDOC_INST
		$RMPRG -f $VIMCDOC_PATH_LINK
		$LNPRG -s $VIMCDOC_PATH $VIMCDOC_PATH_LINK
	fi
	cd doc
	for i in *.cnx; do
		$INSTALLPRG -D -m 644 $i $VIM_PATH/doc/$i
	done
	$INSTALLPRG -D -m 644 $CNTAGS $VIM_PATH/doc/$CNTAGS
	echo 'Done.'
	;;

	uninstall)
	if [ $install_dist_files -eq 1 ]; then
		$RMPRG -rf $VIMCDOC_PATH
		$RMPRG -f $VIMCDOC_PATH_LINK
	fi
	if [ -d $VIM_PATH/doc ]; then
		cd $VIM_PATH/doc
		$RMPRG -f *.cnx
		$RMPRG -f $CNTAGS
	fi
	echo 'Done.'
	;;

  *)
	echo "Usage: $0 {install|uninstall}"
	exit 1
	;;
esac

# vim:ts=4:sw=4:
# EOF
