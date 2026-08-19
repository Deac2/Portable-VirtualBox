; Language       : multilanguage
; Author         : Michael Meyer (michaelm_007) et al.
; e-Mail         : email.address@gmx.de
; License        : http://creativecommons.org/licenses/by-nc-sa/3.0/
; Version        : 6.4.9.1
; Download       : http://www.vbox.me
; Modified       : Deac2 Copyright (c) 2024
; Support        : https://github.com/Deac2

If NOT @Compiled Then
Opt("TrayIconDebug", 1)
TraySetIcon("VirtualBox.ico")
Endif
#pragma compile(Icon, VirtualBox.ico)
#pragma compile(UPX, false)
#pragma compile(LegalCopyright, https://github.com/Deac2/Portable-VirtualBox)
#pragma compile(FileDescription, Oracle VM VirtualBox)
#pragma compile(ProductName, Portable VirtualBox)
#pragma compile(ProductVersion, 6.4.9.1")
#pragma compile(FileVersion, 6.4.9.1")
#pragma compile(AutoItExecuteAllowed, true)

#include <GUIConstantsEx.au3>
#include <RecFileListToArray.au3>
#include <Language.au3>
#include <SingleTon.au3>

_SingleTon(@ScriptName)
#RequireAdmin

Opt("GUIOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 11)
Opt("TrayOnEventMode", 1)

TraySetClick(16)
TraySetState()
TraySetToolTip("Portable-VirtualBox")

Global $var1 = @ScriptDir&"\data\settings\settings.ini"
Global $Lang = IniRead($var1, "language", "key", "NotFound")
Global $DefaultUserHome = @ScriptDir&"\.VirtualBox"
Global $DefaultMachineFolder = @ScriptDir&"\.VirtualBox\Machines"
Global $32Bit_Last = "6.0.24"
Global $version = "6.4.9.1"
Global $Lang_changes = "19.08.2026"
Global $MaxRetries = "3"		;Maximum number of retries when downloading files from https://download.virtualbox.org/virtualbox/
Global $Radio1, $Radio2, $Radio3, $Radio4, $Radio5, $Radio6, $Radio7, $Radio8, $Radio9, $Radio10, $Radio11, $Radio12, $Radio13, $Radio14
Global $Checkbox01, $Checkbox02, $Checkbox03, $Checkbox04, $Checkbox05, $Checkbox06, $Checkbox07, $Checkbox08, $Checkbox09
Global $Checkbox10, $Checkbox11, $Checkbox12, $Checkbox13, $Checkbox14, $Checkbox15, $Checkbox16, $Checkbox17, $Checkbox18
Global $Checkboxsett_19, $Checkboxsett_20, $Checkboxsett_21, $Checkboxsett_22, $Checkboxsett_23, $Checkboxsett_24, $Checkboxsett_200, $Checkboxsett_201, $Checkboxsett_202
Global $Input1, $Input2, $Input3, $Input4, $Input5, $Input6
Global $BTNUserHome, $BTNMachineFolder
Global $HomeRoot, $MachineRoot, $VMStart, $StartLng
Global $new1 = 0, $new2 = 0, $Settings = 0, $iSort
Global Const $WS_SYSMENU = 0x80000, $WS_MINIMIZEBOX = 0x20000, $CBS_DROPDOWNLIST = 0x3		; Window Extended Styles
Global $idTab, $ConsolePID
Global $OsArch = (@OSArch <> "x86" ? "x64" : "x86")

If (FileExists(@ScriptDir&"\app32\virtualbox.exe") OR FileExists(@ScriptDir&"\app64\virtualbox.exe")) Then
  If FileExists(@ScriptDir&"\app32\") AND FileExists(@ScriptDir&"\app64\") Then
    If @OSArch = "x86" Then
      Global $App_Dir = "app32"
    EndIf
    If @OSArch = "x64" Then
      Global $App_Dir = "app64"
    EndIf
  Else
    If FileExists(@ScriptDir&"\app32\") AND NOT FileExists(@ScriptDir&"\app64\") Then
      Global $App_Dir = "app32"
    EndIf
    If NOT FileExists(@ScriptDir&"\app32\") AND FileExists(@ScriptDir&"\app64\") Then
      Global $App_Dir = "app64"
    EndIf
  EndIf
EndIf

#cs
If NOT FileExists(@ScriptDir&"\data\tools") Then DirCreate(@ScriptDir&"\data\tools")
If NOT FileExists(@ScriptDir&"\data\settings\SplashScreen.jpg") Then _DownloadGithub("http://raw.githubusercontent.com/Deac2/Portable-VirtualBox-resource/refs/heads/master/data/settings/SplashScreen.jpg", "data/settings/SplashScreen.jpg")
If NOT FileExists(@ScriptDir&"\data\tools\7za.exe") Then _DownloadGithub("http://raw.githubusercontent.com/Deac2/Portable-VirtualBox-resource/refs/heads/master/data/tools/7za.exe", "data/tools/7za.exe")
If @OSArch = "x86" AND NOT FileExists(@ScriptDir&"\data\tools\snetcfg_x86.exe") Then _DownloadGithub("http://raw.githubusercontent.com/Deac2/Portable-VirtualBox-resource/refs/heads/master/data/tools/snetcfg_x86.exe", "data/tools/snetcfg_x86.exe")
If @OSArch = "x64" AND NOT FileExists(@ScriptDir&"\data\tools\snetcfg_x64.exe") Then _DownloadGithub("http://raw.githubusercontent.com/Deac2/Portable-VirtualBox-resource/refs/heads/master/data/tools/snetcfg_x64.exe", "data/tools/snetcfg_x64.exe")
If @OSArch = "x86" AND NOT FileExists(@ScriptDir&"\data\tools\devcon_x86.exe") Then _DownloadGithub("http://raw.githubusercontent.com/Deac2/Portable-VirtualBox-resource/refs/heads/master/data/tools/devcon_x86.exe", "data/tools/devcon_x86.exe")
If @OSArch = "x64" AND NOT FileExists(@ScriptDir&"\data\tools\devcon_x64.exe") Then _DownloadGithub("http://raw.githubusercontent.com/Deac2/Portable-VirtualBox-resource/refs/heads/master/data/tools/devcon_x64.exe", "data/tools/devcon_x64.exe")
#ce

If IniRead($var1, "lang", "key", "NotFound") = 0 Then
  Global $cl = 1, $StartLng

  Local $WS_POPUP

  GUICreate("Language"&" "&_GetTranslation($Lang, "download", "01"), 300, 156, -1, -1, $WS_POPUP)
  GUISetFont(10, 400, 0, "Arial")
  GUISetBkColor(0xFFFFFF)

  GUICtrlCreateLabel("Please select your language:", 31, 8, 260, 16)

  $StartLng = GUICtrlCreateCombo("", 31, 34, 100, 0, $CBS_DROPDOWNLIST)
  GUICtrlSetData($StartLng, _GetLangList(), "English")

  GUICtrlSetData($StartLng, _GetLangList(), "English")
  $CheckboxLang = GUICtrlCreateCheckbox("", 31, 65, 14, 14)
  GUICtrlSetState($CheckboxLang, $GUI_CHECKED)
  GUICtrlCreateLabel("Save language to ini file", 49, 64, 260, 16)

  GUICtrlCreateButton("Save", 30, 86, 100, 28, 0)
  GUICtrlSetOnEvent(-1, "_OKLanguage")
  GUICtrlCreateButton("Exit", 162, 86, 100, 28, 0)
  GUICtrlSetOnEvent(-1, "_ExitGUI")

  GUISetState()

  While 1
    If $cl = 0 Then ExitLoop
  WEnd

  GUIDelete()
EndIf

_UpdateSettings()
_TrayMenu()
IniWrite($var1, "userhome", "key", _ValidatePath($UserHome, $DefaultUserHome))
IniWrite($var1, "MachineFolder", "key", _ValidatePath($MachineFolder, $DefaultMachineFolder))
; Thibaut : use Hybrid Mode if available
For $i = 1 To $CmdLine[0]
    If $CmdLine[$i] = "noportable" Then
	_HybridMode()
	ExitLoop
	Endif
Next

If NOT (FileExists(@ScriptDir&"\app32\VirtualBox.exe") OR FileExists(@ScriptDir&"\app64\VirtualBox.exe")) Then
  Global $Checkbox100, $Checkbox110, $Checkbox120, $Checkbox130, $Checkbox140
  Global $Input100, $Input200, $Button100, $Button200
  Global $install = 1

  Global $Gui_Setup = GUICreate(_GetTranslation($Lang, "download", "01"), 662, 380, -1, -1, BitOR($WS_SYSMENU, $WS_MINIMIZEBOX))
  GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitGUI")
  GUISetFont(10, 400, 0, "Arial")
  GUISetBkColor(0xFFFFFF)

  GUICtrlCreateLabel(_GetTranslation($Lang, "download", "02"), 152, 8, 476, 60)

  GUISetFont(9, 400, 0, "Arial")
  Local $Download_listbox = GUICtrlCreateList("", 15, 11, 121, 290, BitOR(0xB00000, 0x800000), 0x06)
  
  GUISetFont(10, 400, 0, "Arial")
  $Button100 = GUICtrlCreateButton(_GetTranslation($Lang, "download", "03"), 11, 308, 185, 33)
  GUICtrlSetOnEvent($Button100, "_DownloadFile")
  _Load_ListBox()

  $Input100 = GUICtrlCreateInput(_GetTranslation($Lang, "download", "04"), 152, 70, 373, 23)
  GUICtrlCreateButton(_GetTranslation($Lang, "download", "05"), 532, 69, 93, 25)
  GUICtrlSetOnEvent(-1, "_SearchFile")

  $Checkbox100 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "download", "06"), 152, 101, 490, 26)
  $Checkbox110 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "download", "07"), 152, 125, 490, 26)
  $Checkbox120 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "download", "08"), 152, 149, 490, 26)
  $Checkbox130 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "download", "09"), 152, 173, 490, 26)
  $Checkbox140 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "download", "10"), 152, 197, 490, 26)
  GUICtrlSetState($Checkbox120, $GUI_CHECKED)
  GUICtrlSetState($Checkbox130, $GUI_CHECKED)

  $LabelDownload = GUICtrlCreateLabel(_GetTranslation($Lang, "download", "11"), 152, 221, 300, 26)
  GUICtrlSetState($LabelDownload, $GUI_HIDE)
  $Input200 = GUICtrlCreateEdit("", 149, 238, 476, 65, "", 0x06)

  $Button200 = GUICtrlCreateButton(_GetTranslation($Lang, "download", "12"), 209, 308, 129, 33)
  GUICtrlSetState($Button200, $GUI_DISABLE)
  GUICtrlSetOnEvent(-1, "_UseSettings")
  GUICtrlCreateButton(_GetTranslation($Lang, "download", "13"), 351, 308, 149, 33)
  GUICtrlSetOnEvent(-1, "_Licence")
  GUICtrlCreateButton(_GetTranslation($Lang, "download", "14"), 513, 308, 129, 33)
  GUICtrlSetOnEvent(-1, "_ExitGUI")

  If FileExists(@ScriptDir&"\virtualbox.exe") Then
    GUICtrlSetData($Input100, @ScriptDir&"\virtualbox.exe")
    GUICtrlSetState($Button200,$GUI_ENABLE)
	_CheckExeFile(@ScriptDir&"\VirtualBox.exe")
  EndIf

  GUISetState()

  While 1
    If $install = 0 Then ExitLoop
  WEnd

  Global $startvbox = 0
Else
  Global $startvbox = 1
EndIf

If (FileExists(@ScriptDir&"\app32\virtualbox.exe") OR FileExists(@ScriptDir&"\app64\virtualbox.exe")) AND ($startvbox = 1 OR IniRead($var1, "startvbox", "key", "NotFound") = 1) Then
  IniDelete($var1, "startvbox")
