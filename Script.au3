;#RequireAdmin  						;��� ������� BlockInput()
;#include <WinAPISys.au3>			;��� ������� _WinAPI_SetKeyboardLayout()
;$iLanguage 		= '0x0409'			;U.S. ��������� ����������

;��� ����������� ����� ����� � ������ ���������� "Autoit Window Info x86"
;������������� �� ������ C:\Program Files (x86)\AutoIt3\Au3Info.exe
$exeName		= "C:\Lectus\subkey.exe"		;���� � ������������ ����� ���������� ���������� �����
$mainFrame  	= "��������� �����������" ;��������� ���� ���������� ���������� �����
$textBox1 		= "TEdit2"			;������������
$textBox2 		= "TEdit3" 			;�����������
$genBtnText 	= "�������"			;������� �� ������ ��������� �����
$genBtnName 	= "TButton1"		;��� ������ ��������� �����
$someNumber 	= "301800" 			;��� ������������!
$orgName 		= "Owen" 		    ;�������� �����������
$keyFile		= "C:\Lectus\opcserv.key"	;��� ����� � ������
$sourceFile		= "C:\Lectus\Source_key_opcserv_02\opcserv.key"	;��� ����� � ������
$archName		= "C:\Lectus\Disk_Lectus_05\opckey.exe"				;��� ��� �������� sfx-������
$programDir		= "C:\Lectus\Disk_Lectus_05" 							;������� ���������� ��� ������ � ������

$neroExe		= "C:\Program Files (x86)\Nero\Nero 2017\Nero Burning ROM\nero.exe"  	;���� � ������������ �����
$neroWnd		= "Nero Burning ROM"													;����� ��� ��������� ����
$lectusDir 		= "C:\Users\������\Desktop\����_Lectus_05"								;����� ������� ����� ������ �� ���������� ����
$neroNPWnd 		= "����� ������"	;��������� ���� �������� ������ �������
$neroNPBtn 		= "Button52"		;��� ������ ������ �������� ������ �������
$neroNPBtnText 	= "�����"			;����� ������ �������� ������ �������
$neroNPBtnID	= "[ID:6184]"   	;ID ������ �������� ������ �������
$neroAddWnd 	= "�������� ����� � �����"				;��������� ���� ���������� ������ � ������
$neroAddClass	= "[CLASS:DirectUIHWND; INSTANCE:2]"	;����� ���� ������ ������
$neroAddBtnN	= "��������"							;��� ������ ���������� ������ � ������
$neroAddBtnT	= "[CLASS:Button; INSTANCE:1]"			;����� ������ ���������� ������ � ������

;������ ��������� ��������� ��������� ������ � �������: "-�������� ��������"
;�������� ������ ������� ��� ���� �������� �� ���������
;Script.exe -exeName keygen.exe -mainFrame "��������� �����" -textBox1 [NAME:textBox1] -textBox2 [NAME:textBox2]
;			-genBtnText "������� ����" -genBtnName [NAME:button1] -someNumber 301832 -orgName Pochtamt -keyFile keyfile
;			-archName archKey.exe -programDir C:\Users\1ff1e\Desktop\autoit\new

For $i = 1 To $CmdLine[0]
   Switch $CmdLine[$i]
	Case "-someNumber"
	  $someNumber 	= $CmdLine[$i+1]
	Case "-orgName"
	  $orgName 		= $CmdLine[$i+1]
	Case "-keyFile"
	  $keyFile 		= $CmdLine[$i+1]
	Case "-archName"
	  $archName 	= $CmdLine[$i+1]
	Case "-programDir"
	  $programDir	= $CmdLine[$i+1]
   EndSwitch
Next

;������ ���������� - ������� ��� (� ����� ���� �� � ������� �����)!
Run($exeName)
   ;��������� ���� � ���������� � ����
   BlockInput(1)
   ;��������� ��������� �����
   $hWnd = WinWait($mainFrame, "", 1)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(0, '��������!', "������ �� ������!")
	  Exit
   EndIf
   ;_WinAPI_SetKeyboardLayout( $hWnd, $iLanguage)
   ;������ ������ � ��������� ����
   ControlSend($hWnd, "", "TEdit4", $sourceFile)
   ControlSend($hWnd, "", $textBox2, $orgName)
   ControlSend($hWnd, "", $textBox1, $someNumber)
   BlockInput(0)
   Sleep(10000)  ;�������� �� ���� ����� �������������  <============================
   BlockInput(1)


   ;���� ���������
   ControlClick($hWnd, "�������", "TButton1")

   ;��������
   WinClose($hWnd)

   ;������ sfx-�����
   ;��������� ����� 7z.sfx � 7za.exe � ����� �������
   RunWait(@ComSpec & " /c " & "7za.exe a -sfx7z.sfx " & $archName & ' "' & $keyFile & '"')
   BlockInput(0)
Run($neroExe)

   ;��������� ���� � ���������� � ����
   BlockInput(1)

   ;��������� Nero Burning ROM
   $hWnd = WinWait($neroWnd, "", 1)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '��������!', "Nero �� ������!")
	  Exit
   EndIf

   ControlClick($hWnd, $neroNPWnd, $neroNPBtn)

   ; ������� ���� "����� ������"
   $hWnd = WinWaitActive($neroNPWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
	  Exit
   EndIf
   ControlClick($neroNPWnd, $neroNPBtnText, $neroNPBtnID)

   ; ������� ���� $neroWnd
   $hWnd = WinWaitActive($neroWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
	  Exit
   EndIf
   Sleep(1000)
   Send("{APPSKEY}")
   Send("{UP 4}")
   Send("{ENTER}")
   Sleep(2000)
   Send($lectusDir)
   Send("{ENTER}")
   ; ������� ���� "�������� ����� � �����"
   $hWnd = WinWaitActive($neroAddWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
	  Exit
   EndIf
   ControlClick($neroAddWnd, "", $neroAddClass)


   Sleep(1000)
   Send("{CTRLDOWN}")
   Sleep(100)
   Send("{a}")
   Sleep(1000)
   Send("{CTRLUP}")

   ; ������� ���� "�������� ����� � �����"
   $hWnd = WinWaitActive($neroAddWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
	  Exit
   EndIf
   ControlClick($neroAddWnd, $neroAddBtnN, $neroAddBtnT)
   Sleep(1000)
   Send("{CTRLDOWN}")
   Sleep(100)
   Send("{b}")
   Sleep(100)
   Send("{CTRLUP}")

BlockInput(0)

Exit