#include <screencapture.au3>
#include <array.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <GDIPlus.au3>
#include<color.au3>
#include <TaishouSearch.au3>
#include <thread.au3>
#include <MouseDragPlus.au3>
HotKeySet('{F2}','Terminate')
HotKeySet('{F1}','RunTool')

Local $a='192.168.0.102'
Local $b='192.168.0.103'
Local $server=' (iPhone) - VNC Viewer'
Local $request=50

While 1
    Sleep(100)
WEnd
Func Terminate()
    Exit
	Exit
EndFunc

Func RunTool()
	;_CoProc('Start',$b)
	Start($a)
EndFunc


Func Start($mb)
	;backup($mb)
	;ip($mb,0)
	;$d=GetColorWD(55,425,$mb)
	;MsgBox(0,0,$d)
	;Sleep(2000)
	;ControlClick($mb,'','','left',1,55,425)
	ControlClick('VNC Viewer','','os::Window16','left',1,200,50)
EndFunc

Func backup($title)
	Sleep(2000)
	ControlClick($title,'','','right',1,200,200)
	Sleep(1500)
	ControlClick($title,'','','right',1,200,200)
	Sleep(1500)
	ControlClick($title,'','','left',1,240,520)
	Sleep(2000)
	ControlClick($title,'','','left',1,230,120)
	Sleep(2000)
	While GetColorWD(240,470,$title)<>'FFFFFF'
	WEnd
	Sleep(2000)
	ControlClick($title,'','','right',1,200,200)
EndFunc

Func ip($title,$ed)
	vpn($title)
	if $ed=0 Then
		vpned($title)
	EndIf

	while 1
	Local $i=findip($title)
	ControlClick($title,'','','left',1,34,$i)
	$equal=connect($title)
	if $equal=1 then
		ExitLoop
	EndIf
	WEnd
EndFunc

Func vpn($title)
	Sleep(1000)
	ControlClick($title,'','','right',1,200,200)
	Sleep(1500)
	ControlClick($title,'','','main',1,160,520)
	Sleep(1000)
	ControlClick($title,'','','main',1,160,280)
EndFunc

Func vpned($title)
	Sleep(1000)
	While 1
		if GetColorWD(86,79,$title)='FF5D05' Or GetColorWD(86,79,$title)='FF5C05' Then
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
	Sleep(1500)
	ControlClick($title,'','','main',1,300,35)
	Sleep(1500)
	ControlClick($title,'','','main',1,120,100)
	Sleep(1500)
	ControlClick($title,'','','main',1,120,100)
EndFunc


Func findip($title)
	Sleep(1000)
	while 1
		For $i=145 to 205 Step 1
			$equal=GetColorWD(34,$i,$title)
			$equal1=GetColorWD(24,$i,$title)
			$equal2=GetColorWD(160,$i,$title)
			If $equal='EB1212' And $equal1='FFFFFF' And $equal2='FFFFFF' Then
					Sleep(2000)
				Return $i
			EndIf
		Next
		_PostMessage_ClickDrag($title,200,300,200,200,'left',200)
	WEnd
EndFunc

Func connect($title)
	Sleep(2000)
	ControlClick($title,'','','main',1,160,490)
	Sleep(2000)
	ControlClick($title,'','','main',1,140,300)
	Sleep(3000)
	_PostMessage_ClickDrag($title,200,200,200,400,'left',200)
	Sleep(4000)
	$equal=GetColorWD(55,425,$title)
	If $equal='4BD863' Then
	ControlClick($title,'','','main',1,55,425)
	EndIf
	ControlClick($title,'','','main',1,155,250)
	Sleep(4000)
	ControlClick($title,'','','main',1,70,205)
	Sleep(6000)
	$equal=GetColorWD(19,171,$title)
	If $equal='6FC21B' Then
		ControlClick($title,'','','right',1,200,200)
		Return 1
	EndIf
	ControlClick($title,'','','right',3,200,200)
	Sleep(1500)
	ControlClick($title,'','','left',1,170,300)
	return 0
EndFunc

Func PixelSearchW($x,$y,$limitX,$limitY,$color,$title)

	While 1
		$equal=PixelTaishou($x,$y,$color,'','', '','',$title)
		If $equal[0]<> $limitX And $equal[1]<>$limitY Then
			Return $equal
		EndIf
	WEnd
EndFunc

Func setting($mb)
	Local $x=0
	if $mb=$a Then
		$x=40
	Else
		$x=200
	EndIf
	ControlClick('VNC Viewer','','os::Window16','left',1,$x,50)
	ControlSend('VNC Viewer','','os::Window16','!{Enter}')
	ControlClick($mb'192.168.0.102 - Properties','','SysTabControl321','left',1,90,20)
	Sleep(500)
	ControlSend('192.168.0.102 - Properties','','ComboBox2','{l}')
	ControlSend('192.168.0.102 - Properties','','os::Window25','{Enter}')
EndFunc