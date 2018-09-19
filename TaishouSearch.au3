#include <screencapture.au3>
#include <array.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <GDIPlus.au3>
#include<color.au3>


Func PixelTaishou($sX,$sY,$color,$iLeft = -1, $iTop = -1, $iWidth = -1, $iHeight = -1,$hWnd = WinGetHandle("[Active]"))
    If (Not IsHWnd($hWnd)) Then $hWnd = WinGetHandle($hWnd)
    If (@error) Then Return SetError(1, 0, 0)
    Local $tDesktop = GetDesktopMetrics()
    Local $tRectFWindow = _WinAPI_GetWindowRect($hWnd)

    If ($iLeft = -1 Or $iLeft = Default) Then $iLeft = DllStructGetData($tDesktop, 1)
    If ($iTop = -1 Or $iLeft = Default) Then $iLeft = DllStructGetData($tDesktop, 2)
    If ($iWidth = -1 Or $iWidth = 0 Or $iWidth = Default) Then
        If ($hWnd = _WinAPI_GetDesktopWindow()) Then
            $iWidth = DllStructGetData($tDesktop, 3)
        Else
            $iWidth = DllStructGetData($tRectFWindow, 3) - DllStructGetData($tRectFWindow, 1)
        EndIf
    EndIf
    If ($iHeight = -1 Or $iHeight = 0 Or $iHeight = Default) Then
        If ($hWnd = _WinAPI_GetDesktopWindow()) Then
            $iHeight = DllStructGetData($tDesktop, 4)
        Else
            $iHeight = DllStructGetData($tRectFWindow, 4) - DllStructGetData($tRectFWindow, 2)
        EndIf
    EndIf
    Local $iWidth2 = $iWidth
    Local $iHeight2 = $iHeight
    If ($iLeft) Then $iWidth = Abs($iWidth - $iLeft)
    If ($iTop) Then $iHeight = Abs($iHeight - $iTop)
    Local $hDC = _WinAPI_GetWindowDC($hWnd)
    Local $hDestDC = _WinAPI_CreateCompatibleDC($hDC)
    Local $hDestBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
    Local $hDestSv = _WinAPI_SelectObject($hDestDC, $hDestBitmap)
    Local $hSrcDC = _WinAPI_CreateCompatibleDC($hDC)
    Local $hBmp = _WinAPI_CreateCompatibleBitmap($hDC, $iWidth2, $iHeight2)
    Local $hSrcSv = _WinAPI_SelectObject($hSrcDC, $hBmp)
    Local $tPoint = _WinAPI_CreatePoint($iLeft, $iTop)

    _WinAPI_PrintWindow($hWnd, $hSrcDC, True)

    _WinAPI_ScreenToClient($hWnd, $tPoint)

    _WinAPI_BitBlt($hDestDC, 0, 0, $iWidth, $iHeight, $hSrcDC, $iLeft, $iTop, $MERGECOPY)

    _WinAPI_SelectObject($hDestDC, $hDestSv)
    _WinAPI_SelectObject($hSrcDC, $hSrcSv)
    _WinAPI_ReleaseDC($hWnd, $hDC)
    _WinAPI_DeleteDC($hDestDC)
    _WinAPI_DeleteDC($hSrcDC)
    _WinAPI_DeleteObject($hBmp)
    $tPoint = 0
    $tRectFWindow = 0
    $tDesktop = 0

    _GDIPlus_Startup()
    Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hDestBitmap)
    _WinAPI_DeleteObject($hDestBitmap)
	Local $a=PixelSearchEx($hBitmap,$sX,$sY,$color)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_Shutdown()
    Return $a
EndFunc   ;==>CaptureWindow


Func GetDesktopMetrics()
    Return _GDIPlus_RectFCreate(_WinAPI_GetSystemMetrics($SM_XVIRTUALSCREEN), _WinAPI_GetSystemMetrics($SM_YVIRTUALSCREEN), _
            _WinAPI_GetSystemMetrics($SM_CXVIRTUALSCREEN), _WinAPI_GetSystemMetrics($SM_CYFULLSCREEN))
