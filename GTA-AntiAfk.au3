;;;;;;;;;;;;;;;;;  Petyus, GTA Online Tools ;;;
#RequireAdmin
#include <Date.au3>
Opt("WinTitleMatchMode", 2)

HotKeySet ( "^{ENTER}", LoopEnter )
HotKeySet ( "!{PAUSE}", PauseEthernet )
HotKeySet ( "{PAUSE}", PauseGta )
HotKeySet ( "{F1}", UseArmor )

global $hardMode = True ;Activate gta window, to keepalive gta session
global $lazyHardMode = True
global $searchGtaSessionClock = 1000;ms
global $antiAfkClock = 105000;ms
global $antiAfkKey = "{ALT}"
global $netCardId = 2 ;Use GetNetCardID Helper file, to get your id and replace that
global $paused = false
global $loopEnter = false
global $ethernetOff = false
global $GtaHwnd, $lastWindowHwnd

While 1
   if (getGtaHwnd()) then
	  startAntiAfk()
   Else
	  ConsoleWrite_("GTA is not running")
   EndIf
   sleep($searchGtaSessionClock)
WEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func getGtaHwnd()
   $GtaHwnd = WinGetHandle("Grand Theft Auto")
   if ($GtaHwnd Not= 0x00000000) then return True
   return False
EndFunc

Func startAntiAfk()
   getGtaHwnd()
   Do
	   if ($hardMode) then GtaActivate()
	  antiAfk()
   Until Not WinActive($GtaHwnd)
   ConsoleWrite_("GTA window is not active")
EndFunc

Func antiAfk()
   Opt("SendKeyDownDelay", Random(70, 120))
   Send($antiAfkKey)
   ConsoleWrite_("AntiAfk Triggered")
   Sleep(420)
   If ($hardMode and $lazyHardMode) then
	  If Not($lastWindowHwnd == WinActive($GtaHwnd)) then
		 WinActivate($lastWindowHwnd)
	  EndIf
   EndIf
   sleep($antiAfkClock)
EndFunc

Func gtaActivate()
   getGtaHwnd()
   if ($hardMode and $lazyHardMode) then $lastWindowHwnd = WinGetHandle("")
   WinActivate($GtaHwnd)
   WinWaitActive($GtaHwnd)
   Sleep(50)
EndFunc

Func PauseGta()
   if ($paused == false) then
	  _ProcessSuspend("GTA5.exe")
	  ConsoleWrite_("GTA5: Paused")
	  $paused = true
   Else
	  _ProcessResume("GTA5.exe")
	  ConsoleWrite_("GTA5: Resumed")
	  $paused = false
   EndIf
EndFunc

Func UseArmor()
   iteratedSend("m", 1)
   sleep(300)
   iteratedSend("{DOWN}", 2)
   iteratedSend("{ENTER}", 1)
   iteratedSend("{DOWN}", 1)
   iteratedSend("{ENTER}", 1)
   iteratedSend("{UP}", 3)
   iteratedSend("{ENTER}", 1)
   iteratedSend("{ESC}", 3)0
EndFunc



;utils
Func ConsoleWrite_($text)
   $Scite = WinGetHandle("SciTE")
   If ($Scite Not= 0x00000000) then
	  ControlSetText($Scite, '', 'Scintilla2', '')
	  ConsoleWrite( _NowTime(5) & " - " & $text)
   EndIf
EndFunc

Func iteratedSend($key, $i)
   Opt("SendKeyDownDelay", 40)
   Opt("SendKeyDelay", 30)
   For $z = $i To 1 Step -1
	  ConsoleWrite($key)
	  Send($key)
	  Sleep(300)
   Next
EndFunc

;Process Suspend/Process Resume UDF
Func _ProcessSuspend($process)
$processid = ProcessExists($process)
If $processid Then
    $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
    $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then
        Return 1
    Else
        SetError(1)
        Return 0
    Endif
Else
    SetError(2)
    Return 0
Endif
EndFunc
Func _ProcessResume($process)
$processid = ProcessExists($process)
If $processid Then
    $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
    $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then
        Return 1
    Else
        SetError(1)
        Return 0
    Endif
Else
    SetError(2)
    Return 0
Endif
EndFunc


Func ethernetOff()
   $CMD = 'wmic path win32_networkadapter where index=' & $netCardId & ' call disable'
   Run('"' & @ComSpec & '" /c ' & $CMD, @SystemDir)
EndFunc
Func ethernetOn()
   $CMD = 'wmic path win32_networkadapter where index=' & $netCardId & ' call enable'
   Run('"' & @ComSpec & '" /c ' & $CMD, @SystemDir)
EndFunc
Func PauseEthernet()
   if ($ethernetOff == false) then
	  ethernetOff()
	  ConsoleWrite_("Ethernet: Paused")
	  $ethernetOff = true
   Else
	  ethernetOn()
	  ConsoleWrite_("Ethernet: Resumed")
	  $ethernetOff = false
   EndIf
EndFunc




Func LoopEnter()
   if ($loopEnter == false) then
	  ConsoleWrite_("GTA5: LoopEnter Started")
	  $loopEnter = true
	  While $loopEnter
		 Send("{ENTER}")
		 Sleep(300)
	  WEnd
   Else
	  ConsoleWrite_("GTA5: LoopEnter Resumed")
	  $loopEnter = false
   EndIf
EndFunc