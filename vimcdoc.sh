#!/bin/sh
#
# vimcdoc.sh:	vimcdoc Linux install/uninstall script 
#
# Usage: 	(run it as root)
#		'./vimcdoc.sh install' to install vimcdoc
#        	'./vimcdoc.sh uninstall' to uninstall vimcdoc
#
# Author:	wandys  (wandys@users.sf.net)
#		lang2	(lang2@users.sf.net)

vim --cmd ":exec 'normal i' . \$VIMRUNTIME | wq! /tmp/vimrt.$$" > /dev/null 2>&1 

if [ -e /tmp/vimrt.$$ ]; then
	VIM_PATH=`cat /tmp/vimrt.$$`
	rm /tmp/vimrt.$$
else
	echo 'Error: No vim found on this system.'
	exit 1
fi

case $1 in
  install)
	if [ ! -d $VIM_PATH/doc.bk ]; then
		mkdir $VIM_PATH/doc.bk
		cp $VIM_PATH/doc/* $VIM_PATH/doc.bk
	fi
	if [ -f /etc/debian_version ]; then
		cp doc/help.txt $VIM_PATH/doc
		gzip doc/*.txt
	fi
	cp -r doc/* $VIM_PATH/doc
	echo 'Done.'
	;;

  uninstall)
	if [ -d $VIM_PATH/doc.bk ]; then
		mv $VIM_PATH/doc.bk/* $VIM_PATH/doc
		rmdir $VIM_PATH/doc.bk
	fi
	if [ -d $VIM_PATH/doc/CVS ]; then
		rm -rf $VIM_PATH/doc/CVS
	fi
	echo 'Done.'
	;;

  *)
	echo "Usage: $0 {install|uninstall}"
	exit 1
	;;
esac

# vim:ts=8:
# EOF
