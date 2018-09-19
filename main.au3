#include <screencapture.au3>
#include <array.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <GDIPlus.au3>
#include <color.au3>
#include <TaishouSearch.au3>
#include <thread.au3>
#include <MouseDragPlus.au3>
HotKeySet('{F2}', 'Terminate')
HotKeySet('{F1}', 'RunTool')
Local $numgame=2
Local $ip1 = '192.168.1.47 '
Local $ip2 = '192.168.1.237 '
Local $game[$numgame]
Local $point[$numgame]
Local $check[$numgame]
Local $request = 50

While 1
	Sleep(100)
WEnd
Func Terminate()
	Exit
	Exit
EndFunc   ;==>Terminate

Func game()
	$game[0]='945555'
	$game[1]='E9AA7F'
	;$game[2]='FF9455'

	$point[0]=5
	$point[1]=5
	;$point[2]=13

	Local $i=0
	While $i<$numgame
	$check[$i]=0
	$i=$i+1
	WEnd
EndFunc

Func RunTool()
	$a=$ip1 & '(iphone.net.fpt) - VNC Viewer'
	$b=$ip2 & '(iphone.net.fpt) - VNC Viewer'
	;_CoProc('Start',$b)
	Start($a)
EndFunc   ;==>RunTool


Func Start($mb)
	;backup($mb)
	;ip($mb,0)
	findip($mb)
	;openred($mb)
		;$d=GetColorWD(34, 198, $mb)
		;MsgBox(0,0,$d)
EndFunc   ;==>Start

Func backup($title)
	Sleep(2000)
	ControlClick($title, '', '', 'right', 1, 200, 200)
	Sleep(1500)
	ControlClick($title, '', '', 'right', 1, 200, 200)
	Sleep(1500)
	ControlClick($title, '', '', 'left', 1, 240, 520)
	Sleep(2000)
	ControlClick($title, '', '', 'left', 1, 230, 120)
	Sleep(2000)
	While GetColorWD(240, 470, $title) <> 'FFFFFF'
	WEnd
	Sleep(2000)
	ControlClick($title, '', '', 'right', 1, 200, 200)
EndFunc   ;==>backup

Func ip($title, $ed)
	vpn($title)
	If $ed = 0 Then
		vpned($title)
	EndIf
	While 1
		Local $i = findip($title)
		ControlClick($title, '', '', 'left', 1, 34, $i)
		$equal = connect($title)
		If $equal = 1 Then
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>ip

Func vpn($title)
	Sleep(1000)
	ControlClick($title, '', '', 'right', 1, 200, 200)
	Sleep(1500)
	ControlClick($title, '', '', 'main', 1, 160, 520)
	Sleep(1000)
	ControlClick($title, '', '', 'main', 1, 160, 280)
EndFunc   ;==>vpn

Func vpned($title)
	Sleep(1000)
	While 1
		If GetColorWD(86, 79, $title) = 'FF5500' Then
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
	Sleep(1500)
	ControlClick($title, '', '', 'main', 1, 300, 35)
	Sleep(1500)
	ControlClick($title, '', '', 'main', 1, 120, 100)
	Sleep(1500)
	ControlClick($title, '', '', 'main', 1, 120, 100)
EndFunc   ;==>vpned


Func findip($title)
	Sleep(2000)
	setting($title,1)
	Sleep(2000)
	While 1
		For $i = 145 To 205 Step 1
			$equal = GetColorWD(34, $i, $title)
			$equal1 = GetColorWD(24, $i, $title)
			 If $equal = 'EB1212' And $equal1 = 'FFFFFF' Then
				 For $j = 145 To 205 Step 1
					 $equal2 = GetColorWD(160, $j, $title)
					 if  $equal2 <> 'FFFFFF' Then
						  ExitLoop
					 EndIf
				 Next
				 if $j=204 Then
					 Sleep(2000)
					 setting($title,0)
					 Return $i
				 EndIf
			EndIf
		Next
		_PostMessage_ClickDrag($title, 200, 300, 200, 200, 'left', 200)
	WEnd