#cs
  If FileExists(@ScriptDir&"\app32\") AND FileExists(@ScriptDir&"\app64\") Then
    If @OSArch = "x86" Then
      Global $App_Dir = "app32"
    EndIf
    If @OSArch = "x64" Then
      Global $App_Dir = "app64"
    EndIf
  Else
    If FileExists(@ScriptDir&"\app32\") AND NOT FileExists(@ScriptDir&"\app64\") Then
      Global $App_Dir = "app32"
    EndIf
    If NOT FileExists(@ScriptDir&"\app32\") AND FileExists(@ScriptDir&"\app64\") Then
      Global $App_Dir = "app64"
    EndIf
  EndIf
#ce

      #clear log
      If IniRead($var1, "Core_Logs", "key", "0") = 1 Then
      If FileExists($UserHome) Then
      FileDelete($UserHome&"\*.log")
      FileDelete($UserHome&"\*.log.*")
	  FileDelete($UserHome&"\VirtualBox.xml-prev")
      FileDelete($UserHome&"\VirtualBox.xml-tmp")
      EndIf
	  EndIf

		#clear log Machines
		If IniRead($var1, "VM_Logs", "key", "0") = 1 Then
	  If FileExists($UserHome&"\VirtualBox.xml") Then
		Local $file = FileOpen($UserHome&"\VirtualBox.xml", 256)
		If $file <> -1 Then
		$line = FileRead($file)
		FileClose($file)
		$values0 = _StringBetween($line, '<MachineRegistry>', '</MachineRegistry>')
		If $values0 = 0 Then
        $values1 = 0
		Else
		$values1 = _StringBetween($values0[0], 'src="', '"')
		EndIf
		EndIf

		For $i = 0 To UBound($values1) - 1
		Local $Result = StringSplit(StringReplace($values1[$i], ".vbox", ""), "\")
		Local $ResultName = $Result[$Result[0]]
		$aArray = _RecFileListToArray($UserHome, "*"&$ResultName&".vbox", 1, 1, 0, 2)
		If IsArray($aArray) Then
		For $j = 1 To $aArray[0]
		If FileExists($aArray[$j]) Then
		Local $Patch = StringRegExpReplace($aArray[$j], "[^\\]+$", "")
		FileDelete($Patch&"Logs\*.log")
		FileDelete($Patch&"Logs\*.log.*")
		EndIf
		Next
		EndIf
		Next
	  EndIf
		EndIf

  If NOT FileExists($UserHome & "\VirtualBox.xml") Then
	Local $XmlContent = '<?xml version="1.0"?>' & @LF & _
	'<!--' & @LF & _
	'** DO NOT EDIT THIS FILE.' & @LF & _
	'** If you make changes to this file while any VirtualBox related application' & @LF & _
	'** is running, your changes will be overwritten later, without taking effect.' & @LF & _
	'** Use VBoxManage or the VirtualBox Manager GUI to make changes.' & @LF & _
	'-->' & @LF & _
	'<VirtualBox xmlns="http://www.virtualbox.org/" version="1.12-windows">' & @LF & _
	'  <Global>' & @LF & _
	'    <ExtraData>' & @LF & _
	'      <ExtraDataItem name="GUI/LastItemSelected" value="n=GLOBAL"/>' & @LF & _
	'      <ExtraDataItem name="GUI/LastWindowPosition" value="320,244,640,488"/>' & @LF & _
	'      <ExtraDataItem name="GUI/Tools/LastItemsSelected" value="Welcome,Details"/>' & @LF & _
	'    </ExtraData>' & @LF & _
	'    <MachineRegistry/>' & @LF & _
	'    <NetserviceRegistry>' & @LF & _
	'      <DHCPServers/>' & @LF & _
	'    </NetserviceRegistry>' & @LF & _
	'    <Updates enabled="false">' & @LF & _
	'      <Host enabled="false" channel="1" checkFreqSec="86400" repoUrl="https://update.virtualbox.org" checkCount="0"/>' & @LF & _
	'    </Updates>' & @LF & _
	'    <SystemProperties defaultMachineFolder="' & $MachineFolder & '" defaultHardDiskFormat="VDI" VRDEAuthLibrary="VBoxAuth" webServiceAuthLibrary="VBoxAuth" LogHistoryCount="3" proxyMode="0" exclusiveHwVirt="false"/>' & @LF & _
	'    <USBDeviceFilters/>' & @LF & _
	'  </Global>' & @LF & _
	'</VirtualBox>' & @LF
	$file = FileOpen($UserHome&"\VirtualBox.xml", 2+8+256)
	FileWrite($file,  $XmlContent)
	FileClose($file)
  EndIf

  If FileExists($UserHome&"\VirtualBox.xml") Then
    Local $values0, $values1, $values2, $values3, $values4, $values5, $values6, $values7, $values8, $values9, $values10, $values11, $values12, $values13
    Local $line, $content, $i, $j, $k, $l, $m, $n
    Local $file = FileOpen($UserHome&"\VirtualBox.xml", 256)
    If $file <> -1 Then
      $line = FileRead($file)
	  FileClose($file)
      $values0 = _StringBetween($line, '<MachineRegistry>', '</MachineRegistry>')
      If $values0 = 0 Then
        $values1 = 0
      Else
        $values1 = _StringBetween($values0[0], 'src="', '"')
      EndIf
      $values10 = _StringBetween($line, '<Global>', '</Global>')
      If $values10 = 0 Then
        $values11 = 0
      Else
        $values11 = _StringBetween($values10[0], '<SystemProperties', '/>')
      EndIf

	 $aArray = _RecFileListToArray($MachineFolder, "*.vbox", 1, 1, $iSort, 2)
     If IsArray($aArray) Then
     For $i = 1 To $aArray[0]
		If NOT StringRegExp($aArray[$i], ".bin") Then
          $line = ""
		  $file = FileOpen($aArray[$i], 256)
		  If $file <> -1 Then
		  $line = FileRead($file)
		  FileClose($file)
		  If StringRegExp($line, "VirtualBox") and StringRegExp($line, "Machine") and StringRegExp($line, "HardDisks") and StringRegExp($line, "Hardware") Then
			$values2 = _StringBetween($line, '<Machine', '>')
			If $values2<>0 Then
		    $values3 = _StringBetween($line, 'uuid="', '"')
			EndIf
		  If $values3<>0 and FileExists($aArray[$i]) Then
		  $values4 &= "<MachineEntry uuid="""&$values3[0]&""" src="""&$aArray[$i]&"""/>" & @LF
		  EndIf
		  EndIf
		  EndIf
		EndIf
     Next
     EndIf

	$values4 = StringTrimRight($values4, 1)
	$a = stringsplit($values4, @LF, 2)
	local $b = 0
    for $i = ubound($a) - 1 to 0 step - 1
		$uuid1 = _StringBetween($a[$i], 'uuid="', '"')
        For $x = $i - 1 to 0 step - 1
			$uuid2 = _StringBetween($a[$x], 'uuid="', '"')
			If $uuid1[0] = $uuid2[0] Then
			$b += 1
			$values4 = StringReplace($values4, $a[$i], "")
			if $i>=$b Then
			_LogDuplicate($a[$x])
			Else
			_LogDuplicate($a[$x])
			EndIf
			$x = 0
			EndIf
		Next
    Next

      $file = FileOpen($UserHome&"\VirtualBox.xml", 256)
      If $file <> -1 Then
		$content = FileRead($file)
		FileClose($file)
      EndIf
      $values6 = _StringBetween($content, "</ExtraData>", "<NetserviceRegistry>")
	  if $values6 <> 0 Then
      Local $xmlfile = FileOpen($UserHome&"\VirtualBox.xml", 2+8+256)
	  If $xmlfile <> -1 Then
      FileWrite($xmlfile, StringReplace($content, $values6[0], @LF &"<MachineRegistry>"&$values4&"</MachineRegistry>"& @LF))
      FileClose($xmlfile)
      EndIf
	  EndIf

      If IsArray($values11) Then
      For $m = 0 To UBound($values11) - 1
        $values12 = _StringBetween($values11[$m], 'defaultMachineFolder="', '"')
        If $values12 <> 0 Then
		  If NOT FileExists(StringLeft($values12[0], 2)) or Not FileExists($values12[0]) Then
			$file = FileOpen($UserHome&"\VirtualBox.xml", 256)
			If $file <> -1 Then
			$content = FileRead($file)
			FileClose($file)
			EndIf
            $file    = FileOpen($UserHome&"\VirtualBox.xml", 2+8+256)
			If $file <> -1 Then
            FileWrite($file, StringReplace($content, $values12[0], $MachineFolder))
            FileClose($file)
			EndIf
          EndIf
        EndIf
      Next
	  EndIf
    EndIf
  Else
    MsgBox(0+262144, _GetTranslation($Lang, "download", "15"), _GetTranslation($Lang, "download", "16"))
  EndIf

  If FileExists(@ScriptDir&"\"&$App_Dir&"\VirtualBox.exe") AND FileExists(@ScriptDir&"\"&$App_Dir&"\VBoxSVC.exe") AND FileExists(@ScriptDir&"\"&$App_Dir&"\VBoxC.dll") Then
    If NOT ProcessExists("VirtualBox.exe") OR NOT ProcessExists("VBoxManage.exe") Then
      If FileExists(@ScriptDir&"\data\settings\SplashScreen.jpg") Then
        SplashImageOn("Portable-VirtualBox", @ScriptDir&"\data\settings\SplashScreen.jpg", 480, 360, -1, -1, 1)
      Else
        SplashTextOn("Portable-VirtualBox", _GetTranslation($Lang, "messages", "06"), 220, 40, -1, -1, 1, "arial", 12)
      EndIf

      If @OSArch = "x86" Then
        If NOT FileExists(@SystemDir&"\msvcp71.dll") OR NOT FileExists(@SystemDir&"\msvcr71.dll") OR NOT FileExists(@SystemDir&"\msvcrt.dll") Then
          FileCopy(@ScriptDir&"\app32\msvcp71.dll", @SystemDir, 9)
          FileCopy(@ScriptDir&"\app32\msvcr71.dll", @SystemDir, 9)
          FileCopy(@ScriptDir&"\app32\msvcrt.dll", @SystemDir, 9)
          Local $msv = 1
        Else
          Local $msv = 0
        EndIf
      EndIf

      If @OSArch = "x64" Then
        If NOT FileExists(@SystemDir&"\msvcp80.dll") OR NOT FileExists(@SystemDir&"\msvcr80.dll") Then
          FileCopy(@ScriptDir&"\app64\msvcp80.dll", @SystemDir, 9)
          FileCopy(@ScriptDir&"\app64\msvcr80.dll", @SystemDir, 9)
          Local $msv = 2
        Else
          Local $msv = 0
        EndIf
      EndIf

      If FileExists(@ScriptDir&"\"&$App_Dir&"\") AND FileExists(@ScriptDir&"\vboxadditions\") Then
        DirMove(@ScriptDir&"\vboxadditions\doc", @ScriptDir&"\"& $App_Dir, 1)
        DirMove(@ScriptDir&"\vboxadditions\ExtensionPacks", @ScriptDir&"\"& $App_Dir, 1)
        DirMove(@ScriptDir&"\vboxadditions\nls", @ScriptDir&"\"& $App_Dir, 1)
        FileMove(@ScriptDir&"\vboxadditions\guestadditions\*.*", @ScriptDir&"\"&$App_Dir&"\", 9)
      Endif

      _Start_VirtualBox()
      SplashOff()

      If $CmdLine[0] = 1 Then
        If FileExists($UserHome) Then
          Local $StartVM = $CmdLine[1]
		  Local $Patch = ""
		  $VMStartSearch = StringRegExpReplace($StartVM, "\h*[{}\[\]]+\h*", "_")
          $aArray = _RecFileListToArray($UserHome, "*"&$VMStartSearch&".vdi", 1, 1, 0, 2)
          If IsArray($aArray) Then
			For $i = 1 To $aArray[0]
			$Patch = $aArray[$i]
			Next
          Endif
		  If IniRead($var1, "userhome", "key", "NotFound") = $UserHome Then
			Run(""""&@ScriptDir&"\"&$App_Dir&"\VirtualBox.exe""", @ScriptDir, @SW_SHOW)
			RunWait(""""&@ScriptDir&"\"&$App_Dir&"\VBoxManage.exe"" startvm """&$StartVM&"""", @ScriptDir, @SW_HIDE)
          Else
            RunWait(""""&@ScriptDir&"\"&$App_Dir&"\VirtualBox.exe""", @ScriptDir, @SW_SHOW)
          EndIf
        Else
			RunWait(""""&@ScriptDir&"\"&$App_Dir&"\VirtualBox.exe""", @ScriptDir, @SW_SHOW)
        EndIf

        ProcessWaitClose("VirtualBox.exe")
        ProcessWaitClose("VBoxManage.exe")
      Else
        If FileExists($UserHome) Then
          Local $StartVM  = IniRead($var1, "startvm", "key", "NotFound")
		  If $StartVM <> "NotFound" And $StartVM <> ""  And FileExists($MachineFolder & "\" & $StartVM) Then
			Run(""""&@ScriptDir&"\"&$App_Dir&"\VirtualBox.exe""", @ScriptDir, @SW_SHOW)
			RunWait(""""&@ScriptDir&"\"&$App_Dir&"\VBoxManage.exe"" startvm """&$StartVM&"""", @ScriptDir, @SW_HIDE)
		  Else
			IniWrite($var1, "startvm", "key", "")
			RunWait(""""&@ScriptDir&"\"&$App_Dir&"\VirtualBox.exe""", @ScriptDir, @SW_SHOW)
          EndIf
        Else
          RunWait(""""&@ScriptDir&"\"&$App_Dir&"\VirtualBox.exe""", @ScriptDir, @SW_SHOW)
        EndIf

        ProcessWaitClose("VirtualBox.exe")
        ProcessWaitClose("VBoxManage.exe")
      EndIf

      SplashTextOn("Portable-VirtualBox", _GetTranslation($Lang, "messages", "07"), 220, 40, -1, -1, 1, "arial", 12)

      _ExitScript()

      Local $PortMode = IniRead($var1, "PortableMode", "key", "0")
      If $PortMode = 0 Then
	  _Stop_VirtualBox()
      EndIf
      SplashOff()
    Else
      _WinSetState("VirtualBox.exe", BitAND(@SW_SHOW, @SW_RESTORE))
      _WinSetState("VirtualBoxVM.exe", BitAND(@SW_SHOW, @SW_RESTORE))
    EndIf
  Else
    SplashOff()
    MsgBox(0, _GetTranslation($Lang, "messages", "01"), _GetTranslation($Lang, "start", "01"))
  EndIf
EndIf

Break(1)
Exit

Func _ShowWindows_VM()
_WinSetState("VirtualBoxVM.exe", BitAND(@SW_SHOW, @SW_RESTORE))
EndFunc

Func _HideWindows_VM()
_WinSetState("VirtualBoxVM.exe", @SW_HIDE)
EndFunc

Func _ShowWindows()
_WinSetState("VirtualBox.exe", BitAND(@SW_SHOW, @SW_RESTORE))
EndFunc

Func _HideWindows()
_WinSetState("VirtualBox.exe", @SW_HIDE)
EndFunc

Func _Load_ListBox()
Const $TH_MAJOR = 6, $TH_MINOR = 0, $TH_PATCH = 24
Local $MAX_MAJOR070 = 7, $MAX_MIN070 = 0, $MaxNode070 = 0, $ver = ""

Local $url = "https://download.virtualbox.org/virtualbox/"

Local $binData = InetRead($url)
If @error Or @extended = 0 Then
GUICtrlSetState($Download_listbox, $GUI_DISABLE)
GUICtrlSetState($Button100, $GUI_DISABLE)
GUICtrlSetData($Download_listbox, "virtualbox.org|Not Load")
Return
EndIf

Local $html = BinaryToString($binData, 4)
Local $aMatches = StringRegExp($html, '<a href="([\d\.]+/)">', 3)
;If @error Or UBound($aMatches) = 0 Then
;EndIf

For $i = 0 To UBound($aMatches) - 1
    Local $ver = StringTrimRight($aMatches[$i], 1)
    Local $aP = StringSplit($ver, ".")
    If $aP[0] <> 3 Then ContinueLoop

    Local $maj = Number($aP[1]), $min = Number($aP[2]), $pat = Number($aP[3])
	If ($maj > $TH_MAJOR) Or ($maj = $TH_MAJOR And $min > $TH_MINOR) Or ($maj = $TH_MAJOR And $min = $TH_MINOR And $pat >= $TH_PATCH) Then
            GUICtrlSetData($Download_listbox, "VirtualBox "&$ver)
            If $maj = $MAX_MAJOR070 And $min = $MAX_MIN070 Then
                    $MaxNode070 = $ver
            EndIf
    EndIf
Next

	If $MaxNode070 <> 0 Then
	GUICtrlSetData($Download_listbox, "VirtualBox "&$MaxNode070)
	Else
	GUICtrlSetData($Download_listbox, "VirtualBox "&$ver)
	EndIf
EndFunc

Func _LogDuplicate($Linetext)
    Local $filePath = @ScriptDir&"\Portable-VirtualBox.error.txt"
	FileDelete($filePath)
    Local $hFile = FileOpen($filePath, 1)
    If $hFile = -1 Then
        Return
    EndIf
    Local $uuid = _StringBetween($Linetext, 'uuid="', '"')
    FileWrite($hFile, "[" & @MDAY & "." & @MON & "." & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & "] Duplicate found with UUID: " & $uuid[0] & @LF)
    FileWrite($hFile, "[" & @MDAY & "." & @MON & "." & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & "] Duplicate line: " & $Linetext & @LF)
    FileWrite($hFile, "----------------------------------------" & @LF)
    FileClose($hFile)
EndFunc

Func _WinSetState($ProcessName, $Command)
Local $titles = _GetWindowTitle($ProcessName)
If @error Then Return
For $i = 1 To $titles[0]
WinSetState(""&$titles[$i]&"", "", $Command)
Next
EndFunc

Func _GetWindowTitle($ProcessName)
    Local $pid = 0
    Local $processList = ProcessList()
    For $i = 1 To $processList[0][0]
        If StringLower($processList[$i][0]) = StringLower($ProcessName) Then
            $pid = $processList[$i][1]
        EndIf
    Next
    If $pid = 0 Then Return SetError(1,0,0)

    Local $winList = WinList()
    Local $titles[1] = [0]

    For $i = 1 To $winList[0][0]
        If $winList[$i][0] <> "" Then
            Local $wPID = WinGetProcess($winList[$i][1])
            If $wPID = $pid Then
                Local $title = WinGetTitle($winList[$i][1])
				If StringInStr($title, "VirtualBox") <> 0 Then
                    $titles[0] += 1
                    ReDim $titles[$titles[0] + 1]
                    $titles[$titles[0]] = $title
                EndIf
            EndIf
        EndIf
    Next
    Return $titles
EndFunc

Func _ValidatePath($Path, $DefaultPath)
    ; Check disk and create folder
    If FileExists(StringLeft($Path, 2)) Then DirCreate($Path)

    ; Check that the path exists and is a folder
    If FileExists($Path) And StringInStr(FileGetAttrib($Path), "D") And Not StringInStr(FileGetAttrib($Path), "R") Then
			$Path = StringReplace($Path, "/", "\")
			$Path = StringRegExpReplace($Path, "\\{2,}", "\\")
			If StringRight($path, 1) = "\" Then
			; Remove the last character "\"
			$path = StringLeft($path, StringLen($path) - 1)
			EndIf
			return $Path
    Else
        ; If the path does not exist or is not a folder, set the default value
        If FileExists(StringRegExp(StringLeft($Path, 2), ":")) Then
			$Path = StringReplace($Path, "/", "\")
			$Path = StringRegExpReplace($Path, "\\{2,}", "\\")
			return $DefaultPath
        Else
			$Path = StringReplace($Path, "/", "\")
			$Path = StringRegExpReplace($Path, "\\{2,}", "\\")
			return $DefaultPath
        EndIf
        ; Checking for path existence
        If Not FileExists($Path) Then
			$Path = StringReplace($Path, "/", "\")
			$Path = StringRegExpReplace($Path, "\\{2,}", "\\")
            return $DefaultPath
        EndIf
    EndIf
EndFunc

Func _IniWrite($filename, $section, $key, $value, $encoding = 256, $Write = False)
	Switch $encoding
	Case 16, 32, 64, 128, 256, 512
    Case Else
	$encoding = 256
	EndSwitch

	If $Write OR NOT IniRead($filename, $section, $key, "") Then
		$sDir = StringRegExpReplace($filename, "[^\\]+$", "")
		If NOT FileExists($sDir) Then DirCreate($sDir)

        Local $hFile = FileOpen($filename, 1 + $encoding)
        If $hFile <> -1 Then FileClose($hFile)

        $hFile = FileOpen($filename, 0 + $encoding)
        Local $content = ""
        If $hFile <> -1 Then
		$content = FileRead($hFile)
		FileClose($hFile)
        EndIf

        If StringLeft($content, 2) = @CRLF Then
		$content = StringMid($content, 3)
        ElseIf StringLeft($content, 1) = @LF Then
		$content = StringMid($content, 2)
        EndIf

        $hFile = FileOpen($filename, 2 + $encoding)
        If $hFile <> -1 Then
		FileWrite($hFile, $content)
		FileClose($hFile)
        EndIf
        IniWrite($filename, $section, $key, $value)
    EndIf
EndFunc

Func _RegRead($keyname, $valuename)
    Local $RegRoot = (@OSArch = "X64") ? "64" : ""
    $keyname = StringReplace($keyname, "HKLM", "HKLM" & $RegRoot)
    $keyname = StringReplace($keyname, "HKCU", "HKCU" & $RegRoot)
    $keyname = StringReplace($keyname, "HKCR", "HKCR" & $RegRoot)
    $keyname = StringReplace($keyname, "HKCC", "HKCC" & $RegRoot)
    $keyname = StringReplace($keyname, "HKU", "HKU" & $RegRoot)
    $keyname = StringReplace($keyname, "HKEY_LOCAL_MACHINE", "HKLM" & $RegRoot)
    $keyname = StringReplace($keyname, "HKEY_CURRENT_USER", "HKCU" & $RegRoot)
    $keyname = StringReplace($keyname, "HKEY_CLASSES_ROOT", "HKCU" & $RegRoot)
    $keyname = StringReplace($keyname, "HKEY_CURRENT_CONFIG", "HKCC" & $RegRoot)
    $keyname = StringReplace($keyname, "HKEY_USERS", "HKU" & $RegRoot)
    Return RegRead($keyname, $valuename)
EndFunc

Func _CheckExeFile($Directory)
	Local $sFileVer = StringRegExpReplace(FileGetVersion($Directory), "^(\d+\.\d+.\d+)?.*", "\1")
	Local $HexData = ""
    Local $hFile = FileOpen($Directory, 16)
    If $hFile <> -1 Then
        $HexData = FileRead($hFile, 180)
        FileClose($hFile)
    EndIf
	If Not StringRegExp($HexData, "5669727475616C426F782065786563757461626C65") Then
		GUICtrlSetData($Input100, _GetTranslation($Lang, "download", "04"))
		Else
		WinSetTitle($Gui_Setup, "", _GetTranslation($Lang, "download", "01")&" "&$sFileVer&"")
	EndIf
	If $sFileVer<=$32Bit_Last Then
		GUICtrlSetData($Checkbox100, _GetTranslation($Lang, "download", "06"))
		GUICtrlSetState($Checkbox100, $GUI_ENABLE)
		Else
		If @OSArch="x86" Then
		GUICtrlSetData($Checkbox100, _GetTranslation($Lang, "download", "06")&" "&$sFileVer&">"&$32Bit_Last&"")
		EndIf
		GUICtrlSetState($Checkbox100, $GUI_UNCHECKED)
		GUICtrlSetState($Checkbox100, $GUI_DISABLE)
	EndIf
	If @OSArch="x86" Then
		GUICtrlSetState($Checkbox110, $GUI_UNCHECKED)
		GUICtrlSetState($Checkbox110, $GUI_DISABLE)
		Else
		GUICtrlSetState($Checkbox100, $GUI_UNCHECKED)
		GUICtrlSetState($Checkbox100, $GUI_DISABLE)
	EndIf
EndFunc

Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
	Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""

	$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\" ; Ensure a single trailing backslash
	If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
	If $bReturnPath Then $sFullPath = $sFilePath
	If $sFilter = Default Then $sFilter = "*"

	If NOT FileExists($sFilePath) Then Return SetError(1, 0, 0)
	If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
	If NOT ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
	Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
	If @error Then Return SetError(4, 0, 0)
	While 1
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If ($iFlag + @extended = 2) Then ContinueLoop
		$sFileList &= $sDelimiter & $sFullPath & $sFileName
	WEnd
	FileClose($hSearch)
	If $sFileList = "" Then Return SetError(4, 0, 0)
	Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc

Func _StringBetween($s_String, $s_Start, $s_End, $v_Case = -1)
	; Set case type
	Local $s_case = ""
	If $v_Case = Default Or $v_Case = -1 Then $s_case = "(?i)"

	; Escape characters
	Local $s_pattern_escape = "(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)"
	$s_Start = StringRegExpReplace($s_Start, $s_pattern_escape, "\\$1")
	$s_End = StringRegExpReplace($s_End, $s_pattern_escape, "\\$1")

	; If you want data from beginning then replace blank start with beginning of string
	If $s_Start = "" Then $s_Start = "\A"

	; If you want data from a start to an end then replace blank with end of string
	If $s_End = "" Then $s_End = "\z"

	Local $a_ret = StringRegExp($s_String, "(?s)" & $s_case & $s_Start & "(.*?)" & $s_End, 3)

	If @error Then Return SetError(1, 0, 0)
	Return $a_ret
EndFunc   ;==>_StringBetween

Func _VM_List_Load()
     $values5 = ""
	 $aArray = _RecFileListToArray($MachineFolder, "*.vbox", 1, 1, $iSort, 2)
     If IsArray($aArray) Then
     For $i = 1 To $aArray[0]
		If Not StringRegExp($aArray[$i], ".bin") Then
          $line = ""
		  $file = FileOpen($aArray[$i], 256)
		  If $file <> -1 Then
		      $line = FileRead($file)
		      FileClose($file)
		  EndIf
		  If StringRegExp($line, "VirtualBox") and StringRegExp($line, "Machine") and StringRegExp($line, "HardDisks") and StringRegExp($line, "Hardware") Then
			$values2 = _StringBetween($line, '<Machine', '>')
            If $values2 <> 0 Then
		        $values3 = _StringBetween($values2[0], 'name="', '"')
                If $values3<>0 and FileExists($aArray[$i]) Then
		            $values5 &= $values3[0]&"|"
		        EndIf
			EndIf
		  EndIf
		EndIf
     Next
     EndIf
	 $values5 = StringTrimRight($values5, 1)
	 Return $values5
EndFunc

Func _VM_List_Update()
    Local $sList = _VM_List_Load()
    Local $aList = StringSplit($sList, "|", 1)
    
    ; Read the saved name from ini
    Local $VMStartName = IniRead($var1, "startvm", "key", "")
    
    ; Checking the existence of the file
    If Not FileExists($MachineFolder&"\"&$VMStartName) Then
        $VMStartName = ""
        IniWrite($var1, "startvm", "key", "")
    EndIf
    
    ; Get the currently selected element
    Local $currentSelection = GUICtrlRead($VMStart)
    
    ; We update the list only if it has changed
    If $sList <> $prevList Then
        GUICtrlSetData($VMStart, "") ; clear list
        GUICtrlSetData($VMStart, $sList) ; fill in a new list
        $prevList = $sList
    Else
        ; If the list has not changed, do nothing - so as not to twitch the ComboBox
        Return
    EndIf
    
    ; Check if the current selection is in the list
    Local $foundCurrent = False
    For $i = 1 To $aList[0]
        If $aList[$i] = $currentSelection Then
            $foundCurrent = True
            ExitLoop
        EndIf
    Next
    
    ; If the current choice is in the list, leave it
    If $foundCurrent Then
        If (GUICtrlRead($Checkboxsett_24)=4) Then
			GUICtrlSetData($VMStart, $aList[1])
        Else
			GUICtrlSetData($VMStart, $currentSelection)
        EndIf
    Else
        ; If not, we try to select a saved name from ini if ​​it is in the list
        Local $foundSaved = False
        For $i = 1 To $aList[0]
            If $aList[$i] = $VMStartName And $VMStartName <> "" Then
                GUICtrlSetData($VMStart, $VMStartName)
                $foundSaved = True
                ExitLoop
            EndIf
        Next
        
        ; If there is no saved name, select the first element of the list
        If Not $foundSaved And $aList[0] > 0 Then
            GUICtrlSetData($VMStart, $aList[1])
        EndIf
    EndIf
EndFunc

Func _OnTabChange()
    Local $idCurrentTab = GUICtrlRead($idTab) + 1
    Switch $idCurrentTab
        Case 1
            _UpdateSettings()
            AdlibRegister("_VM_List_Update", 1000)
        Case Else
            AdlibUnRegister("_VM_List_Update")
    EndSwitch
EndFunc

Func _Settings()
	If NOT $Settings Then
	Global $prevList = ""
	_OnTabChange()

	Local $WS_SYSMENU = 0x80000

	$Settings = GUICreate(_GetTranslation($Lang, "settings", "01")&" "&_GetTranslation($Lang, "download", "01"), 580, 380, -1, -1, $WS_SYSMENU)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_CloseGUI")
    GUISetFont(9, 400, 0, "Arial")
	GUISetBkColor(0xFFFFFF)
	$idTab = GUICtrlCreateTab(0, 0, 577, 358)
	GUICtrlSetOnEvent($idTab, "_OnTabChange")
    
	GUICtrlCreateTabItem(_GetTranslation($Lang, "settings", "01"))
	$Checkboxsett_19 = GUICtrlCreateCheckbox("", 16, 40, 14, 14)
	GUICtrlCreateLabel(_GetTranslation($Lang, "settings", "02"), 32, 39, 546, 14)
	$Checkboxsett_20 = GUICtrlCreateCheckbox("", 16, 60, 14, 14)
	GUICtrlCreateLabel(_GetTranslation($Lang, "settings", "03"), 32, 59, 546, 14)
	$Checkboxsett_21 = GUICtrlCreateCheckbox("", 16, 80, 14, 14)
	GUICtrlCreateLabel(_GetTranslation($Lang, "settings", "04"), 32, 79, 546, 14)
	If IniRead($var1, "net", "key", "NotFound") = 1 Then GUICtrlSetState($Checkboxsett_19, $GUI_CHECKED)
	If IniRead($var1, "usb", "key", "NotFound") = 1 Then GUICtrlSetState($Checkboxsett_20, $GUI_CHECKED)
	If IniRead($var1, "hotkeys", "key", "NotFound") = 1 Then GUICtrlSetState($Checkboxsett_21, $GUI_CHECKED)

    GUICtrlCreateLabel(_GetTranslation($Lang, "settings", "05"), 32, 102, 110, 14)
    $StartLng = GUICtrlCreateCombo("", 142, 100, 100, 0, $CBS_DROPDOWNLIST)
    GUICtrlSetData($StartLng, _GetLangList(), IniRead($var1, "language", "key", "NotFound"))

	GuiCtrlCreateGroup("", 14, 120, 451, 60)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	$Checkboxsett_22 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "settings", "06"), 16, 130, 442, 14)
	GUICtrlSetOnEvent(-1, "_CheckboxSettings")
	$User_Home = IniRead($var1, "userhome", "key", "NotFound")
	$HomeRoot = GUICtrlCreateInput($User_Home, 33, 148, 332, 21)

    $BTNUserHome = GUICtrlCreateButton(_GetTranslation($Lang, "settings", "09"), 370, 147, 81, 23, 0)
    GUICtrlSetOnEvent(-1, "_SRCUserHome")
    If IniRead($var1, "userhome", "key", "NotFound") = $DefaultUserHome Then
	GUICtrlSetState($HomeRoot, $GUI_DISABLE)
	GUICtrlSetState($BTNUserHome, $GUI_DISABLE)
	Else
	GUICtrlSetState($HomeRoot, $GUI_ENABLE)
	GUICtrlSetState($BTNUserHome, $GUI_ENABLE)
	GUICtrlSetState($Checkboxsett_22, $GUI_CHECKED)
	Endif

	GuiCtrlCreateGroup("", 14, 178, 451, 60)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	$Checkboxsett_23 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "settings", "07"), 16, 190, 442, 14)
	GUICtrlSetOnEvent(-1, "_CheckboxSettings")
	$MachineDir = IniRead($var1, "machinefolder", "key", "NotFound")
	$MachineRoot = GUICtrlCreateInput($MachineDir, 33, 208, 332, 21)
    $BTNMachineFolder = GUICtrlCreateButton(_GetTranslation($Lang, "settings", "09"), 370, 207, 81, 23, 0)
    If IniRead($var1, "machinefolder", "key", "NotFound") = $DefaultMachineFolder Then
	GUICtrlSetState($MachineRoot, $GUI_DISABLE)
	GUICtrlSetState($BTNMachineFolder, $GUI_DISABLE)
	Else
	GUICtrlSetState($MachineRoot, $GUI_ENABLE)
	GUICtrlSetState($BTNMachineFolder, $GUI_ENABLE)
	GUICtrlSetState($Checkboxsett_23, $GUI_CHECKED)
	Endif
    GUICtrlSetOnEvent(-1, "_SRCMachineFolder")

	GuiCtrlCreateGroup("", 14, 236, 451, 60)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	$Checkboxsett_24 = GUICtrlCreateCheckbox(_GetTranslation($Lang, "settings", "08"), 16, 250, 442, 14)
	GUICtrlSetOnEvent(-1, "_CheckboxSettings")
	If IniRead($var1, "startvm", "key", "NotFound") = false Then
	$VMStart = GUICtrlCreateCombo("", 33, 268, 417, 21, $CBS_DROPDOWNLIST)
	_VM_List_Update()
	Else
	$VMStart = GUICtrlCreateCombo("", 33, 268, 417, 21, $CBS_DROPDOWNLIST)
	_VM_List_Update()
	Endif
    If IniRead($var1, "startvm", "key", "NotFound") = false Then
	GUICtrlSetState($VMStart, $GUI_DISABLE)
	Else
	GUICtrlSetState($VMStart, $GUI_ENABLE)
	GUICtrlSetState($Checkboxsett_24, $GUI_CHECKED)
	Endif

    GUICtrlCreateButton(_GetTranslation($Lang, "messages", "02"), 112, 302, 129, 27)
    GUICtrlSetOnEvent(-1, "_SaveSettings")
    GUICtrlCreateButton(_GetTranslation($Lang, "messages", "03"), 336, 302, 129, 27)
    GUICtrlSetOnEvent(-1, "_CloseGUI")


	GUICtrlCreateTabItem(_GetTranslation($Lang, "system", "01"))
	$Checkboxsett_200 = GUICtrlCreateCheckbox("", 16, 40, 14, 14)
	Local $Short_UserHome = StringRegExpReplace($UserHome, "(?i)^.*?(\.VirtualBox)", "$1")
	GUICtrlCreateLabel(_GetTranslation($Lang, "system", "02")&" ("&$Short_UserHome&"\*.log)", 32, 39, 546, 14)
	$Checkboxsett_201 = GUICtrlCreateCheckbox("", 16, 60, 14, 14)
	Local $Short_MachineFolder = StringRegExpReplace($DefaultMachineFolder, "(?i)^.*?(\.VirtualBox)", "$1")
	GUICtrlCreateLabel(_GetTranslation($Lang, "system", "03")&" ("&$Short_MachineFolder&"\...\*.log.*)", 32, 59, 546, 14)
	$Checkboxsett_202 = GUICtrlCreateCheckbox("", 16, 80, 14, 14)
	GUICtrlCreateLabel(_GetTranslation($Lang, "system", "04"), 32, 79, 546, 14)
	If IniRead($var1, "Core_Logs", "key", "NotFound") = 1 Then GUICtrlSetState($Checkboxsett_200, $GUI_CHECKED)
	If IniRead($var1, "VM_Logs", "key", "NotFound") = 1 Then GUICtrlSetState($Checkboxsett_201, $GUI_CHECKED)
	If IniRead($var1, "PortableMode", "key", "NotFound") = 1 Then GUICtrlSetState($Checkboxsett_202, $GUI_CHECKED)

    GUICtrlCreateButton(_GetTranslation($Lang, "messages", "02"), 112, 302, 129, 27)
    GUICtrlSetOnEvent(-1, "_SaveSettings")
    GUICtrlCreateButton(_GetTranslation($Lang, "messages", "03"), 336, 302, 129, 27)
    GUICtrlSetOnEvent(-1, "_CloseGUI")


    GUICtrlCreateTabItem(_GetTranslation($Lang, "hotkey-settings", "01"))
    GUICtrlCreateLabel(_GetTranslation($Lang, "hotkey-settings", "02"), 16, 40, 546, 60)

    $Radio7 = GUICtrlCreateRadio("Radio7", 20, 115, 14, 14)
    If IniRead($var1, "hotkeys", "userkey", "NotFound") = 0 Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf

    $Radio8 = GUICtrlCreateRadio("Radio8", 154, 115, 14, 14)
    If IniRead($var1, "hotkeys", "userkey", "NotFound") = 1 Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf

    GUICtrlCreateLabel(_GetTranslation($Lang, "hotkey-settings", "03"), 38, 113, 100, 122)

    GUICtrlCreateLabel(_GetTranslation($Lang, "tray", "01") &":", 172, 113, 120, 17)
    GUICtrlCreateLabel(_GetTranslation($Lang, "tray", "02") &":", 172, 133, 120, 17)
    GUICtrlCreateLabel(_GetTranslation($Lang, "tray", "03") &":", 172, 153, 120, 17)
    GUICtrlCreateLabel(_GetTranslation($Lang, "tray", "04") &":", 172, 173, 120, 17)
    GUICtrlCreateLabel(_GetTranslation($Lang, "tray", "05") &":", 172, 193, 120, 17)
    GUICtrlCreateLabel(_GetTranslation($Lang, "tray", "06") &":", 172, 213, 120, 17)
    GUICtrlCreateLabel(_GetTranslation($Lang, "tray", "07") &":", 172, 233, 120, 17)

    GUICtrlCreateLabel("CTRL +", 318, 113, 44, 17)
    GUICtrlCreateLabel("CTRL +", 318, 133, 44, 17)
    GUICtrlCreateLabel("CTRL +", 318, 153, 44, 17)
    GUICtrlCreateLabel("CTRL +", 318, 173, 44, 17)
    GUICtrlCreateLabel("CTRL +", 318, 193, 44, 17)
    GUICtrlCreateLabel("CTRL +", 318, 213, 44, 17)
    GUICtrlCreateLabel("CTRL +", 318, 233, 44, 17)

    GUICtrlCreateLabel("ALT +", 395, 113, 44, 17)
    GUICtrlCreateLabel("ALT +", 395, 133, 44, 17)
    GUICtrlCreateLabel("ALT +", 395, 153, 44, 17)
    GUICtrlCreateLabel("ALT +", 395, 173, 44, 17)
    GUICtrlCreateLabel("ALT +", 395, 193, 44, 17)
    GUICtrlCreateLabel("ALT +", 395, 213, 44, 17)
    GUICtrlCreateLabel("ALT +", 395, 233, 44, 17)

    GUICtrlCreateLabel("SHIFT +", 460, 113, 44, 17)
    GUICtrlCreateLabel("SHIFT +", 460, 133, 44, 17)
    GUICtrlCreateLabel("SHIFT +", 460, 153, 44, 17)
    GUICtrlCreateLabel("SHIFT +", 460, 173, 44, 17)
    GUICtrlCreateLabel("SHIFT +", 460, 193, 44, 17)
    GUICtrlCreateLabel("SHIFT +", 460, 213, 44, 17)
    GUICtrlCreateLabel("SHIFT +", 460, 233, 44, 17)

    $Checkbox01 = GUICtrlCreateCheckbox("Checkbox01", 302, 112, 14, 14)
    If IniRead($var1, "hotkeys", "ShowWindows_VM_CTRL", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox02 = GUICtrlCreateCheckbox("Checkbox02", 302, 132, 14, 14)
    If IniRead($var1, "hotkeys", "HideWindows_VM_CTRL", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox03 = GUICtrlCreateCheckbox("Checkbox03", 302, 152, 14, 14)
    If IniRead($var1, "hotkeys", "ShowWindows_CTRL", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox04 = GUICtrlCreateCheckbox("Checkbox04", 302, 172, 14, 14)
    If IniRead($var1, "hotkeys", "HideWindows_CTRL", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox05 = GUICtrlCreateCheckbox("Checkbox05", 302, 192, 14, 14)
    If IniRead($var1, "hotkeys", "Settings_CTRL", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox06 = GUICtrlCreateCheckbox("Checkbox06", 302, 212, 14, 14)
    If IniRead($var1, "hotkeys", "OpenCmd_CTRL", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox07 = GUICtrlCreateCheckbox("Checkbox07", 302, 232, 14, 14)
    If IniRead($var1, "hotkeys", "ExitScript_CTRL", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf

    $Checkbox08 = GUICtrlCreateCheckbox("Checkbox08", 378, 112, 14, 14)
    If IniRead($var1, "hotkeys", "ShowWindows_VM_ALT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox09 = GUICtrlCreateCheckbox("Checkbox09", 378, 132, 14, 14)
    If IniRead($var1, "hotkeys", "HideWindows_VM_ALT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox10 = GUICtrlCreateCheckbox("Checkbox10", 378, 152, 14, 14)
    If IniRead($var1, "hotkeys", "ShowWindows_ALT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox11 = GUICtrlCreateCheckbox("Checkbox11", 378, 172, 14, 14)
    If IniRead($var1, "hotkeys", "HideWindows_ALT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox12 = GUICtrlCreateCheckbox("Checkbox12", 378, 192, 14, 14)
    If IniRead($var1, "hotkeys", "Settings_ALT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox13 = GUICtrlCreateCheckbox("Checkbox13", 378, 212, 14, 14)
    If IniRead($var1, "hotkeys", "OpenCmd_ALT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox14 = GUICtrlCreateCheckbox("Checkbox14", 378, 232, 14, 14)
    If IniRead($var1, "hotkeys", "ExitScript_ALT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf

    $Checkbox15 = GUICtrlCreateCheckbox("Checkbox15", 444, 112, 14, 14)
    If IniRead($var1, "hotkeys", "ShowWindows_VM_SHIFT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox16 = GUICtrlCreateCheckbox("Checkbox16", 444, 132, 14, 14)
    If IniRead($var1, "hotkeys", "HideWindows_VM_SHIFT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox17 = GUICtrlCreateCheckbox("Checkbox17", 444, 152, 14, 14)
    If IniRead($var1, "hotkeys", "ShowWindows_SHIFT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox18 = GUICtrlCreateCheckbox("Checkbox18", 444, 172, 14, 14)
    If IniRead($var1, "hotkeys", "HideWindows_SHIFT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox19 = GUICtrlCreateCheckbox("Checkbox19", 444, 192, 14, 14)
    If IniRead($var1, "hotkeys", "Settings_SHIFT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox20 = GUICtrlCreateCheckbox("Checkbox20", 444, 212, 14, 14)
    If IniRead($var1, "hotkeys", "OpenCmd_SHIFT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf
    $Checkbox21 = GUICtrlCreateCheckbox("Checkbox21", 444, 232, 14, 14)
    If IniRead($var1, "hotkeys", "ExitScript_SHIFT", "NotFound") = "1" Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf

    $Input1 = GUICtrlCreateInput(IniRead($var1, "hotkeys", "ShowWindows_VM_KEY", "NotFound"), 524, 111, 24, 21)
	GUICtrlSetLimit($Input1, 1)
    $Input2 = GUICtrlCreateInput(IniRead($var1, "hotkeys", "HideWindows_VM_KEY", "NotFound"), 524, 131, 24, 21)
	GUICtrlSetLimit($Input2, 1)
    $Input3 = GUICtrlCreateInput(IniRead($var1, "hotkeys", "ShowWindows_KEY", "NotFound"), 524, 151, 24, 21)
	GUICtrlSetLimit($Input3, 1)
    $Input4 = GUICtrlCreateInput(IniRead($var1, "hotkeys", "HideWindows_KEY", "NotFound"), 524, 171, 24, 21)
	GUICtrlSetLimit($Input4, 1)
    $Input5 = GUICtrlCreateInput(IniRead($var1, "hotkeys", "Settings_KEY", "NotFound"), 524, 191, 24, 21)
	GUICtrlSetLimit($Input5, 1)
    $Input6 = GUICtrlCreateInput(IniRead($var1, "hotkeys", "OpenCmd_KEY", "NotFound"), 524, 211, 24, 21)
	GUICtrlSetLimit($Input6, 1)
    $Input7 = GUICtrlCreateInput(IniRead($var1, "hotkeys", "ExitScript_KEY", "NotFound"), 524, 231, 24, 21)
	GUICtrlSetLimit($Input7, 1)

    GUICtrlCreateButton(_GetTranslation($Lang, "messages", "02"), 112, 302, 129, 27)
    GUICtrlSetOnEvent(-1, "_OKHotKeysSet")
    GUICtrlCreateButton(_GetTranslation($Lang, "messages", "03"), 336, 302, 129, 27)
    GUICtrlSetOnEvent(-1, "_CloseGUI")


    GUICtrlCreateTabItem(_GetTranslation($Lang, "about", "01"))
    GUICtrlCreateLabel(". : Portable-VirtualBox Launcher v"& $version &" : .", 100, 40, 448, 26)
	GUICtrlSetOnEvent(-1, "_Github")
    GUICtrlSetFont(-1, 14, 800, 4, "Arial")
    GUICtrlCreateLabel("Download and Support: http://github.com/Deac2/Portable-VirtualBox", 40, 70, 500, 20)
	GUICtrlSetOnEvent(-1, "_Github")
    GUICtrlSetFont(-1, 8, 800, 0, "Arial")
    GUICtrlCreateLabel("VirtualBox is a family of powerful x86 virtualization products for enterprise as well as home use. Not only is VirtualBox an extremely feature rich, high performance product for enterprise customers, it is also the only professional solution that is freely available as Open Source Software under the terms of the GNU General Public License(GPL).", 16, 94, 546, 55)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    GUICtrlCreateLabel("Download and Support: http://www.virtualbox.org", 88, 133, 300, 14)
    GUICtrlSetFont(-1, 8, 800, 0, "Arial")
    GUICtrlCreateLabel("Presently, VirtualBox runs on Windows, Linux, Macintosh and OpenSolaris hosts and supports a large number of guest operating systems including but not limited to Windows(NT 4.0, 2000, XP, Server 2003, Vista), DOS/Windows 3.x, Linux(2.4 and 2.6), and OpenBSD.", 16, 149, 546, 40)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    GUICtrlCreateLabel("VirtualBox is being actively developed with frequent releases and has an ever growing list of features, supported guest operating systems and platforms it runs on. VirtualBox is a community effort backed by a dedicated company: everyone is encouraged to contribute while Sun ensures the product always meets professional quality criteria.", 16, 192, 546, 40)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")

    GUICtrlCreateButton(_GetTranslation($Lang, "messages", "03"), 236, 240, 129, 27)
    GUICtrlSetOnEvent(-1, "_CloseGUI")

    GUISetState()
	Endif
EndFunc

Func _UpdateSettings()
_IniWrite($var1, "hotkeys", "key", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "userkey", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_VM_CTRL", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_VM_ALT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_VM_SHIFT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_VM_KEY", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_VM_CTRL", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_VM_ALT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_VM_SHIFT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_VM_KEY", "2", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_CTRL", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_ALT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_SHIFT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "ShowWindows_KEY", "3", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_CTRL", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_ALT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_SHIFT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "HideWindows_KEY", "4", $ini_encoding)
_IniWrite($var1, "hotkeys", "OpenCmd_CTRL", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "OpenCmd_ALT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "OpenCmd_SHIFT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "OpenCmd_KEY", "5", $ini_encoding)
_IniWrite($var1, "hotkeys", "Settings_CTRL", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "Settings_ALT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "Settings_SHIFT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "Settings_KEY", "6", $ini_encoding)
_IniWrite($var1, "hotkeys", "ExitScript_CTRL", "1", $ini_encoding)
_IniWrite($var1, "hotkeys", "ExitScript_ALT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "ExitScript_SHIFT", "0", $ini_encoding)
_IniWrite($var1, "hotkeys", "ExitScript_KEY", "7", $ini_encoding)
_IniWrite($var1, "usb", "key", "0", $ini_encoding)
_IniWrite($var1, "net", "key", "0", $ini_encoding)
_IniWrite($var1, "userhome", "key", $DefaultUserHome, $ini_encoding)
_IniWrite($var1, "machinefolder", "key", $DefaultMachineFolder, $ini_encoding)
_IniWrite($var1, "Core_Logs", "key", "1", $ini_encoding)
_IniWrite($var1, "VM_Logs", "key", "1", $ini_encoding)
_IniWrite($var1, "PortableMode", "key", "0", $ini_encoding)
_IniWrite($var1, "userhome", "sort", "1", $ini_encoding)
_IniWrite($var1, "startvm", "key", "", $ini_encoding)

If NOT IniRead($var1, "lang", "key", "") = 0 AND IniRead($var1, "lang", "key", "") = 2 Then
_IniWrite($var1, "language", "date", $Lang_changes, $ini_encoding)
Else
IniDelete($var1, "language", "date")
Endif

If NOT IniRead($var1, "lang", "key", "") = 0 AND NOT _IsLangValid(IniRead($var1, "language", "key", "False")) Then
If IsArray($english) Then
_IniWrite($var1, "language", "key", "English", $ini_encoding, true)
Else
	If $Languages.Exists("english") Then
	$CurrentLang = "english"
	Else
	Local $aKeys = $Languages.Keys()
	If IsArray($aKeys) And UBound($aKeys) > 0 Then
	$CurrentLang = $aKeys[0]
	_IniWrite($var1, "language", "key", _FirstLetterUpper($CurrentLang), $ini_encoding, true)
	EndIf
	EndIf
EndIf
Else
EndIf

$Lang = IniRead($var1, "language", "key", "NotFound")
Global $UserHome = IniRead($var1, "userhome", "key", "NotFound")
Global $MachineFolder = IniRead($var1, "machinefolder", "key", "NotFound")
Global $VMStartName = IniRead($var1, "startvm", "key", "")
EndFunc

Func _SaveSettings()
	Local $Net = (GUICtrlRead($Checkboxsett_19) = $GUI_CHECKED ? "1" : "0")
    IniWrite($var1, "net", "key", $Net)
	Local $USB = (GUICtrlRead($Checkboxsett_20) = $GUI_CHECKED ? "1" : "0")
    IniWrite($var1, "usb", "key", $USB)
	Local $hotkeys = (GUICtrlRead($Checkboxsett_21) = $GUI_CHECKED ? "1" : "0")
    IniWrite($var1, "hotkeys", "key", $hotkeys)

    If IniRead($var1, "language", "key", "") <> GUICtrlRead($StartLng) Then
		IniWrite($var1, "language", "key", GUICtrlRead($StartLng))
    EndIf

	Local $CheckHomeRoot = GUICtrlRead($Checkboxsett_22)
	Local $homedir = GUICtrlRead($HomeRoot)
	If Not ($CheckHomeRoot = 1) Then
    IniWrite($var1, "userhome", "key", $DefaultUserHome)
    GUICtrlSetData($HomeRoot, $DefaultUserHome)
	Else
	GUICtrlSetData($HomeRoot, _ValidatePath($homedir, $DefaultUserHome))
	IniWrite($var1, "userhome", "key", _ValidatePath($homedir, $DefaultUserHome))
	EndIf

	Local $CheckMachineRoot = GUICtrlRead($Checkboxsett_23)
	Local $MachineDir = GUICtrlRead($MachineRoot)
	If Not ($CheckMachineRoot = 1) Then
    IniWrite($var1, "machinefolder", "key", $DefaultMachineFolder)
    GUICtrlSetData($MachineRoot, $DefaultMachineFolder)
	Else
	GUICtrlSetData($MachineRoot, _ValidatePath($MachineDir, $DefaultMachineFolder))
	IniWrite($var1, "machinefolder", "key", _ValidatePath($MachineDir, $DefaultMachineFolder))
	EndIf

	Local $CheckVMStart = GUICtrlRead($Checkboxsett_24)
	Local $VMStartName = GUICtrlRead($VMStart)

	Local $OldMachineFolder = IniRead($var1, "machinefolder", "key", "NotFound")
	If $OldMachineFolder <> $DefaultMachineFolder and Not ($CheckMachineRoot=1) Then
    IniWrite($var1, "startvm", "key", "")
	GUICtrlSetState($Checkboxsett_24, $GUI_UNCHECKED)
	GUICtrlSetState($VMStart, $GUI_DISABLE)
	EndIf

	If Not ($CheckVMStart=1) or $OldMachineFolder<>$MachineDir Then
    IniWrite($var1, "startvm", "key", "")
	GUICtrlSetState($Checkboxsett_24, $GUI_UNCHECKED)
	GUICtrlSetState($VMStart, $GUI_DISABLE)
	Else
	Local $Patch = ""
	$VMStartSearch = StringRegExpReplace($VMStartName, "\h*[{}\[\]]+\h*", "_")
	$aArray = _RecFileListToArray($MachineFolder, "*"&$VMStartSearch&".vbox", 1, 1, 0, 2)
    If IsArray($aArray) Then
		For $i = 1 To $aArray[0]
		local $Patch = $aArray[$i]
		Next
    Endif

	if StringRegExp($VMStartName, "{[[:xdigit:]]{8}-[[:xdigit:]]{4}-[34][[:xdigit:]]{3}-[89abAB][[:xdigit:]]{3}-[[:xdigit:]]{12}}") Then
	IniWrite($var1, "startvm", "key", $VMStartName)
	Else
	If FileExists($Patch) Then
      IniWrite($var1, "startvm", "key", $VMStartName)
	Else
	  _VM_List_Update()
	EndIf
	EndIf
	EndIf

	Local $Core_Logs = (GUICtrlRead($Checkboxsett_200) = $GUI_CHECKED ? "1" : "0")
    IniWrite($var1, "Core_Logs", "key", $Core_Logs)
	Local $VM_Logs = (GUICtrlRead($Checkboxsett_201) = $GUI_CHECKED ? "1" : "0")
    IniWrite($var1, "VM_Logs", "key", $VM_Logs)
	Local $PortableMode = (GUICtrlRead($Checkboxsett_202) = $GUI_CHECKED ? "1" : "0")
    IniWrite($var1, "PortableMode", "key", $PortableMode)

	_UpdateSettings()
	MsgBox(0+262144, _GetTranslation($Lang, "messages", "04"), _GetTranslation($Lang, "messages", "05"))
EndFunc

Func _CheckboxSettings()
Local $CheckHomeRoot = GUICtrlRead($Checkboxsett_22)
If Not ($CheckHomeRoot=4) Then
GUICtrlSetState($HomeRoot, $GUI_ENABLE)
GUICtrlSetState($BTNUserHome, $GUI_ENABLE)
Else
GUICtrlSetState($HomeRoot, $GUI_DISABLE)
GUICtrlSetState($BTNUserHome, $GUI_DISABLE)
EndIf

Local $CheckMachineRoot = GUICtrlRead($Checkboxsett_23)
If Not ($CheckMachineRoot=4) Then
GUICtrlSetState($MachineRoot, $GUI_ENABLE)
GUICtrlSetState($BTNMachineFolder, $GUI_ENABLE)
Else
GUICtrlSetState($MachineRoot, $GUI_DISABLE)
GUICtrlSetState($BTNMachineFolder, $GUI_DISABLE)
EndIf

Local $CheckVMStart = GUICtrlRead($Checkboxsett_24)
If Not ($CheckVMStart=4) Then
GUICtrlSetState($VMStart, $GUI_ENABLE)
Else
GUICtrlSetState($VMStart, $GUI_DISABLE)
EndIf
EndFunc

Func _SRCUserHome()
  Local $PathHR = FileSelectFolder(_GetTranslation($Lang, "settings", "10"), "", 1+4)
  If NOT @error Then
    GUICtrlSetData($HomeRoot, $PathHR)
  EndIf
EndFunc

Func _SRCMachineFolder()
  Local $PathHR = FileSelectFolder(_GetTranslation($Lang, "settings", "11"), "", 1+4)
  If NOT @error Then
    GUICtrlSetData($MachineRoot, $PathHR)
  EndIf
EndFunc

Func _OKHotKeysSet()
  If GUICtrlRead($Radio7) = $GUI_CHECKED Then
    IniWrite($var1, "hotkeys", "userkey", "0")
    IniWrite($var1, "hotkeys", "ShowWindows_VM_CTRL", "1")
    IniWrite($var1, "hotkeys", "ShowWindows_VM_ALT", "0")
    IniWrite($var1, "hotkeys", "ShowWindows_VM_SHIFT", "0")
    IniWrite($var1, "hotkeys", "ShowWindows_VM_KEY", "1")

    IniWrite($var1, "hotkeys", "HideWindows_VM_CTRL", "1")
    IniWrite($var1, "hotkeys", "HideWindows_VM_ALT", "0")
    IniWrite($var1, "hotkeys", "HideWindows_VM_SHIFT", "0")
    IniWrite($var1, "hotkeys", "HideWindows_VM_KEY", "2")

    IniWrite($var1, "hotkeys", "ShowWindows_CTRL", "1")
    IniWrite($var1, "hotkeys", "ShowWindows_ALT", "0")
    IniWrite($var1, "hotkeys", "ShowWindows_SHIFT", "0")
    IniWrite($var1, "hotkeys", "ShowWindows_KEY", "3")

    IniWrite($var1, "hotkeys", "HideWindows_CTRL", "1")
    IniWrite($var1, "hotkeys", "HideWindows_ALT", "0")
    IniWrite($var1, "hotkeys", "HideWindows_SHIFT", "0")
    IniWrite($var1, "hotkeys", "HideWindows_KEY", "4")

    IniWrite($var1, "hotkeys", "OpenCmd_CTRL", "1")
    IniWrite($var1, "hotkeys", "OpenCmd_ALT", "0")
    IniWrite($var1, "hotkeys", "OpenCmd_SHIFT", "0")
    IniWrite($var1, "hotkeys", "OpenCmd_KEY", "5")

    IniWrite($var1, "hotkeys", "Settings_CTRL", "1")
    IniWrite($var1, "hotkeys", "Settings_ALT", "0")
    IniWrite($var1, "hotkeys", "Settings_SHIFT", "0")
    IniWrite($var1, "hotkeys", "Settings_KEY", "6")

    IniWrite($var1, "hotkeys", "ExitScript_CTRL", "1")
    IniWrite($var1, "hotkeys", "ExitScript_ALT", "0")
    IniWrite($var1, "hotkeys", "ExitScript_SHIFT", "0")
    IniWrite($var1, "hotkeys", "ExitScript_KEY", "7")
    MsgBox(0+262144, _GetTranslation($Lang, "messages", "04"), _GetTranslation($Lang, "messages", "05"))
  Else
    If GUICtrlRead($Input1) = false OR GUICtrlRead($Input2) = false OR GUICtrlRead($Input3) = false OR GUICtrlRead($Input4) = false OR GUICtrlRead($Input5) = false OR GUICtrlRead($Input6) = false Then
      MsgBox(0, _GetTranslation($Lang, "messages", "01"), _GetTranslation($Lang, "okhotkeysset", "01"))
    Else
      IniWrite($var1, "hotkeys", "userkey", "1")
      If GUICtrlRead($CheckBox01) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ShowWindows_VM_CTRL", "1")
      Else
        IniWrite($var1, "hotkeys", "ShowWindows_VM_CTRL", "0")
      EndIf
      If GUICtrlRead($CheckBox02) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "HideWindows_VM_CTRL", "1")
      Else
        IniWrite($var1, "hotkeys", "HideWindows_VM_CTRL", "0")
      EndIf
      If GUICtrlRead($CheckBox03) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ShowWindows_CTRL", "1")
      Else
        IniWrite($var1, "hotkeys", "ShowWindows_CTRL", "0")
      EndIf
      If GUICtrlRead($CheckBox04) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "HideWindows_CTRL", "1")
      Else
        IniWrite($var1, "hotkeys", "HideWindows_CTRL", "0")
      EndIf
      If GUICtrlRead($CheckBox05) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "Settings_CTRL", "1")
      Else
        IniWrite($var1, "hotkeys", "Settings_CTRL", "0")
      EndIf
      If GUICtrlRead($CheckBox06) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "OpenCmd_CTRL", "1")
      Else
        IniWrite($var1, "hotkeys", "OpenCmd_CTRL", "0")
      EndIf
      If GUICtrlRead($CheckBox07) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ExitScript_CTRL", "1")
      Else
        IniWrite($var1, "hotkeys", "ExitScript_CTRL", "0")
      EndIf

      If GUICtrlRead($CheckBox08) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ShowWindows_VM_ALT", "1")
      Else
        IniWrite($var1, "hotkeys", "ShowWindows_VM_ALT", "0")
      EndIf
      If GUICtrlRead($CheckBox09) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "HideWindows_VM_ALT", "1")
      Else
        IniWrite($var1, "hotkeys", "HideWindows_VM_ALT", "0")
      EndIf
      If GUICtrlRead($CheckBox10) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ShowWindows_ALT", "1")
      Else
        IniWrite($var1, "hotkeys", "ShowWindows_ALT", "0")
      EndIf
      If GUICtrlRead($CheckBox11) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "HideWindows_ALT", "1")
      Else
        IniWrite($var1, "hotkeys", "HideWindows_ALT", "0")
      EndIf
      If GUICtrlRead($CheckBox12) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "Settings_ALT", "1")
      Else
        IniWrite($var1, "hotkeys", "Settings_ALT", "0")
      EndIf
      If GUICtrlRead($CheckBox13) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "OpenCmd_ALT", "1")
      Else
        IniWrite($var1, "hotkeys", "OpenCmd_ALT", "0")
      EndIf
      If GUICtrlRead($CheckBox14) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ExitScript_ALT", "1")
      Else
        IniWrite($var1, "hotkeys", "ExitScript_ALT", "0")
      EndIf

      If GUICtrlRead($CheckBox15) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ShowWindows_VM_SHIFT", "1")
      Else
        IniWrite($var1, "hotkeys", "ShowWindows_VM_SHIFT", "0")
      EndIf
      If GUICtrlRead($CheckBox16) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "HideWindows_VM_SHIFT", "1")
      Else
        IniWrite($var1, "hotkeys", "HideWindows_VM_SHIFT", "0")
      EndIf
      If GUICtrlRead($CheckBox17) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ShowWindows_SHIFT", "1")
      Else
        IniWrite($var1, "hotkeys", "ShowWindows_SHIFT", "0")
      EndIf
      If GUICtrlRead($CheckBox18) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "HideWindows_SHIFT", "1")
      Else
        IniWrite($var1, "hotkeys", "HideWindows_SHIFT", "0")
      EndIf
      If GUICtrlRead($CheckBox19) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "Settings_SHIFT", "1")
      Else
        IniWrite($var1, "hotkeys", "Settings_SHIFT", "0")
      EndIf
      If GUICtrlRead($CheckBox20) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "OpenCmd_SHIFT", "1")
      Else
        IniWrite($var1, "hotkeys", "OpenCmd_SHIFT", "0")
      EndIf
      If GUICtrlRead($CheckBox21) = $GUI_CHECKED Then
        IniWrite($var1, "hotkeys", "ExitScript_SHIFT", "1")
      Else
        IniWrite($var1, "hotkeys", "ExitScript_SHIFT", "0")
      EndIf

      IniWrite($var1, "hotkeys", "ShowWindows_VM_KEY", GUICtrlRead($Input1))
      IniWrite($var1, "hotkeys", "HideWindows_VM_KEY", GUICtrlRead($Input2))
      IniWrite($var1, "hotkeys", "ShowWindows_KEY", GUICtrlRead($Input3))
      IniWrite($var1, "hotkeys", "HideWindows_KEY", GUICtrlRead($Input4))
      IniWrite($var1, "hotkeys", "Settings_KEY", GUICtrlRead($Input5))
      IniWrite($var1, "hotkeys", "OpenCmd_KEY", GUICtrlRead($Input6))
	  IniWrite($var1, "hotkeys", "ExitScript_KEY", GUICtrlRead($Input7))
      MsgBox(0+262144, _GetTranslation($Lang, "messages", "04"), _GetTranslation($Lang, "messages", "05"))
    EndIf
  EndIf
EndFunc

Func _OKLanguage()
_UpdateSettings()
_IniWrite($var1, "language", "key", GUICtrlRead($StartLng), $ini_encoding)
If GUICtrlRead($CheckboxLang) = $GUI_CHECKED Then
_IniWrite($var1, "lang", "key", "2", $ini_encoding)
Else
_IniWrite($var1, "lang", "key", "1", $ini_encoding)
Endif
$cl = 0
EndFunc

Func _ReadHotkey($ActionName)
    Local $Result = ""

    Local $Ctrl  = IniRead($var1, "hotkeys", $ActionName & "_CTRL", "0")
    Local $Alt   = IniRead($var1, "hotkeys", $ActionName & "_ALT", "0")
    Local $Shift = IniRead($var1, "hotkeys", $ActionName & "_SHIFT", "0")
    Local $Key   = IniRead($var1, "hotkeys", $ActionName & "_Key", "")
    
    ; If the main key is not specified, the hotkey is empty
    If $Key == "" Then Return ""
    
    ; Gluing modifiers into one line
    If $Ctrl == "1"  Then $Result &= "^"
    If $Alt == "1"   Then $Result &= "!"
    If $Shift == "1" Then $Result &= "+"
    
    Return $Result & $Key
EndFunc

Func _GetHotkeyText($Hotkey)
    If $Hotkey == "" Then Return ""
    Local $KeyText = ""

    If StringInStr($Hotkey, "^") Then $KeyText &= "CTRL+"
    If StringInStr($Hotkey, "!") Then $KeyText &= "ALT+"
    If StringInStr($Hotkey, "+") Then $KeyText &= "SHIFT+"

    Local $Key = StringRegExpReplace($Hotkey, "[\^!\+#]", "")
    
    $KeyText &= StringUpper($Key)
    Return " (" & $KeyText & ")"
EndFunc

Func _TrayMenu()
If NOT (FileExists(@ScriptDir&"\app32\VirtualBox.exe") OR FileExists(@ScriptDir&"\app64\VirtualBox.exe")) Then
      If IniRead($var1, "hotkeys", "key", "NotFound") = 1 Then
		Local $Settings_Hotkey = _ReadHotkey("Settings")
		If $Settings_Hotkey <> "" Then HotKeySet($Settings_Hotkey, "_Settings")
		Local $Exit_Hotkey = _ReadHotkey("ExitScript")
		If $Exit_Hotkey <> "" Then HotKeySet($Exit_Hotkey, "_ExitGUI")
      EndIf

  TrayCreateItem(_GetTranslation($Lang, "tray", "06") & _GetHotkeyText($Settings_Hotkey))
  TrayItemSetOnEvent(-1, "_Settings")
  TrayCreateItem("")
  TrayCreateItem(_GetTranslation($Lang, "tray", "07") & _GetHotkeyText($Exit_Hotkey))
  TrayItemSetOnEvent(-1, "_ExitGUI")
  TraySetState()
  TraySetToolTip(_GetTranslation($Lang, "tray", "08"))
  TrayTip("", _GetTranslation($Lang, "tray", "08"), 5)
Else
      If IniRead($var1, "hotkeys", "key", "NotFound") = 1 Then
		Local $ShowVM_Hotkey = _ReadHotkey("ShowWindows_VM")
		If $ShowVM_Hotkey <> "" Then HotKeySet($ShowVM_Hotkey, "_ShowWindows_VM")
		Local $HideVM_Hotkey = _ReadHotkey("HideWindows_VM")
		If $HideVM_Hotkey <> "" Then HotKeySet($HideVM_Hotkey, "_HideWindows_VM")
		Local $ShowVB_Hotkey = _ReadHotkey("ShowWindows")
		If $ShowVB_Hotkey <> "" Then HotKeySet($ShowVB_Hotkey, "_ShowWindows")
		Local $HideVB_Hotkey = _ReadHotkey("HideWindows")
		If $HideVB_Hotkey <> "" Then HotKeySet($HideVB_Hotkey, "_HideWindows")

		Local $Settings_Hotkey = _ReadHotkey("Settings")
		If $Settings_Hotkey <> "" Then HotKeySet($Settings_Hotkey, "_Settings")
		Local $OpenCmd_Hotkey = _ReadHotkey("OpenCmd")
		If $OpenCmd_Hotkey <> "" Then HotKeySet($OpenCmd_Hotkey, "_OpenCmd")
		Local $Exit_Hotkey = _ReadHotkey("ExitScript")
		If $Exit_Hotkey <> "" Then HotKeySet($Exit_Hotkey, "_ExitScript")

        TrayCreateItem(_GetTranslation($Lang, "tray", "01") & _GetHotkeyText($ShowVM_Hotkey))
        TrayItemSetOnEvent(-1, "_ShowWindows_VM")
        TrayCreateItem(_GetTranslation($Lang, "tray", "02") & _GetHotkeyText($HideVM_Hotkey))
        TrayItemSetOnEvent(-1, "_HideWindows_VM")
        TrayCreateItem("")
        TrayCreateItem(_GetTranslation($Lang, "tray", "03") & _GetHotkeyText($ShowVB_Hotkey))
        TrayItemSetOnEvent(-1, "_ShowWindows")
        TrayCreateItem(_GetTranslation($Lang, "tray", "04") & _GetHotkeyText($HideVB_Hotkey))
        TrayItemSetOnEvent(-1, "_HideWindows")
        TrayCreateItem("")
        TrayCreateItem(_GetTranslation($Lang, "tray", "05") & _GetHotkeyText($OpenCmd_Hotkey))
        TrayItemSetOnEvent(-1, "_OpenCmd")
        TrayCreateItem(_GetTranslation($Lang, "tray", "06") & _GetHotkeyText($Settings_Hotkey))
        TrayItemSetOnEvent(-1, "_Settings")
        TrayCreateItem("")
        TrayCreateItem(_GetTranslation($Lang, "tray", "07") & _GetHotkeyText($Exit_Hotkey))
        TrayItemSetOnEvent(-1, "_ExitScript")
        TraySetState()
        TraySetToolTip(_GetTranslation($Lang, "tray", "08"))
        TrayTip("", _GetTranslation($Lang, "tray", "08"), 5)
      Else
        TrayCreateItem(_GetTranslation($Lang, "tray", "01"))
        TrayItemSetOnEvent(-1, "_ShowWindows_VM")
        TrayCreateItem(_GetTranslation($Lang, "tray", "02"))
        TrayItemSetOnEvent(-1, "_HideWindows_VM")
        TrayCreateItem("")
        TrayCreateItem(_GetTranslation($Lang, "tray", "03"))
        TrayItemSetOnEvent(-1, "_ShowWindows")
        TrayCreateItem(_GetTranslation($Lang, "tray", "04"))
        TrayItemSetOnEvent(-1, "_HideWindows")
        TrayCreateItem("")
        TrayCreateItem(_GetTranslation($Lang, "tray", "06"))
        TrayItemSetOnEvent(-1, "_Settings")
        TrayCreateItem("")
        TrayCreateItem(_GetTranslation($Lang, "tray", "07"))
        TrayItemSetOnEvent(-1, "_ExitScript")
        TraySetState()
        TraySetToolTip(_GetTranslation($Lang, "tray", "08"))
        TrayTip("", _GetTranslation($Lang, "tray", "08"), 5)
      EndIf
Endif
EndFunc

Func _CloseGUI()
  AdlibUnRegister("_VM_List_Update")
  GUIDelete()
  $cl = 0
  $Settings = 0
EndFunc

Func _ExitGUI()
  GUIDelete()
  Exit
EndFunc

Func _ExitScript()
  Opt("WinTitleMatchMode", 2)
  WinClose("VirtualBoxVM", "")
  WinWaitClose("VirtualBoxVM", "")
  WinClose("] - Oracle")
  WinWaitClose("] - Oracle")
  WinClose("Oracle", "")
  _ProcessNameClose("VirtualBox.exe")
  _ProcessNameClose("VBoxManage.exe")
  _ProcessNameClose("VirtualBoxVM.exe")
  _ProcessNameClose("VBoxSVC.exe")
  _ProcessNameClose("VBoxSDS.exe")

  If $ConsolePID And ProcessExists($ConsolePID) Then
	ProcessClose($ConsolePID)
  EndIf
EndFunc

Func _ProcessNameClose($ProcessName)
	Local $ListArray = ProcessList($ProcessName)
	For $i = 1 To $ListArray[0][0]
	If ProcessExists($ListArray[$i][1]) Then
	ProcessClose($ListArray[$i][1])
	EndIf
	Next
EndFunc

Func _Start_VirtualBox()
	EnvSet("VBOX_USER_HOME", $UserHome) ;Active UserHome
    If FileExists(@ScriptDir & "\" & $App_Dir & "\drivers\vboxdrv") And _RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxDRV", "DisplayName") <> "Portable VBoxDRV" Then
        RunWait("cmd /c sc create VBoxDRV binpath= ""%CD%\" & $App_Dir & "\drivers\VBoxDrv\VBoxDrv.sys"" type= kernel start= auto error= normal displayname=""Portable VBoxDRV""", @ScriptDir, @SW_HIDE)
        RunWait("sc start VBoxDRV", @ScriptDir, @SW_HIDE)
    EndIf

    If FileExists(@ScriptDir & "\" & $App_Dir & "\drivers\vboxsup") And _RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxSUP", "DisplayName") <> "Portable VBoxSUP" Then
        RunWait("cmd /c sc create VBoxSUP binpath= ""%CD%\" & $App_Dir & "\drivers\VBoxSup\VBoxSup.sys"" type= kernel start= auto error= normal displayname=""Portable VBoxSUP""", @ScriptDir, @SW_HIDE)
        RunWait("sc start VBoxSUP", @ScriptDir, @SW_HIDE)
    EndIf

    If _RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxUSBMon", "DisplayName") <> "Portable VirtualBox USB Monitor Driver" Then
        RunWait("cmd /c sc create VBoxUSBMon binpath= ""%CD%\" & $App_Dir & "\drivers\USB\filter\VBoxUSBMon.sys"" type= kernel start= auto error= normal displayname=""Portable VirtualBox USB Monitor Driver""", @ScriptDir, @SW_HIDE)
        RunWait("sc start VBoxUSBMon", @ScriptDir, @SW_HIDE)
    EndIf

    If IniRead($var1, "usb", "key", "NotFound") = 1 Then
		If StringInStr(_RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxUSB", "DisplayName"), "VBoxUSB") = 0 Then
        ;If _RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxUSB", "DisplayName") <> "VirtualBox USB" Then
            ;RunWait(@ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe install " & $App_Dir & "\drivers\USB\device\VBoxUSB.inf ""USB\VID_80EE&PID_CAFE""", @ScriptDir, @SW_HIDE)
			RunWait("""" & @ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe"" install """ & $App_Dir & "\drivers\USB\device\VBoxUSB.inf"" ""USB\VID_80EE&PID_CAFE""", @ScriptDir, @SW_HIDE)
            FileCopy(@ScriptDir & "\" & $App_Dir & "\drivers\USB\device\VBoxUSB.sys", @WindowsDir & "\System32\drivers", 9)
            RunWait("sc start VBoxUSB", @ScriptDir, @SW_HIDE)
        EndIf
    EndIf

    If IniRead($var1, "net", "key", "NotFound") = 1 Then
        Local $ADPVER = (FileExists(@ScriptDir & "\" & $App_Dir & "\drivers\network\netadp6") ? 6 : "")
		If StringInStr(_RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxNetAdp", "DisplayName"), "VBoxNetAdp") = 0 Then
        ;If _RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxNetAdp", "DisplayName") <> "VirtualBox Host-Only Network Adapter" Then
            ;RunWait(@ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe install " & $App_Dir & "\drivers\network\netadp" & $ADPVER & "\VBoxNetAdp" & $ADPVER & ".inf ""sun_VBoxNetAdp""", @ScriptDir, @SW_HIDE)
			RunWait("""" & @ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe"" install """ & $App_Dir & "\drivers\network\netadp" & $ADPVER & "\VBoxNetAdp" & $ADPVER & ".inf"" ""sun_VBoxNetAdp""", @ScriptDir, @SW_HIDE)
            FileCopy(@ScriptDir & "\" & $App_Dir & "\drivers\network\netadp" & $ADPVER & "\VBoxNetAdp" & $ADPVER & ".sys", @WindowsDir & "\System32\drivers", 9)
            RunWait("sc start VBoxNetAdp", @ScriptDir, @SW_HIDE)
        EndIf
    EndIf

    If IniRead($var1, "net", "key", "NotFound") = 1 Then
        ;If _RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxNetFlt", "DisplayName") <> "VBoxNetFlt Service" Then
		If StringInStr(_RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxNetFlt", "DisplayName"), "VBoxNetFlt") = 0 Then
            ;RunWait(@ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe -v -u ""sun_VBoxNetFlt""", @ScriptDir, @SW_HIDE)
			RunWait("""" & @ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe"" -v -u ""sun_VBoxNetFlt""", @ScriptDir, @SW_HIDE)
            ;RunWait(@ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe -v -l " & $App_Dir & "\drivers\network\netflt\VBoxNetFlt.inf -m " & $App_Dir & "\drivers\network\netflt\VBoxNetFlt.inf -c s -i ""sun_VBoxNetFlt""", @ScriptDir, @SW_HIDE)
			RunWait("""" & @ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe"" -v -l """ & $App_Dir & "\drivers\network\netflt\VBoxNetFlt.inf"" -m """ & $App_Dir & "\drivers\network\netflt\VBoxNetFlt.inf"" -c s -i sun_VBoxNetFlt", @ScriptDir, @SW_HIDE)
            FileCopy(@ScriptDir & "\" & $App_Dir & "\drivers\network\netflt\VBoxNetFltNobj.dll", @WindowsDir & "\System32", 9)
            FileCopy(@ScriptDir & "\" & $App_Dir & "\drivers\network\netflt\VBoxNetFlt.sys", @WindowsDir & "\System32\drivers", 9)
            RunWait(@SystemDir & "\regsvr32.exe /S " & @WindowsDir & "\System32\VBoxNetFltNobj.dll", @WindowsDir & "\System32", @SW_HIDE)
            RunWait("sc start VBoxNetFlt", @ScriptDir, @SW_HIDE)
        EndIf
		If StringInStr(_RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VBoxNetLwf", "DisplayName"), "VBoxNetLwf") = 0 Then
            ;RunWait(@ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe -v -u ""oracle_VBoxNetLwf""", @ScriptDir, @SW_HIDE)
			RunWait("""" & @ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe"" -v -u ""oracle_VBoxNetLwf""", @ScriptDir, @SW_SHOW)
            ;RunWait(@ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe -v -l " & $App_Dir & "\drivers\network\netlwf\VBoxNetLwf.inf -m " & $App_Dir & "\drivers\network\netlwf\VBoxNetLwf.inf -c s -i ""oracle_VBoxNetLwf""", @ScriptDir, @SW_HIDE)
			RunWait("""" & @ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe"" -v -l """ & $App_Dir & "\drivers\network\netlwf\VBoxNetLwf.inf"" -m """ & $App_Dir & "\drivers\network\netlwf\VBoxNetLwf.inf"" -c s -i oracle_VBoxNetLwf", @ScriptDir, @SW_HIDE)
			FileCopy(@ScriptDir & "\" & $App_Dir & "\drivers\network\netlwf\VBoxNetLwf.sys", @WindowsDir & "\System32\drivers", 9)
			RunWait("sc start VBoxNetLwf", @ScriptDir, @SW_HIDE)
        EndIf
    EndIf

#cs
    RunWait($App_Dir & "\VBoxSDS.exe /RegService", @ScriptDir, @SW_HIDE)
    RunWait($App_Dir & "\VBoxSVC.exe /reregserver", @ScriptDir, @SW_HIDE)
    RunWait(@SystemDir & "\regsvr32.exe /S " & $App_Dir & "\VBoxC.dll", @ScriptDir, @SW_HIDE)
    RunWait(@SystemDir & "\regsvr32.exe /S " & $App_Dir & "\VBoxProxyStub.dll", @ScriptDir, @SW_HIDE)
	DllCall(@ScriptDir & "\" & $App_Dir & "\VBoxRT.dll", "int", "RTR3Init")
#ce


    RunWait($App_Dir & "\VBoxSDS.exe /RegService", @ScriptDir, @SW_HIDE)
    RunWait($App_Dir & "\VBoxSVC.exe /regserver", @ScriptDir, @SW_HIDE)
    If NOT @AutoItX64 AND FileExists(@ScriptDir & "\" & $App_Dir & "\x86\VBoxClient-x86.dll") AND $App_Dir = "app64" Then
	RunWait(@WindowsDir & "\SysWOW64\regsvr32.exe /S " & $App_Dir & "\x86\VBoxClient-x86.dll", @ScriptDir, @SW_HIDE)
	Else
	RunWait(@WindowsDir & "\System32\regsvr32.exe /S " & $App_Dir & "\VBoxC.dll", @ScriptDir, @SW_HIDE)
	Endif
	
	If NOT @AutoItX64 AND FileExists(@ScriptDir & "\" & $App_Dir & "\x86\VBoxProxyStub-x86.dll") AND $App_Dir = "app64" Then
	RunWait(@WindowsDir & "\SysWOW64\regsvr32.exe /S " & $App_Dir & "\x86\VBoxProxyStub-x86.dll", @ScriptDir, @SW_HIDE)
	Else
	RunWait(@WindowsDir & "\System32\regsvr32.exe /S " & $App_Dir & "\VBoxProxyStub.dll", @ScriptDir, @SW_HIDE)
	Endif

	if NOT @AutoItX64 AND FileExists(@ScriptDir & "\" & $App_Dir & "\x86\VBoxRT-x86.dll") Then
	DllCall(@ScriptDir & "\" & $App_Dir & "\x86\VBoxRT-x86.dll", "int", "RTR3Init")
	Else
	DllCall(@ScriptDir & "\" & $App_Dir & "\VBoxRT.dll", "int", "RTR3Init")
	Endif
EndFunc

Func _Stop_VirtualBox()
    Local $DRV = (_RegRead("HKLM\SYSTEM\CurrentControlSet\Services\VBoxDrv", "DisplayName") <> "" ? 1 : 0)
    Local $SUP = (_RegRead("HKLM\SYSTEM\CurrentControlSet\Services\VBoxSup", "DisplayName") <> "" ? 1 : 0)
    Local $USB = (_RegRead("HKLM\SYSTEM\CurrentControlSet\Services\VBoxUSB", "DisplayName") <> "" ? 1 : 0)
    Local $MON = (_RegRead("HKLM\SYSTEM\CurrentControlSet\Services\VBoxUSBMon", "DisplayName") <> "" ? 1 : 0)
    Local $ADP = (_RegRead("HKLM\SYSTEM\CurrentControlSet\Services\VBoxNetAdp", "DisplayName") <> "" ? 1 : 0)
	Local $NET = (_RegRead("HKLM\SYSTEM\CurrentControlSet\Services\VBoxNetFlt", "DisplayName") <> "" Or _RegRead("HKLM\SYSTEM\CurrentControlSet\Services\VBoxNetLwf", "DisplayName") <> "" ? 1 : 0)

    Local $ADPVER = (FileExists(@ScriptDir & "\" & $App_Dir & "\drivers\network\netadp6") ? 6 : "")

#cs
    RunWait($App_Dir & "\VBoxSVC.exe /unregserver", @ScriptDir, @SW_HIDE)
    RunWait(@SystemDir & "\regsvr32.exe /S /U " & $App_Dir & "\VBoxC.dll", @ScriptDir, @SW_HIDE)
    RunWait($App_Dir & "\VBoxSDS.exe /UnregService", @ScriptDir, @SW_HIDE)
    RunWait(@SystemDir & "\regsvr32.exe /S /U " & $App_Dir & "\VBoxProxyStub.dll", @ScriptDir, @SW_HIDE)
#ce
    RunWait($App_Dir & "\VBoxSVC.exe /unregserver", @ScriptDir, @SW_HIDE)
    RunWait($App_Dir & "\VBoxSDS.exe /UnregService", @ScriptDir, @SW_HIDE)
    If NOT @AutoItX64 AND FileExists(@ScriptDir & "\" & $App_Dir & "\x86\VBoxClient-x86.dll") AND $App_Dir = "app64" Then
	RunWait(@WindowsDir & "\SysWOW64\regsvr32.exe /S /U " & $App_Dir & "\x86\VBoxClient-x86.dll", @ScriptDir, @SW_HIDE)
	Else
	RunWait(@WindowsDir & "\System32\regsvr32.exe /S /U " & $App_Dir & "\VBoxC.dll", @ScriptDir, @SW_HIDE)
	Endif
	
	If NOT @AutoItX64 AND FileExists(@ScriptDir & "\" & $App_Dir & "\x86\VBoxProxyStub-x86.dll") AND $App_Dir = "app64" Then
	RunWait(@WindowsDir & "\SysWOW64\regsvr32.exe /S /U " & $App_Dir & "\x86\VBoxProxyStub-x86.dll", @ScriptDir, @SW_HIDE)
	Else
	RunWait(@WindowsDir & "\System32\regsvr32.exe /S /U " & $App_Dir & "\VBoxProxyStub.dll", @ScriptDir, @SW_HIDE)
	Endif

    If $DRV = 1 Then
        RunWait("sc stop VBoxDRV", @ScriptDir, @SW_HIDE)
    EndIf

    If $SUP = 1 Then
        RunWait("sc stop VBoxSUP", @ScriptDir, @SW_HIDE)
    EndIf

    If $USB = 1 Then
        RunWait("sc stop VBoxUSB", @ScriptDir, @SW_HIDE)
        ;RunWait(@ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe remove ""USB\VID_80EE&PID_CAFE""", @ScriptDir, @SW_HIDE)
		RunWait("""" & @ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe"" remove ""USB\VID_80EE&PID_CAFE""", @ScriptDir, @SW_HIDE)
        FileDelete(@WindowsDir & "\System32\drivers\VBoxUSB.sys")
    EndIf

    If $MON = 1 Then
        RunWait("sc stop VBoxUSBMon", @ScriptDir, @SW_HIDE)
    EndIf

    If $ADP = 1 Then
        RunWait("sc stop VBoxNetAdp", @ScriptDir, @SW_HIDE)
		RunWait("""" & @ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe"" remove ""sun_VBoxNetAdp""", @ScriptDir, @SW_HIDE)
        ;RunWait(@ScriptDir & "\data\tools\devcon_" & $OsArch & ".exe remove ""sun_VBoxNetAdp""", @ScriptDir, @SW_HIDE)
        FileDelete(@WindowsDir & "\System32\drivers\VBoxNetAdp" & $ADPVER & ".sys")
    EndIf

    If $NET = 1 Then
        RunWait("sc stop VBoxNetFlt", @ScriptDir, @SW_HIDE)
        RunWait("sc stop VBoxNetLwf", @ScriptDir, @SW_HIDE)
        ;RunWait(@ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe -v -u ""sun_VBoxNetFlt""", @ScriptDir, @SW_HIDE)
        ;RunWait(@ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe -v -u ""oracle_VBoxNetLwf""", @ScriptDir, @SW_HIDE)
		RunWait("""" & @ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe"" -v -u ""sun_VBoxNetFlt""", @ScriptDir, @SW_HIDE)
		RunWait("""" & @ScriptDir & "\data\tools\snetcfg_" & $OsArch & ".exe"" -v -u ""oracle_VBoxNetLwf""", @ScriptDir, @SW_HIDE)
        RunWait(@SystemDir & "\regsvr32.exe /S /U " & @WindowsDir & "\System32\VBoxNetFltNobj.dll", @ScriptDir, @SW_HIDE)
        RunWait("sc delete VBoxNetFlt", @ScriptDir, @SW_HIDE)
        RunWait("sc delete VBoxNetLwf", @ScriptDir, @SW_HIDE)
        FileDelete(@WindowsDir & "\System32\VBoxNetFltNobj.dll")
        FileDelete(@WindowsDir & "\System32\drivers\VBoxNetFlt.sys")
        FileDelete(@WindowsDir & "\System32\drivers\VBoxNetLwf.sys")
    EndIf

    If FileExists(@ScriptDir & "\" & $App_Dir & "\") And FileExists(@ScriptDir & "\vboxadditions\") Then
        DirMove(@ScriptDir & "\" & $App_Dir & "\doc", @ScriptDir & "\vboxadditions\", 1)
        DirMove(@ScriptDir & "\" & $App_Dir & "\ExtensionPacks", @ScriptDir & "\vboxadditions\", 1)
        DirMove(@ScriptDir & "\" & $App_Dir & "\nls", @ScriptDir & "\vboxadditions\", 1)
        FileMove(@ScriptDir & "\" & $App_Dir & "\*.iso", @ScriptDir & "\vboxadditions\guestadditions\", 9)
    EndIf

    If FileExists(@SystemDir & "\msvcp71.dll") Then FileDelete(@SystemDir & "\msvcp71.dll")
    If FileExists(@SystemDir & "\msvcr71.dll") Then FileDelete(@SystemDir & "\msvcr71.dll")
    If FileExists(@SystemDir & "\msvcrt.dll")  Then FileDelete(@SystemDir & "\msvcrt.dll")
    If FileExists(@SystemDir & "\msvcp80.dll") Then FileDelete(@SystemDir & "\msvcp80.dll")
    If FileExists(@SystemDir & "\msvcr80.dll") Then FileDelete(@SystemDir & "\msvcr80.dll")

    If $DRV = 1 Then
        RunWait("sc delete VBoxDRV", @ScriptDir, @SW_HIDE)
    EndIf

    If $SUP = 1 Then
        RunWait("sc delete VBoxSUP", @ScriptDir, @SW_HIDE)
    EndIf

    If $USB = 1 Then
        RunWait("sc delete VBoxUSB", @ScriptDir, @SW_HIDE)
    EndIf

    If $MON = 1 Then
        RunWait("sc delete VBoxUSBMon", @ScriptDir, @SW_HIDE)
    EndIf

    If $ADP = 1 Then
        RunWait("sc delete VBoxNetAdp", @ScriptDir, @SW_HIDE)
    EndIf

    If $NET = 1 Then
        RunWait("sc delete VBoxNetFlt", @ScriptDir, @SW_HIDE)
        RunWait("sc delete VBoxNetLwf", @ScriptDir, @SW_HIDE)
    EndIf

    RunWait("sc delete VBoxSDS", @ScriptDir, @SW_HIDE)
EndFunc

Func _OpenCmd()
    Local $sTitle = @ComSpec
	Opt("WinTitleMatchMode", 2)

    If WinExists($sTitle) Then
        WinActivate($sTitle)
		Opt("WinTitleMatchMode", 1)
        Return
    EndIf

	Opt("WinTitleMatchMode", 1)
	$ConsolePID = Run(@ComSpec & ' /K "title ' & $sTitle & '"', @ScriptDir & "\" & $App_Dir, @SW_SHOW)
    WinWait($sTitle, "", 1)
EndFunc

Func _DownloadFile()
    GUICtrlSetState($Button100, $GUI_DISABLE)
    GUICtrlSetState($Button200, $GUI_DISABLE)
	GUICtrlSetState($LabelDownload, $GUI_SHOW)
	Local $version = GUICtrlRead($Download_listbox)
	$version = StringRegExpReplace($version, ".*?(\d+\.\d+\.\d+).*", "$1")
    Local $baseUrl = "https://download.virtualbox.org/virtualbox/" & $version & "/"
	Local $save1 = @ScriptDir&"\VirtualBox.exe"
	Local $save2 = @ScriptDir&"\Extension.vbox-extpack"

    Local $htmlContent = BinaryToString(InetRead($baseUrl))

    Local $patterns[2] = [ _
        '<a\s+[^>]*href=["' & '](.+?\.exe)["' & ']', _
        '<a\s+[^>]*href=["' & '](.+?\.vbox-extpack)["' & ']' _
    ]
    
    For $pattern In $patterns
        Local $matches = StringRegExp($htmlContent, $pattern, 1)
        If IsArray($matches) Then
            For $i = 0 To UBound($matches) - 1
                Local $link = $matches[$i]
                If StringLeft($link, 4) <> "http" Then
                    $link = StringRegExpReplace($link, '^/', '')
                    $link = $baseUrl & $link
                EndIf
                Local $fileName = StringRegExpReplace($link, '.*/', '')
				If StringRegExp($pattern, ".exe") Then
                Local $localPath = $save1
				ElseIf StringRegExp($pattern, ".vbox-extpack") Then
				Local $localPath = $save2
				EndIf

			Local $Downloaded = False
			Local $RetryCount = 0

			Local $info1 = InetGet($link, $localPath, 8, 1)
			Do
				Sleep(50)
				Local $bytes = InetGetInfo($info1, 0)
				Local $total_bytes = InetGetInfo($info1, 1)
				Local $status = InetGetInfo($info1, 3)
				GUICtrlSetData($Input200, _GetTranslation($Lang, "status", "01")&" "& @CRLF & $link & @CRLF &_DisplayDownloadStatus($bytes, $total_bytes))
				Sleep(50)
				If $status = 1 Then
					$Downloaded = True
				ElseIf $status = 2 Or $status = 3 Then
					$RetryCount += 1
					Sleep(3000)
				If $RetryCount < $MaxRetries Then
					InetClose($info1)
					$info1 = InetGet($url1, $dest1, 8, 1)
				EndIf
				EndIf
			Until $Downloaded Or $RetryCount >= $MaxRetries
            Next
        EndIf
    Next
    If FileExists($save1) Then
        GUICtrlSetData($Input100, $save1)
		_CheckExeFile($save1)
    EndIf
    GUICtrlSetData($Input200, _GetTranslation($Lang, "status", "02"))
    GUICtrlSetState($Button100, $GUI_ENABLE)
    GUICtrlSetState($Button200, $GUI_ENABLE)
EndFunc

Func _DisplayDownloadStatus($downloaded_bytes, $total_bytes)
    If $total_bytes > 0 Then
        Return _RoundForceDecimalMB($downloaded_bytes) & "MB / " & _RoundForceDecimalMB($total_bytes) & "MB (" & Round(100 * $downloaded_bytes / $total_bytes) & "%)"
    Else
        Return _RoundForceDecimalMB($downloaded_bytes) & "MB"
    EndIf
EndFunc

Func _RoundForceDecimalMB($number)
    Local $rounded = Round($number / 1048576, 1)
    If Not StringInStr($rounded, ".") Then
        Return $rounded & ".0"
    Else
        Return $rounded
    EndIf
EndFunc   ;==>RoundForceDecimal

Func _DownloadGithub($File, $Save)
  Local $download = InetGet($File, @ScriptDir&"\"&$Save, 8, 1)
  Do
    Sleep(250)
  Until InetGetInfo($download, 2)
  InetClose($download)
EndFunc

Func _SearchFile()
  Local $FilePath = FileOpenDialog(_GetTranslation($Lang, "status", "03"), @ScriptDir, "(*.exe)", 1+2)
  If NOT @error Then
    GUICtrlSetData($Input100, $FilePath)
    GUICtrlSetState($Button200,$GUI_ENABLE)
	_CheckExeFile($FilePath)
  EndIf
EndFunc

Func _UseSettings()
  If GUICtrlRead($Input100) = "" OR GUICtrlRead($Input100) = _GetTranslation($Lang, "download", "04") Then
    Local $SourceFile = @ScriptDir&"\forgetit"
  Else
    Local $SourceFile = GUICtrlRead($Input100)
	Local $SourceDir = StringRegExpReplace($SourceFile, "[^\\]+$", "")
  EndIf

  If NOT (FileExists(@ScriptDir&"\virtualbox.exe") OR FileExists($SourceFile) AND (GUICtrlRead($Checkbox100) = $GUI_CHECKED OR GUICtrlRead($Checkbox110) = $GUI_CHECKED)) Then
    Break(1)
    Exit
  EndIf

  If (FileExists(@ScriptDir&"\virtualbox.exe") OR FileExists($SourceFile)) AND (GUICtrlRead($Checkbox100) = $GUI_CHECKED OR GUICtrlRead($Checkbox110) = $GUI_CHECKED) Then
    GUICtrlSetState($LabelDownload, $GUI_SHOW)
    GUICtrlSetData($Input200, @LF & _GetTranslation($Lang, "status", "04"))

    If FileExists(@ScriptDir&"\virtualbox.exe") Then
      Run(@ScriptDir&"\virtualbox.exe -x -p temp", @ScriptDir, @SW_HIDE)
      Opt ("WinTitleMatchMode", 2)
	  WinWait("VirtualBox Installer")
      While WinExists("VirtualBox Installer")
      WinActivate("VirtualBox Installer")
      ControlClick("VirtualBox Installer", "OK", "TButton1")
      WinClose("VirtualBox Installer")
      WEnd
    EndIf

    If FileExists($SourceFile) Then
      Run($SourceFile&" -x -p temp", @ScriptDir, @SW_HIDE)
      Opt ("WinTitleMatchMode", 2)
	  WinWait("VirtualBox Installer")
      While WinExists("VirtualBox Installer")
      WinActivate("VirtualBox Installer")
      ControlClick("VirtualBox Installer", "OK", "TButton1")
      WinClose("VirtualBox Installer")
      WEnd
    EndIf
  EndIf

	Local $PatchExtension = ""
	$aArray = _RecFileListToArray($SourceDir, "*Extension*", 1, 1, 0, 2)
	If IsArray($aArray) Then
      For $i = 1 To $aArray[0]
      $PatchExtension = $aArray[$i]
      Next
	Endif
	If FileExists($PatchExtension) Then
	  RunWait(""""&@ScriptDir&"\data\tools\7za.exe"" x -y -o"""&@ScriptDir&"\temp\""" & " """&$PatchExtension&"""", @ScriptDir, @SW_HIDE)
	  RunWait(""""&@ScriptDir&"\data\tools\7za.exe"" x -y -o"""&@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\""" & " """&@ScriptDir&"\temp\Extension""", @ScriptDir, @SW_HIDE)
	  RunWait(""""&@ScriptDir&"\data\tools\7za.exe"" x -y -o"""&@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\""" & " """&@ScriptDir&"\temp\Extension~""", @ScriptDir, @SW_HIDE)
	EndIf

  If GUICtrlRead($Checkbox100) = $GUI_CHECKED AND FileExists(@ScriptDir&"\temp") Then
    GUICtrlSetData($Input200, @LF & _GetTranslation($Lang, "status", "05"))
    RunWait("cmd /c ren ""%CD%\temp\*_x86.msi"" x86.msi", @ScriptDir, @SW_HIDE)
    RunWait("cmd /c msiexec.exe /quiet /a ""%CD%\temp\x86.msi"" TARGETDIR=""%CD%\temp\x86""", @ScriptDir, @SW_HIDE)
    DirCopy(@ScriptDir&"\temp\x86\PFiles\Oracle\VirtualBox", @ScriptDir&"\app32", 1)
    FileCopy(@ScriptDir&"\temp\x86\PFiles\Oracle\VirtualBox\*", @ScriptDir&"\app32", 9)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\darwin.amd64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\darwin.arm64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\linux.amd64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\solaris.amd64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\win.arm64", 1)
    DirCopy(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack", @ScriptDir&"\app32\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack", 1)
    FileDelete(@ScriptDir&"\app32\*.rtf")
    FileDelete(@ScriptDir&"\app32\*.chm")
    FileDelete(@ScriptDir&"\app32\VirtualBox.*.xml")
    FileDelete(@ScriptDir&"\app32\VirtualBox*.png")
    DirRemove(@ScriptDir&"\app32\doc", 1)
    DirRemove(@ScriptDir&"\app32\UnattendedTemplates", 1)
    DirRemove(@ScriptDir&"\app32\accessible", 1)
    DirRemove(@ScriptDir&"\app32\sdk", 1)
  EndIf

  If GUICtrlRead($Checkbox110) = $GUI_CHECKED AND FileExists(@ScriptDir&"\temp") Then
    GUICtrlSetData($Input200, @LF & _GetTranslation($Lang, "status", "05"))
	Local $msiFiles = _RecFileListToArray(@ScriptDir&"\temp\", "*.msi", 1, 1, 0, 0)
	If @error Or $msiFiles[0] = 0 Then
    Exit
	EndIf
	If $msiFiles[0] = 1 Then
    RunWait("cmd /c ren ""%CD%\temp\*.msi"" amd64.msi", @ScriptDir, @SW_HIDE)
    RunWait("cmd /c msiexec.exe /quiet /a ""%CD%\temp\amd64.msi"" TARGETDIR=""%CD%\temp\x64""", @ScriptDir, @SW_HIDE)
	Else
	For $i = 1 To $msiFiles[0]
		If StringRegExp($msiFiles[$i], "amd64") Then
		RunWait("cmd /c ren ""%CD%\temp\"&$msiFiles[$i]&""" amd64.msi", @ScriptDir, @SW_HIDE)
		RunWait("cmd /c msiexec.exe /quiet /a ""%CD%\temp\amd64.msi"" TARGETDIR=""%CD%\temp\x64""", @ScriptDir, @SW_HIDE)
		ExitLoop
		EndIf
    Next
    EndIf
    DirCopy(@ScriptDir&"\temp\x64\PFiles\Oracle\VirtualBox", @ScriptDir&"\app64", 1)
    FileCopy(@ScriptDir&"\temp\x64\PFiles\Oracle\VirtualBox\*", @ScriptDir&"\app64", 9)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\darwin.amd64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\darwin.arm64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\linux.amd64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\solaris.amd64", 1)
    DirRemove(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\win.arm64", 1)
    DirCopy(@ScriptDir&"\temp\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack", @ScriptDir&"\app64\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack", 1)
    FileDelete(@ScriptDir&"\app64\*.rtf")
    FileDelete(@ScriptDir&"\app64\*.chm")
    FileDelete(@ScriptDir&"\app64\VirtualBox.*.xml")
    FileDelete(@ScriptDir&"\app64\VirtualBox*.png")
    DirRemove(@ScriptDir&"\app64\doc", 1)
    DirRemove(@ScriptDir&"\app64\UnattendedTemplates", 1)
    DirRemove(@ScriptDir&"\app64\accessible", 1)
    DirRemove(@ScriptDir&"\app64\sdk", 1)
  EndIf

  If FileExists(@ScriptDir&"\temp") Then
	If GUICtrlRead($Checkbox120) = $GUI_CHECKED Then
    DirRemove(@ScriptDir&"\temp", 1)
	EndIf
	If GUICtrlRead($Checkbox130) = $GUI_CHECKED Then
    FileDelete(@ScriptDir&"\virtualbox.exe")
	FileDelete(@ScriptDir&"\extension")
    FileDelete(@ScriptDir&"\extension.vbox-extpack")
	EndIf
    RunWait("cmd /c taskkill /im msiexec.exe /f", @ScriptDir, @SW_HIDE)
  EndIf

  If GUICtrlRead($Checkbox140) = $GUI_CHECKED Then
    IniWrite($var1, "startvbox", "key", "1")
  EndIf

  if (FileExists(@ScriptDir&"\virtualbox.exe") OR FileExists($SourceFile)) AND (GUICtrlRead($Checkbox100) = $GUI_CHECKED OR GUICtrlRead($Checkbox110) = $GUI_CHECKED) Then
    GUICtrlSetData($Input200, @LF & _GetTranslation($Lang, "status", "08"))
    Sleep(2000)
  EndIf

  GUIDelete()
  $install = 0
EndFunc

Func _Github()
ShellExecute("https://github.com/Deac2/Portable-VirtualBox")
EndFunc

Func _Licence()
  ShellExecute("http://www.virtualbox.org/wiki/VirtualBox_PUEL")
EndFunc

; Check if virtualbox is installed and run from it
Func _HybridMode()
    ; Version of VirtualBox
    Local $sVersion = _RegRead("HKLM\SOFTWARE\Oracle\VirtualBox", "Version")
    
	; Since 4.0.8 ... Version is in VersionExt key in registry
    If $sVersion = "%VER%" Then
        $sVersion = _RegRead("HKLM\SOFTWARE\Oracle\VirtualBox", "VersionExt")
    EndIf

	; Version of VirtualBox 3.X if any is installed => Cannot run Portable 4.X or it will corrupt it
    Local $sVersionOld = _RegRead("HKLM\SOFTWARE\Sun\VirtualBox", "Version")

    Local $iMajorVersion = Int(StringRegExpReplace($sVersion, "^(\d+).*", "\1"))
    Local $iOldMajorVersion = Int(StringRegExpReplace($sVersionOld, "^(\d+).*", "\1"))

	; if old version => Exit to avoid corruption of services
    If ($sVersion <> "" And $iMajorVersion < 4) Or ($sVersionOld <> "" And $iOldMajorVersion < 4) Then
        MsgBox(16, "Sorry", "Please update your version of VirtualBox to 4.X/7.X or uninstall it from your computer to be able to run this portable version." & @CRLF & @CRLF & _
               "This is a security check in order to avoid corrupting your current installed version." & @CRLF & @CRLF & "Thank you for your comprehension.")
        Exit
    EndIf

	; Setting VBOX_USER_HOME to portable virtualbox directory(VM settings stays in this one)
    EnvSet("VBOX_USER_HOME", $UserHome)

	; Testing if major version of regular vbox is 4 then running from it
    If $sVersion <> "" And $iMajorVersion >= 4 Then
		; Getting the installation directory of regular VirtualBox from registry
        Local $nonportable_install_dir = _RegRead("HKLM\SOFTWARE\Oracle\VirtualBox", "InstallDir")
        If StringRight($nonportable_install_dir, 1) <> "\" Then $nonportable_install_dir &= "\"

        If $CmdLine[0] = 1 Then
            Run(""""&$nonportable_install_dir&"VBoxManage.exe"" startvm """ & $CmdLine[1] & """", @ScriptDir, @SW_HIDE)
        Else
            Run(""""&$nonportable_install_dir&"protectua3.exe""")
        EndIf

        ; Does not need to wait since it's a regular version of VirtualBox
        Exit
    EndIf
EndFunc