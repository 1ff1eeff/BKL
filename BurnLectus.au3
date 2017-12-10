#RequireAdmin  ;��� ������� BlockInput()
#include <WinAPISys.au3>	;��� ������� _WinAPI_SetKeyboardLayout()

;��� ����������� ����� ����� � ������ ���������� "Autoit Window Info x86"
;������������� �� ������ C:\Program Files (x86)\AutoIt3\Au3Info.exe
$exeName	= "keygen.exe"		;���� � ������������ ����� ���������� ���������� �����
$mainFrame  = "��������� �����" ;����� ��� ��������� ���� ���������� ���������� �����
$textBox1 	= "[NAME:textBox1]" ;����� ��������� ����� �����
$textBox2 	= "[NAME:textBox2]" ;����� ��������� ����� �����
$genBtnText = "������� ����"	;������� �� ������ ��������� �����
$genBtnName = "[NAME:button1]"	;��� ������ ��������� �����
$someNumber = "301800" 			;�����-�� �����
$orgName 	= "Pochtamt" 		;�������� �����������
$keyFile	= "keyfile"			;��� ����� � ������
$archName	= "archKey.exe"		;��� ��� �������� sfx-������
$programDir	= "Lectus\key" 		;������� ���������� ��� ������ � ������

$neroExe	= "C:\Program Files (x86)\Nero\Nero 2017\Nero Burning ROM\nero.exe"  	;���� � ������������ ����� Nero Burning ROM
$neroWnd	= "Nero Burning ROM"													;����� ��� ��������� ���� Nero Burning ROM
$lectusDir = "C:\Users\1ff1e\Desktop\autoit\Lectus"									;����� ������� ���������� ��������
$iLanguage = '0x0409'			;U.S. ��������� ����������

;������ ��������� ��������� ��������� ������ � �������: "-�������� ��������"
;�������� ������ ������� ��� ���� �������� �� ���������
;Script.exe -exeName keygen.exe -mainFrame "��������� �����" -textBox1 [NAME:textBox1] -textBox2 [NAME:textBox2]
;			-genBtnText "������� ����" -genBtnName [NAME:button1] -someNumber 301832 -orgName Pochtamt -keyFile keyfile
;			-archName archKey.exe -programDir C:\Users\1ff1e\Desktop\autoit\new

For $i = 1 To $CmdLine[0]
   Switch $CmdLine[$i]
    Case "-exeName"
      $exeName 		= $CmdLine[$i+1]
    Case "-mainFrame"
      $mainFrame 	= $CmdLine[$i+1]
    Case "-textBox1"
      $textBox1 	= $CmdLine[$i+1]
    Case "-textBox2"
      $textBox2 	= $CmdLine[$i+1]
    Case "-genBtnText"
      $genBtnText 	= $CmdLine[$i+1]
    Case "-genBtnName"
      $genBtnName 	= $CmdLine[$i+1]
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
   ;������ ������ � ��������� ����
   ControlSend($hWnd, "", $textBox1, $someNumber)
   ControlSend($hWnd, "", $textBox2, $orgName)
   ;���� ���������
   ControlClick($hWnd, $genBtnText, $genBtnName)
   ;��������
   WinClose($hWnd)
   ;������ sfx-�����
   ;��������� ����� 7z.sfx � 7za.exe � ����� �������
   RunWait(@ComSpec & " /c " & "7za.exe a -sfx7z.sfx " & $archName & " " & $keyFile)
   If FileExists($programDir) Then
	  FileCopy($archName, $programDir & "\*.*") ;�������� ��������� ����� � ����� ���������
	  FileDelete ($archName)					;� ������� ��� �� ������� �����
	  FileDelete ($keyFile)						;����� ������� ���� ����� �� ������� �����
   Else
	  DirCreate($programDir)					;������ ������� ���� ��� ��� �� ���������� ������
	  FileCopy($archName, $programDir & "\*.*") ;�������� ��������� ����� � ����� ���������
	  FileDelete ($archName)					;� ������� ��� �� ������� �����
	  FileDelete ($keyFile)						;����� ������� ���� ����� �� ������� �����
   EndIf


Run($neroExe)

   ;��������� ���� � ���������� � ����
   BlockInput(1)

   ;��������� Nero Burning ROM
   $hWnd = WinWait($neroWnd, "", 1)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(0, '��������!', "Nero �� ������!")
	  Exit
   EndIf
   ControlClick($hWnd, "����� ������", "Button52")

   ; ������� ���� "����� ������"
   $hWnd = WinWaitActive("����� ������", "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
	  Exit
   EndIf
   ControlClick("����� ������", "�����", "[ID:6184]")

   ;_WinAPI_SetKeyboardLayout( $hWnd, $iLanguage)

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
   Send($lectusDir)
   Send("{ENTER}")

   ; ������� ���� "�������� ����� � �����"
   $hWnd = WinWaitActive("�������� ����� � �����", "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
	  Exit
   EndIf
   ControlClick("�������� ����� � �����", "", "[CLASS:DirectUIHWND; INSTANCE:2]")
   Sleep(1000)
   Send("{CTRLDOWN}")
   Sleep(100)
   Send("{a}")
   Sleep(1000)
   Send("{CTRLUP}")
   ; ������� ���� "�������� ����� � �����"
   $hWnd = WinWaitActive("�������� ����� � �����", "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
	  Exit
   EndIf
   ControlClick("�������� ����� � �����", "��������", "[CLASS:Button; INSTANCE:1]")
   Sleep(1000)
   Send("{CTRLDOWN}")
   Sleep(100)
   Send("{b}")
   Sleep(100)
   Send("{CTRLUP}")
   ;Sleep(3000)

   ; ������� ���� "�������� ������"
   ;$hWnd = WinWaitActive("�������� ������", "", 5)
   ;If Not $hWnd Then
   ;	BlockInput(0)
   ;	MsgBox(4096, '���������', '���� �� �������, ��������� ������ �������')
   ;	Exit
   ;EndIf
   ;ControlClick("�������� ������", "������", "[CLASS:Button; INSTANCE:52]")
   ;Sleep(1000)
   ;��������
   ;WinClose($hWnd)
   ;Sleep(1000)
   ;ControlClick("��������� ������", "���", "[CLASS:Button; INSTANCE:3]")

   ;���������� ���� � ���������� � ����(�������������)
   BlockInput(0)

Exit