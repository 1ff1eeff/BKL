#RequireAdmin  ;для функции BlockInput()
#include <WinAPISys.au3>	;для функции _WinAPI_SetKeyboardLayout()

;Для определения имени полей и кнопок используем "Autoit Window Info x86"
;распологается по адресу C:\Program Files (x86)\AutoIt3\Au3Info.exe
$exeName	= "keygen.exe"		;путь к исполняемому файлу приложения создающего ключи
$mainFrame  = "Генератор ключа" ;класс или заголовок окна приложения создающего ключи
$textBox1 	= "[NAME:textBox1]" ;имена текстовых полей ввода
$textBox2 	= "[NAME:textBox2]" ;имена текстовых полей ввода
$genBtnText = "Создать ключ"	;надпись на кнопке генерации ключа
$genBtnName = "[NAME:button1]"	;имя кнопки генерации ключа
$someNumber = "301800" 			;какое-то число
$orgName 	= "Pochtamt" 		;название организации
$keyFile	= "keyfile"			;имя файла с ключом
$archName	= "archKey.exe"		;имя для будущего sfx-архива
$programDir	= "Lectus\key" 		;каталог назначения для архива с ключом

$neroExe	= "C:\Program Files (x86)\Nero\Nero 2017\Nero Burning ROM\nero.exe"  	;путь к исполняемому файлу Nero Burning ROM
$neroWnd	= "Nero Burning ROM"													;класс или заголовок окна Nero Burning ROM
$lectusDir = "C:\Users\1ff1e\Desktop\autoit\Lectus"									;папка которую необходимо записать
$iLanguage = '0x0409'			;U.S. раскладка клавиатуры

;Скрипт принимает параметры командной строки в формате: "-аргумент значение"
;Например строка запуска для всех значений по умолчанию
;Script.exe -exeName keygen.exe -mainFrame "Генератор ключа" -textBox1 [NAME:textBox1] -textBox2 [NAME:textBox2]
;			-genBtnText "Создать ключ" -genBtnName [NAME:button1] -someNumber 301832 -orgName Pochtamt -keyFile keyfile
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
   ;Вводим данные в текстовые поля
   ControlSend($hWnd, "", $textBox1, $someNumber)
   ControlSend($hWnd, "", $textBox2, $orgName)
   ;Жмем генерацию
   ControlClick($hWnd, $genBtnText, $genBtnName)
   ;Закрытие
   WinClose($hWnd)
   ;Создаём sfx-архив
   ;Требуются файлы 7z.sfx и 7za.exe в папке скрипта
   RunWait(@ComSpec & " /c " & "7za.exe a -sfx7z.sfx " & $archName & " " & $keyFile)
   If FileExists($programDir) Then
	  FileCopy($archName, $programDir & "\*.*") ;Копируем полученый архив в папку программы
	  FileDelete ($archName)					;и удаляем его из рабочей папки
	  FileDelete ($keyFile)						;также удаляем файл ключа из рабочей папки
   Else
	  DirCreate($programDir)					;Создаём каталог если его нет по указанному адресу
	  FileCopy($archName, $programDir & "\*.*") ;Копируем полученый архив в папку программы
	  FileDelete ($archName)					;и удаляем его из рабочей папки
	  FileDelete ($keyFile)						;также удаляем файл ключа из рабочей папки
   EndIf


Run($neroExe)

   ;Отключаем ввод с клавиатуры и мыши
   BlockInput(1)

   ;Запускаем Nero Burning ROM
   $hWnd = WinWait($neroWnd, "", 1)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(0, 'Внимание!', "Nero не найден!")
	  Exit
   EndIf
   ControlClick($hWnd, "Новый проект", "Button52")

   ; Ожидаем окно "Новый проект"
   $hWnd = WinWaitActive("Новый проект", "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
	  Exit
   EndIf
   ControlClick("Новый проект", "Новый", "[ID:6184]")

   ;_WinAPI_SetKeyboardLayout( $hWnd, $iLanguage)

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
   Send($lectusDir)
   Send("{ENTER}")

   ; Ожидаем окно "Добавить файлы и папки"
   $hWnd = WinWaitActive("Добавить файлы и папки", "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
	  Exit
   EndIf
   ControlClick("Добавить файлы и папки", "", "[CLASS:DirectUIHWND; INSTANCE:2]")
   Sleep(1000)
   Send("{CTRLDOWN}")
   Sleep(100)
   Send("{a}")
   Sleep(1000)
   Send("{CTRLUP}")
   ; Ожидаем окно "Добавить файлы и папки"
   $hWnd = WinWaitActive("Добавить файлы и папки", "", 5)
   If Not $hWnd Then
	  BlockInput(0)
	  MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
	  Exit
   EndIf
   ControlClick("Добавить файлы и папки", "Добавить", "[CLASS:Button; INSTANCE:1]")
   Sleep(1000)
   Send("{CTRLDOWN}")
   Sleep(100)
   Send("{b}")
   Sleep(100)
   Send("{CTRLUP}")
   ;Sleep(3000)

   ; Ожидаем окно "Записать проект"
   ;$hWnd = WinWaitActive("Записать проект", "", 5)
   ;If Not $hWnd Then
   ;	BlockInput(0)
   ;	MsgBox(4096, 'Сообщение', 'Окно не найдено, завершаем работу скрипта')
   ;	Exit
   ;EndIf
   ;ControlClick("Записать проект", "Прожиг", "[CLASS:Button; INSTANCE:52]")
   ;Sleep(1000)
   ;Закрытие
   ;WinClose($hWnd)
   ;Sleep(1000)
   ;ControlClick("Сохранить проект", "Нет", "[CLASS:Button; INSTANCE:3]")

   ;Возвращаем ввод с клавиатуры и мыши(необязательно)
   BlockInput(0)

Exit