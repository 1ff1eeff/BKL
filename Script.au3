;#RequireAdmin  						;для функции BlockInput()
;#include <WinAPISys.au3>			;для функции _WinAPI_SetKeyboardLayout()
;$iLanguage 		= '0x0409'			;U.S. раскладка клавиатуры

;Для определения имени полей и кнопок используем "Autoit Window Info x86"
;распологается по адресу C:\Program Files (x86)\AutoIt3\Au3Info.exe
$exeName		= "C:\Lectus\subkey.exe"		;путь к исполняемому файлу приложения создающего ключи
$mainFrame  	= "Генератор сублицензий" ;заголовок окна приложения создающего ключи
$textBox1 		= "TEdit2"			;пользователь
$textBox2 		= "TEdit3" 			;организация
$genBtnText 	= "Создать"			;надпись на кнопке генерации ключа
$genBtnName 	= "TButton1"		;имя кнопки генерации ключа
$someNumber 	= "301800" 			;имя пользователя!
$orgName 		= "Owen" 		    ;название организации
$keyFile		= "C:\Lectus\opcserv.key"	;имя файла с ключом
$sourceFile		= "C:\Lectus\Source_key_opcserv_02\opcserv.key"	;имя файла с ключом
$archName		= "C:\Lectus\Disk_Lectus_05\opckey.exe"				;имя для будущего sfx-архива
$programDir		= "C:\Lectus\Disk_Lectus_05" 							;каталог назначения для архива с ключом

$neroExe		= "C:\Program Files (x86)\Nero\Nero 2017\Nero Burning ROM\nero.exe"  	;путь к исполняемому файлу
$neroWnd		= "Nero Burning ROM"													;класс или заголовок окна
$lectusDir 		= "C:\Users\Андрей\Desktop\Диск_Lectus_05"								;папка которую будем писать на оптический диск
$neroNPWnd 		= "Новый проект"	;заголовок окна создания нового проекта
$neroNPBtn 		= "Button52"		;имя класса кнопки создания нового проекта
$neroNPBtnText 	= "Новый"			;текст кнопки создания нового проекта
$neroNPBtnID	= "[ID:6184]"   	;ID кнопки создания нового проекта
$neroAddWnd 	= "Добавить файлы и папки"				;заголовок окна добавления файлов в проект
$neroAddClass	= "[CLASS:DirectUIHWND; INSTANCE:2]"	;класс поля выбора файлов
$neroAddBtnN	= "Добавить"							;имя кнопки добавления файлов в проект
$neroAddBtnT	= "[CLASS:Button; INSTANCE:1]"			;класс кнопки добавления файлов в проект

;Скрипт принимает параметры командной строки в формате: "-аргумент значение"
;Например строка запуска для всех значений по умолчанию
;Script.exe -exeName keygen.exe -mainFrame "Генератор ключа" -textBox1 [NAME:textBox1] -textBox2 [NAME:textBox2]
;			-genBtnText "Создать ключ" -genBtnName [NAME:button1] -someNumber 301832 -orgName Pochtamt -keyFile keyfile
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

;Запуск генератора - указать имя (и адрес если не в рабочей папке)!
Run($exeName)
   ;Отключаем ввод с клавиатуры и мыши
   BlockInput(1)
   ;Запускаем генератор ключа
   $hWnd = WinWait($mainFrame, "", 1)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(0, 'Внимание!', "Кейген не найден!")
	  Exit
   EndIf
   ;_WinAPI_SetKeyboardLayout( $hWnd, $iLanguage)
   ;Вводим данные в текстовые поля
   ControlSend($hWnd, "", "TEdit4", $sourceFile)
   ControlSend($hWnd, "", $textBox2, $orgName)
   ControlSend($hWnd, "", $textBox1, $someNumber)
   BlockInput(0)
   Sleep(10000)  ;ОЖИДАНИЕ НА ВВОД ИМЕНИ ПОЛЬЗОВАТЕЛЬЯ  <============================
   BlockInput(1)


   ;Жмем генерацию
   ControlClick($hWnd, "Создать", "TButton1")

   ;Закрытие
   WinClose($hWnd)

   ;Создаём sfx-архив
   ;Требуются файлы 7z.sfx и 7za.exe в папке скрипта
   RunWait(@ComSpec & " /c " & "7za.exe a -sfx7z.sfx " & $archName & ' "' & $keyFile & '"')
   BlockInput(0)
Run($neroExe)

   ;Отключаем ввод с клавиатуры и мыши
   BlockInput(1)

   ;Запускаем Nero Burning ROM
   $hWnd = WinWait($neroWnd, "", 1)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Внимание!', "Nero не найден!")
	  Exit
   EndIf

   ControlClick($hWnd, $neroNPWnd, $neroNPBtn)

   ; Ожидаем окно "Новый проект"
   $hWnd = WinWaitActive($neroNPWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
	  Exit
   EndIf
   ControlClick($neroNPWnd, $neroNPBtnText, $neroNPBtnID)

   ; Ожидаем окно $neroWnd
   $hWnd = WinWaitActive($neroWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
	  Exit
   EndIf
   Sleep(1000)
   Send("{APPSKEY}")
   Send("{UP 4}")
   Send("{ENTER}")
   Sleep(2000)
   Send($lectusDir)
   Send("{ENTER}")
   ; Ожидаем окно "Добавить файлы и папки"
   $hWnd = WinWaitActive($neroAddWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
	  Exit
   EndIf
   ControlClick($neroAddWnd, "", $neroAddClass)


   Sleep(1000)
   Send("{CTRLDOWN}")
   Sleep(100)
   Send("{a}")
   Sleep(1000)
   Send("{CTRLUP}")

   ; Ожидаем окно "Добавить файлы и папки"
   $hWnd = WinWaitActive($neroAddWnd, "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
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