EndFunc   ;==>GetDesktopMetrics


Func PixelSearchEx($hImage,$sX,$sY,$color)
	_GDIPlus_Startup()
    Local $iW = _GDIPlus_ImageGetWidth($hImage), $iH = _GDIPlus_ImageGetHeight($hImage) ;get width and height of the image
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iW, $iH)
    Local $hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsDrawImageRect($hContext, $hImage, 0, 0, $iW, $iH)

    Local $tBitmapData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $iW, $iH, BitOR($GDIP_ILMWRITE, $GDIP_ILMREAD), $GDIP_PXF32RGB)
    Local $iScan0 = DllStructGetData($tBitmapData, "Scan0")
    Local $rbg_color = _ColorGetRGB($color)
    Local $tolerance = 10
    Local $red_low = ($tolerance > $rbg_color[0] ? 0 : $rbg_color[0] - $tolerance)
    Local $green_low = ($tolerance > $rbg_color[1] ? 0 : $rbg_color[1] - $tolerance)
    Local $blue_low = ($tolerance > $rbg_color[2] ? 0 : $rbg_color[2] - $tolerance)
    Local $red_high = ($tolerance > 255 - $rbg_color[0] ? 255 : $rbg_color[0] + $tolerance)
    Local $green_high = ($tolerance > 255 - $rbg_color[1] ? 255 : $rbg_color[1] + $tolerance)
    Local $blue_high = ($tolerance > 255 - $rbg_color[2] ? 255 : $rbg_color[2] + $tolerance)
    Local $tPixel = DllStructCreate("int[" & $iW * $iH & "];", $iScan0)
    Local $iPixel, $iRowOffset
    Local $found_pixel = False
    Local $abscoord_pixel[2] = [0, 0]
		For $iY = $sY To $iH - 1
			$iRowOffset = $iY * $iW + 1
			For $iX = $sX To $iW - 1 ;get each pixel in each line and row
				$iPixel = DllStructGetData($tPixel, 1, $iRowOffset + $iX) ;get pixel color
				Local $pixel_color = _ColorGetRGB("0x" & Hex($iPixel, 6))
				If (($pixel_color[0] >= $red_low and $pixel_color[0] <= $red_high) and ($pixel_color[1] >= $green_low and $pixel_color[1] <= $green_high) and ($pixel_color[2] >= $blue_low and $pixel_color[2] <= $blue_high)) Then
					$abscoord_pixel[0] = $iX
					$abscoord_pixel[1] = $iY
					$found_pixel = True
					ExitLoop
				EndIf
			Next
		Next
    _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_GraphicsDispose($hContext)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_Shutdown()
	Return $abscoord_pixel
EndFunc


Func GetColorWD($iX, $iY, $WinHandle)
	If Not IsHWnd($WinHandle) And $WinHandle <> "" Then
		$WinHandle = WinGetHandle($WinHandle)
	EndIf
    Local $aPos = WinGetPos($WinHandle)
    $iWidth = $aPos[2]
    $iHeight = $aPos[3]

    _GDIPlus_Startup()

    Local $hDDC = _WinAPI_GetDC($WinHandle)
    Local $hCDC = _WinAPI_CreateCompatibleDC($hDDC)

    $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)

    _WinAPI_SelectObject($hCDC, $hBMP)
    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $WinHandle, "hwnd", $hCDC, "int", 0)
    _WinAPI_BitBlt($hCDC, 0, 0, $iWidth, $iHeight, $hDDC, 0, 0, $__SCREENCAPTURECONSTANT_SRCCOPY)

    $BMP = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)
    Local $aPixelColor = _GDIPlus_BitmapGetPixel($BMP, $iX, $iY)

    _WinAPI_ReleaseDC($WinHandle, $hDDC)
    _WinAPI_DeleteDC($hCDC)
    _WinAPI_DeleteObject($hBMP)
    _GDIPlus_ImageDispose($BMP)

    Return Hex($aPixelColor, 6)
EndFunc   ;==>GetColor