# vimcdoc (http://vimcdoc.sf.net) Win32 platform installation program 
# NSIS source script
# Compile this file with NSIS2!! available at http://nsis.sf.net

OutFile "vimcdoc_setup.exe"

######
# Load the lanuage files
######
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
Name "Vim Chinese Documentation"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
Name "Vim 中文文档"


######
# Setup various language string
######
LangString DocsectName ${LANG_ENGLISH} "Chinese documentation"
LangString DocsectName ${LANG_SIMPCHINESE} "中文文档"

LangString Backup ${LANG_ENGLISH} "Backup originals"
LangString Backup ${LANG_SIMPCHINESE} "备份原文档"

LangString StartVim ${LANG_SIMPCHINESE} "安装完毕后察看中文帮助"
LangString StartVim ${LANG_ENGLISH} "View the Chinese help after installation."

######
# Pre-processing
######
BrandingText /LANG=${LANG_SIMPCHINESE} "http://vcd.cosoft.org.cn"
BrandingText /LANG=${LANG_ENGLISH} "http://vimcdoc.sf.net"

LicenseText /LANG=${LANG_SIMPCHINESE} "版权信息"
LicenseData /LANG=${LANG_SIMPCHINESE} "LICENSE"
LicenseText /LANG=${LANG_ENGLISH} "License agreement"
LicenseData /LANG=${LANG_ENGLISH} "LICENSE"

CompletedText /LANG=${LANG_ENGLISH} "Thanks for installing vimcdoc."
CompletedText /LANG=${LANG_SIMPCHINESE} "感谢使用 Vim 中文文档！"

DirText /LANG=${LANG_ENGLISH}   "Please make sure the directory is corrrect. \
  If you are not sure, simply press 'Install'."
DirText /LANG=${LANG_SIMPCHINESE}    "请确定你选择了正确的目录。\
  如果你不知道，请继续安装。"

ComponentText  /LANG=${LANG_SIMPCHINSE} "安装选项:"
ComponentText /LANG=${LANG_ENGLISH} "Please setup installation options:"

InstallDirRegKey HKLM SOFTWARE\Vim\Gvim "path"
InstallColors 000000 809090
InstProgressFlags smooth colored

ShowInstDetails show

###########
# Sections
###########
Section  !$(DocsectName) 
  SectionIn RO ;This section has to be run

  ; Set the other two options to be off 
  StrCpy $R0 'no'
  StrCpy $R0 'no'

SectionEnd

Section $(Backup) 
 StrCpy $R0 'yes'
 AddSize 3500
SectionEnd

Section $(StartVim) 
 StrCpy $R1 'yes'
SectionEnd

Section - DoStuff
  StrCmp $R0 'yes' 0 +2
    Call BackupOrig

  SetOutPath $INSTDIR\doc
  File /r "doc\*.txt"
  File /r "doc\CVS"
SectionEnd

Section "Uninstall"
  CopyFiles $INSTDIR\*.* $INSTDIR\..\ 4000
  Delete $INSTDIR\*.* ; delete self (see explanation below why this works)
  Delete $INSTDIR\..\CVS\*.*
  Delete $INSTDIR\..\Uninst.exe
  RMDir $INSTDIR\..\CVS
  RMDir $INSTDIR\..\backup
SectionEnd


###########################
## Functions
##########################
Function BackupOrig
  IfFileExists $INSTDIR\doc\backup\*.* BackedUp
  CreateDirectory $INSTDIR\doc\backup
  CopyFiles "$INSTDIR\doc\*.txt" "$INSTDIR\doc\backup" 4000
  WriteUninstaller $INSTDIR\doc\backup\Uninst.exe
  BackedUp: ; backup already. skip
FunctionEnd

Function .onInstSuccess
  StrCmp $R1 'yes' 0 +2 
    Exec "$INSTDIR\gvim.exe +help" ; view help file in Vim
FunctionEnd

Function .onInit
	Push ${LANG_ENGLISH}
	Push English
	Push ${LANG_SIMPCHINESE}
	Push "简体中文"
	Push 2 ; 2 is the number of languages
	LangDLL::LangDialog "Installer Language" "Please select the language of the installer"

	Pop $LANGUAGE
	StrCmp $LANGUAGE "cancel" 0 +2
		Abort
FunctionEnd
; eof
