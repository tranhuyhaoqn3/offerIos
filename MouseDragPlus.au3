;=================================================================================================
; Function:			_PostMessage_ClickDrag($hWnd, $X1, $Y1, $X2, $Y2, $Button = "left")
; Description:		Sends a mouse click and drag command to a specified window.
; Parameter(s):		$hWnd - The handle or the title of the window.
;					$X1, $Y1 - The x/y position to start the drag operation from.
;					$X2, $Y2 - The x/y position to end the drag operation at.
;					$Button - (optional) The button to click, "left", "right", "middle". Default is the left button.
;					$Delay - (optional) Delay in milliseconds. Default is 50.
; Requirement(s):	A window handle/title.
; Return Value(s):	On Success - Returns true
;					On Failure - Returns false
;					@Error - 0 = No error.
;							 1 = Invalid window handle or title.
;							 2 = Invalid start position.
;							 3 = Invalid end position.
;							 4 = Failed to open the dll.
;							 5 = Failed to send a MouseDown command.
;							 5 = Failed to send a MouseMove command.
;							 7 = Failed to send a MouseUp command.
; Author(s):		KillerDeluxe
;=================================================================================================
Func _PostMessage_ClickDrag($hWnd, $X1, $Y1, $X2, $Y2, $Button = "left", $Delay ="")

	Local $MK_LBUTTON = 0x0001
	Local $WM_LBUTTONDOWN = 0x0201
	Local $WM_LBUTTONUP = 0x0202

	Local $MK_RBUTTON = 0x0002
	Local $WM_RBUTTONDOWN = 0x0204
	Local $WM_RBUTTONUP = 0x0205

	Local $WM_MOUSEMOVE = 0x0200

	If Not IsHWnd($hWnd) And $hWnd <> "" Then
		$hWnd = WinGetHandle($hWnd)
	EndIf

	If Not IsHWnd($hWnd) Then
		Return SetError(1, "", False)
	EndIf

	If Not IsInt($X1) Or Not IsInt($Y1) Then
		Return SetError(2, "", False)
	EndIf

	If Not IsInt($X2) Or Not IsInt($Y2) Then
		Return SetError(3, "", False)
	EndIf

	If StringLower($Button) = "left" Then
		$Button = $WM_LBUTTONDOWN
		$Pressed = 1
	EndIf
	$User32 = DllOpen("User32.dll")
	If @error Then Return SetError(4, "", False)
	DllCall($User32, "bool", "PostMessage", "hwnd", $hWnd, "int", $WM_MOUSEMOVE, "int", 0, "long", _MakeLong($X1, $Y1))
	If @error Then Return SetError(6, "", False)
	Sleep($Delay)

	DllCall($User32, "bool", "PostMessage", "hwnd", $hWnd, "int", $WM_LBUTTONDOWN, "int", $Pressed, "long", _MakeLong($X1, $Y1))
	If @error Then Return SetError(6, "", False)
		Sleep($Delay)
DllCall($User32, "bool", "PostMessage", "hwnd", $hWnd, "int", $WM_LBUTTONDOWN, "int", 1, "long", _MakeLong($X2, $Y2))
	If @error Then Return SetError(6, "", False)
	Sleep($Delay)
	DllCall($User32, "bool", "PostMessage", "hwnd", $hWnd, "int", $WM_LBUTTONUP, "int", 0, "long", _MakeLong($X2, $Y2))
	If @error Then Return SetError(6, "", False)
		Sleep($Delay)
	DllClose($User32)
	Return SetError(0, 0, True)
EndFunc
Func _MakeLong($LowWORD, $HiWORD)
    Return BitOR($HiWORD * 0x10000, BitAND($LowWORD, 0xFFFF))
EndFunc