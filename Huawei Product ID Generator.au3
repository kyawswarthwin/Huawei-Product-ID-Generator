#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resource\Icon.ico
#AutoIt3Wrapper_Res_Description=Huawei Product ID Generator
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2013 Kyaw Swar Thwin
#AutoIt3Wrapper_Res_Language=1033
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <WinAPI.au3>
#include <Crypt.au3>

OnAutoItExitRegister("_Exit")

Global Const $sAppName = "Huawei Product ID Generator"
Global Const $sAppVersion = "1.0"
Global Const $sAppPublisher = "Kyaw Swar Thwin"
Global Const $sAppDesigner = "Green Like Orange"
Global Const $sAppPath = _TempFile("", "", "", 8)

Global Const $sTitle = $sAppName

DirCreate($sAppPath)
FileInstall("Resource\Banner.bmp", $sAppPath & "\Banner.bmp", 1)

$frmMain = GUICreate($sTitle, 400, 320, -1, -1)
$imgBanner = GUICtrlCreatePic($sAppPath & "\Banner.bmp", 0, 0, 400, 160)
$lblVersion = GUICtrlCreateLabel("Version: " & $sAppVersion, 195, 90, 72, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$lblDeveloper = GUICtrlCreateLabel("Developed By: " & $sAppPublisher, 195, 110, 191, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$lblDesigner = GUICtrlCreateLabel("Design By: " & $sAppDesigner, 195, 130, 176, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$lblModel = GUICtrlCreateLabel("Product Model:", 10, 180, 76, 17)
$cboModel = GUICtrlCreateCombo("", 10, 195, 380, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "HUAWEI C8812|HUAWEI C8812E|HUAWEI C8813|HUAWEI C8813D|HUAWEI C8813Q|HUAWEI C8825D|HUAWEI G510-0010|HUAWEI G510-0100|HUAWEI G510-0200|HUAWEI G520-0000|HUAWEI U8815|HUAWEI U8815N|HUAWEI U8825-1|HUAWEI U8825D|HUAWEI Y300-0000|HUAWEI Y300-0100|HUAWEI Y300-0151|HUAWEI Y300C|U8815", "HUAWEI C8812")
$lblIMEI = GUICtrlCreateLabel("Product IMEI/MEID:", 10, 220, 101, 17)
$txtIMEI = GUICtrlCreateInput("", 10, 235, 380, 21)
$lblID = GUICtrlCreateLabel("Product ID:", 10, 260, 58, 17)
$txtID = GUICtrlCreateInput("", 10, 275, 380, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cboModel
			GUICtrlSetData($txtID, _GenerateProductID(GUICtrlRead($cboModel), GUICtrlRead($txtIMEI)))
	EndSwitch
WEnd

Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $lParam

	Switch _WinAPI_LoWord($wParam)
		Case $txtIMEI
			Switch _WinAPI_HiWord($wParam)
				Case $EN_CHANGE
					GUICtrlSetData($txtID, _GenerateProductID(GUICtrlRead($cboModel), GUICtrlRead($txtIMEI)))
			EndSwitch
	EndSwitch
EndFunc   ;==>WM_COMMAND

Func _Exit()
	DirRemove($sAppPath, 1)
EndFunc   ;==>_Exit

Func _GenerateProductID($sDeviceModel, $sIMEI)
	_Crypt_Startup()
	Local $sData, $aChar, $sProductID = ""
	$sData = _Crypt_HashData($sDeviceModel & $sIMEI, $CALG_MD5)
	$aChar = StringSplit(Hex(BitXOR(Dec(StringMid($sData, 3, 8)), Dec(StringRight($sData, 8))), 8), "")
	For $i = 1 To $aChar[0]
		If StringInStr("ABCDEF", $aChar[$i]) Then
			$sProductID &= Chr(Asc($aChar[$i]) - 17)
		Else
			$sProductID &= $aChar[$i]
		EndIf
	Next
	While StringLeft($sProductID, 1) = "0"
		$sProductID = StringMid($sProductID, 2) & "0"
		If StringLeft($sProductID, 1) <> "0" Then ExitLoop
	WEnd
	_Crypt_Shutdown()
	Return $sProductID
EndFunc   ;==>_GenerateProductID