EndFunc   ;==>findip

Func connect($title)
	Sleep(2000)
	ControlClick($title, '', '', 'main', 1, 160, 490)
	Sleep(2000)
	ControlClick($title, '', '', 'main', 1, 140, 300)
	Sleep(2000)
	_PostMessage_ClickDrag($title, 200, 200, 200, 400, 'left', 200)
	Sleep(2000)
	$equal = GetColorWD(55, 425, $title)
	If $equal = '55FF55' Then
		ControlClick($title, '', '', 'main', 1, 55, 425)
	EndIf
	Sleep(2000)
	ControlClick($title, '', '', 'main', 1, 155, 250)
	Sleep(2000)
	ControlClick($title, '', '', 'main', 1, 70, 205)
	Sleep(6000)
	$equal = GetColorWD(19, 171, $title)
	If $equal = '6ABF15' Then
		ControlClick($title, '', '', 'right', 1, 200, 200)
		Return 1
	EndIf
	ControlClick($title, '', '', 'right', 3, 200, 200)
	Sleep(1500)
	ControlClick($title, '', '', 'left', 1, 170, 300)
	Return 0
EndFunc   ;==>connect


Func setting($title,$quari)
	$str=StringSplit($title,'(')
	$server=$str[1]&'- Properties'
	ControlCommand($title,'','ToolbarWindow321',"SendCommandID",4)
	Sleep(1000)
	ControlClick($server, '', 'ComboBox2', 'left', 1)
	Sleep(1000)
	if $quari=0 Then
	ControlSend($server, '', 'ComboBox2', '{l}')
	Else
	ControlSend($server, '', 'ComboBox2', '{m}')
	EndIf
	Sleep(1000)
	ControlSend($server, '', 'os::Window25', '{Enter}')
EndFunc   ;==>setting

Func openred($title,$ed)
	Sleep(1000)
	ControlClick($title, '', '', 'right', 1, 200, 200)
	Sleep(1500)
	ControlClick($title, '', '', 'main', 1, 160, 520)
	Sleep(1000)
	ControlClick($title, '', '', 'main', 1, 160, 190)
	While 1
		If GetColorWD(200, 480, $title) = 'FFAA00' Then
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
	_PostMessage_ClickDrag($title, 300, 200, 100, 200, 'left', 200)
	_PostMessage_ClickDrag($title, 300, 200, 100, 200, 'left', 200)
	_PostMessage_ClickDrag($title, 300, 200, 100, 200, 'left', 200)
	_PostMessage_ClickDrag($title, 300, 200, 100, 200, 'left', 200)
	While 1
		If GetColorWD(150, 180, $title) = 'FF0000' Then
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
	ControlClick($title, '', '', 'left', 1, 150, 180)
	Sleep(1000)
	_PostMessage_ClickDrag($title, 200, 400, 200, 150, 'left', 200)
EndFunc
Func checkgame($title)
	Local $i=130
	While 1
		if GetColorWD(40, $i, $title) = 'FF0000' Then
		ExitLoop
		EndIf
		$i=$i+70
	WEnd
	For $i=0 to ($i-130)/70 Step 1
		for $j=0 to $numgame Step 1
			if GetColorWD(40, 130+70*$i, $title)=$game[$j] And $check[$j]=0 Then
				downgame($title,$i,$j)
			EndIf
		Next
	Next
EndFunc

Func downgame($title,$i,$j)
	ControlClick($title, '', '', 'left', 1, 40,$i*70+130)
	While 1
		If GetColorWD(260, 150, $title) = 'FFFF55' Then
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
	_PostMessage_ClickDrag($title, 300, 400, 300, 100, 'left', 200)
	Sleep(1000)
	ControlClick($title, '', '', 'left', 1, 160, 400)
	While 1
		If GetColorWD(260, 150, $title) = 'FFFF55' Then
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
EndFunc
